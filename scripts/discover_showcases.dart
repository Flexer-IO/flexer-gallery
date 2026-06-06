// Flexer Showcase Discovery Agent.
//
// Searches GitHub broadly for Flutter repos (keyword: flutter, language:dart),
// scores each with AI (multi-provider, multi-key), and opens PRs to
// flexer-io/flexer-gallery for human review.
//
// Each PR adds:
//   lib/<id>/<id>_page.dart
//   lib/<id>/showcase_info.dart
//   (patches pubspec.yaml with any missing deps)
//
// Required env vars:
//   GH_TOKEN           PAT with repo scope on both repos
//   SHOWCASE_REPO      target repo (default: flexer-io/flexer-gallery)
//   At least one AI provider key (see below)
//
// AI provider env vars — add as many keys per provider as you have accounts.
// Each value is comma-separated keys. Providers tried in order; keys rotated on 429.
//
//   GEMINI_API_KEYS     ai.google.dev           — free, best quality,  15 req/min/key
//   DEEPSEEK_API_KEYS   platform.deepseek.com   — near-free, excellent code reasoning
//   GROQ_API_KEYS       console.groq.com        — free, fastest,       30 req/min/key
//   CEREBRAS_API_KEYS   cloud.cerebras.ai       — free, very fast,     30 req/min/key
//   SAMBANOVA_API_KEYS  cloud.sambanova.ai      — free
//   NVIDIA_API_KEYS     build.nvidia.com        — 1000 credits/month free
//   TOGETHER_API_KEYS   api.together.ai         — $1 free credit
//   OPENROUTER_API_KEYS openrouter.ai           — free models available
//   MISTRAL_API_KEYS    console.mistral.ai      — free tier
//
//   Example: GEMINI_API_KEYS=key1,key2  DEEPSEEK_API_KEYS=key3,key4
//
// Optional:
//   TARGET_USER    GitHub username — evaluate all their Dart repos
//   TARGET_REPO    Full repo URL or owner/name — evaluate only this repo

import 'dart:convert';
import 'dart:io';

// ─── Config ───────────────────────────────────────────────────────────────────

final _ghToken = Platform.environment['GH_TOKEN']!;
final _showcaseRepo =
    Platform.environment['SHOWCASE_REPO'] ?? 'flexer-io/flexer-gallery';
final _targetUser = Platform.environment['TARGET_USER'] ?? '';
final _targetRepo = Platform.environment['TARGET_REPO'] ?? '';

const _minStars = 30;
const _maxCandidatesToEvaluate = 12; // hard cap — keeps runtime predictable
const _maxPerRun = 3;
const _geminiDelaySec = 5; // inter-call delay (Gemini free tier = 15 req/min)

// One broad query split into non-overlapping date ranges.
// Each returns a distinct slice of the pool sorted by stars.
const _searchQueries = [
  'flutter language:dart stars:>30 pushed:2024-01-01..2026-12-31',
  'flutter language:dart stars:>30 pushed:2022-01-01..2023-12-31',
  'flutter language:dart stars:>30 pushed:2020-01-01..2021-12-31',
  'flutter language:dart stars:>30 pushed:2018-01-01..2019-12-31',
];

const _builtinPackages = {
  'flutter',
  'flutter_test',
  'flutter_localizations',
  'sky_engine',
  'cupertino_icons',
};

const _skipDescriptionWords = {
  'tutorial',
  'course',
  'template',
  'boilerplate',
  'starter',
  'clone',
};

// ─── HTTP helpers (with rate-limit retry) ─────────────────────────────────────

Map<String, String> get _ghHeaders => {
  'Authorization': 'Bearer $_ghToken',
  'Accept': 'application/vnd.github+json',
  'X-GitHub-Api-Version': '2022-11-28',
};

Future<String?> _httpGet(
  String url,
  Map<String, String> headers, {
  int retries = 3,
}) async {
  for (var attempt = 0; attempt < retries; attempt++) {
    final client = HttpClient();
    try {
      final request = await client.getUrl(Uri.parse(url));
      headers.forEach(request.headers.set);
      final response = await request.close();

      if (response.statusCode == 200) {
        return await response.transform(utf8.decoder).join();
      }

      // Rate limited — respect Retry-After or default to 60s.
      if (response.statusCode == 429 || response.statusCode == 403) {
        await response.drain<void>();
        final retryAfter =
            int.tryParse(response.headers.value('retry-after') ?? '') ?? 60;
        print(
          '  Rate limited (${response.statusCode}) — sleeping ${retryAfter}s',
        );
        await Future<void>.delayed(Duration(seconds: retryAfter));
        continue;
      }

      await response.drain<void>();
      return null;
    } catch (e) {
      print('  GET failed (attempt ${attempt + 1}): $e');
      if (attempt < retries - 1) {
        await Future<void>.delayed(const Duration(seconds: 5));
      }
    } finally {
      client.close();
    }
  }
  return null;
}

// ─── GitHub helpers ───────────────────────────────────────────────────────────

Future<Map<String, dynamic>?> ghRepoInfo(String ownerRepo) async {
  final raw = await _httpGet(
    'https://api.github.com/repos/$ownerRepo',
    _ghHeaders,
  );
  if (raw == null) return null;
  return jsonDecode(raw) as Map<String, dynamic>;
}

Future<List<Map<String, dynamic>>> ghUserRepos(String username) async {
  final url = Uri.https('api.github.com', '/users/$username/repos', {
    'type': 'owner',
    'per_page': '100',
    'sort': 'updated',
  }).toString();

  final raw = await _httpGet(url, _ghHeaders);
  if (raw == null) return [];
  final list = jsonDecode(raw) as List;
  return list
      .cast<Map<String, dynamic>>()
      .where(
        (r) =>
            r['language'] == 'Dart' &&
            r['fork'] == false &&
            (r['stargazers_count'] as int) >= _minStars,
      )
      .toList();
}

Future<List<Map<String, dynamic>>> ghSearch(String query) async {
  final url = Uri.https('api.github.com', '/search/repositories', {
    'q': query,
    'sort': 'stars',
    'order': 'desc',
    'per_page': '30',
  }).toString();

  final raw = await _httpGet(url, _ghHeaders);
  if (raw == null) return [];
  final data = jsonDecode(raw) as Map<String, dynamic>;
  return List<Map<String, dynamic>>.from(data['items'] as List? ?? []);
}

Future<String?> ghFile(String repo, String path) async {
  return _httpGet('https://api.github.com/repos/$repo/contents/$path', {
    ..._ghHeaders,
    'Accept': 'application/vnd.github.raw+json',
  });
}

Future<List<Map<String, dynamic>>> ghTree(String repo) async {
  final raw = await _httpGet(
    'https://api.github.com/repos/$repo/git/trees/HEAD?recursive=1',
    _ghHeaders,
  );
  if (raw == null) return [];
  final data = jsonDecode(raw) as Map<String, dynamic>;
  return List<Map<String, dynamic>>.from(data['tree'] as List? ?? []);
}

Future<bool> repoHasDart(String repo) async {
  final raw = await _httpGet(
    'https://api.github.com/repos/$repo/languages',
    _ghHeaders,
  );
  if (raw == null) return false;
  return (jsonDecode(raw) as Map<String, dynamic>).containsKey('Dart');
}

// ─── Rejected-repo persistence ───────────────────────────────────────────────
//
// lib/.rejected in the gallery repo stores one full_name (owner/repo) per line.
// Repos scored below threshold are appended so future runs skip them before
// making any AI call.

Future<(Set<String>, String)> fetchRejectedRepos() async {
  final raw = await _httpGet(
    'https://api.github.com/repos/$_showcaseRepo/contents/lib/.rejected',
    _ghHeaders,
  );
  if (raw == null) return (<String>{}, '');
  try {
    final data = jsonDecode(raw) as Map<String, dynamic>;
    final sha = data['sha'] as String? ?? '';
    final encoded = (data['content'] as String? ?? '').replaceAll('\n', '');
    final decoded = utf8.decode(base64.decode(encoded));
    final repos = decoded
        .split('\n')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toSet();
    return (repos, sha);
  } catch (e) {
    print('  Could not parse rejected list: $e');
    return (<String>{}, '');
  }
}

Future<void> saveRejectedRepos(Set<String> repos, String sha) async {
  if (repos.isEmpty) return;
  final content = base64.encode(
    utf8.encode('${(repos.toList()..sort()).join('\n')}\n'),
  );
  final body = <String, dynamic>{
    'message': 'chore: update rejected repos list [skip ci]',
    'content': content,
    if (sha.isNotEmpty) 'sha': sha,
  };

  final client = HttpClient();
  try {
    final request = await client.putUrl(
      Uri.parse(
        'https://api.github.com/repos/$_showcaseRepo/contents/lib/.rejected',
      ),
    );
    final encoded = utf8.encode(jsonEncode(body));
    _ghHeaders.forEach(request.headers.set);
    request.headers.set('content-type', 'application/json; charset=utf-8');
    request.headers.set('content-length', encoded.length.toString());
    request.add(encoded);
    final response = await request.close();
    await response.drain<void>();
    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Rejected list saved (${repos.length} total entries)');
    } else {
      print('  Failed to save rejected list: ${response.statusCode}');
    }
  } catch (e) {
    print('  Error saving rejected list: $e');
  } finally {
    client.close();
  }
}

Future<Set<String>> alreadySubmittedUrls() async {
  final urls = <String>{};

  // From committed showcase_info.dart files (merged showcases).
  final treeResult = await _run([
    'gh',
    'api',
    'repos/$_showcaseRepo/git/trees/HEAD?recursive=1',
  ]);
  if (treeResult.exitCode == 0) {
    final data = jsonDecode(treeResult.stdout) as Map<String, dynamic>;
    final tree = List<Map<String, dynamic>>.from(data['tree'] as List? ?? []);
    for (final f in tree) {
      if ((f['path'] as String).endsWith('showcase_info.dart')) {
        final content = await ghFile(_showcaseRepo, f['path'] as String) ?? '';
        final m = RegExp(r"githubRepoUrl:\s*'([^']+)'").firstMatch(content);
        if (m != null) urls.add(m.group(1)!.replaceAll(RegExp(r'/$'), ''));
      }
    }
  }

  // From ALL PRs — open, closed, and merged — so we never re-submit.
  final prResult = await _run([
    'gh', 'pr', 'list',
    '--repo', _showcaseRepo,
    '--state', 'all', // ← covers open + closed + merged
    '--json', 'body',
    '--limit', '200',
  ]);
  if (prResult.exitCode == 0) {
    final prs = List<Map<String, dynamic>>.from(
      jsonDecode(prResult.stdout) as List,
    );
    for (final pr in prs) {
      final m = RegExp(
        r'github\.com/([a-zA-Z0-9_.-]+/[a-zA-Z0-9_.-]+)',
      ).firstMatch(pr['body'] as String? ?? '');
      if (m != null) urls.add('https://github.com/${m.group(1)}');
    }
  }

  return urls;
}

List<String> topDartFiles(List<Map<String, dynamic>> tree) {
  final files =
      tree
          .where(
            (f) =>
                (f['path'] as String).endsWith('.dart') &&
                (f['path'] as String).startsWith('lib/') &&
                !(f['path'] as String).toLowerCase().contains('test') &&
                (f['size'] as int? ?? 999999) < 40000,
          )
          .map((f) => f['path'] as String)
          .toList()
        ..sort((a, b) => a.split('/').length.compareTo(b.split('/').length));
  return files.take(8).toList();
}

// ─── Dep merging ──────────────────────────────────────────────────────────────

Map<String, String> parseDeps(String pubspecText) {
  final deps = <String, String>{};
  final inDeps =
      RegExp(
        r'^dependencies:\s*\n((?:[ \t]+.+\n?)*)',
        multiLine: true,
      ).firstMatch(pubspecText)?.group(1) ??
      '';

  for (final line in inDeps.split('\n')) {
    final m = RegExp(r'^  ([a-z][a-z0-9_-]*):\s*(.*)$').firstMatch(line);
    if (m == null) continue;
    final name = m.group(1)!;
    final version = m.group(2)!.trim();
    if (_builtinPackages.contains(name)) continue;
    if (version.contains('sdk:') ||
        version.contains('path:') ||
        version.contains('git:'))
      continue;
    deps[name] = version.isEmpty ? 'any' : version;
  }
  return deps;
}

Map<String, String> computeMissingDeps(
  String sourcePubspec,
  String libraryPubspec,
) {
  final source = parseDeps(sourcePubspec);
  final library = parseDeps(libraryPubspec);
  return {
    for (final entry in source.entries)
      if (!library.containsKey(entry.key)) entry.key: entry.value,
  };
}

String mergeDepsIntoPubspec(String pubspecText, Map<String, String> newDeps) {
  if (newDeps.isEmpty) return pubspecText;
  final lines = pubspecText.split('\n');
  var insertAt = -1;
  var inDeps = false;

  for (var i = 0; i < lines.length; i++) {
    if (RegExp(r'^dependencies:\s*$').hasMatch(lines[i])) {
      inDeps = true;
      insertAt = i + 1;
      continue;
    }
    if (inDeps) {
      if (RegExp(r'^[a-z]').hasMatch(lines[i]) && lines[i].trim().isNotEmpty) {
        insertAt = i;
        break;
      }
      insertAt = i + 1;
    }
  }

  if (insertAt < 0) {
    lines.addAll(['\ndependencies:']);
    insertAt = lines.length;
  }

  final additions =
      (newDeps.entries.toList()..sort((a, b) => a.key.compareTo(b.key)))
          .map((e) => '  ${e.key}: ${e.value}')
          .toList();

  lines.insertAll(insertAt, additions);
  return '${lines.join('\n')}\n';
}

// ─── Naming helpers ───────────────────────────────────────────────────────────

String showcaseDisplayName(Map<String, dynamic> repo) {
  var name = repo['name'] as String;
  for (final prefix in ['flutter_', 'flutter-']) {
    if (name.toLowerCase().startsWith(prefix)) {
      name = name.substring(prefix.length);
      break;
    }
  }
  return name
      .split(RegExp(r'[-_]+'))
      .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}')
      .join(' ');
}

String _sanitize(String s) => s
    .toLowerCase()
    .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
    .replaceAll(RegExp(r'^_+|_+$'), '');

String showcaseId(Map<String, dynamic> repo) {
  final owner = _sanitize((repo['owner'] as Map)['login'] as String);
  final name = _sanitize(repo['name'] as String);
  return '${owner}_$name';
}

String pageClass(String id) =>
    id.split('_').map((w) => '${w[0].toUpperCase()}${w.substring(1)}').join() +
    'Page';

String orientationDart(String orientation) => switch (orientation) {
  'portrait_only' => 'Orientation.portrait',
  'landscape_only' => 'Orientation.landscape',
  _ => 'null',
};

// ─── AI provider system ───────────────────────────────────────────────────────
//
// Providers tried in priority order. Within each provider, keys are rotated
// on 429 so we skip the sleep. Only when ALL keys of a provider are exhausted
// do we fall through to the next provider.
//
// To add keys: set the matching GitHub secret to "key1,key2,key3".

class _AiProvider {
  final String name;
  final List<String> keys;
  final String url; // empty string = Gemini (key in query param, not header)
  final String model;
  int _keyIndex = 0;

  _AiProvider({
    required this.name,
    required this.keys,
    required this.url,
    required this.model,
  });

  bool get hasKeys => keys.isNotEmpty;

  String _nextKey() {
    final key = keys[_keyIndex % keys.length];
    _keyIndex = (_keyIndex + 1) % keys.length;
    return key;
  }

  // Returns parsed text on success, null on exhausted / non-retriable error.
  Future<String?> call(String prompt) async {
    for (var attempt = 0; attempt < keys.length; attempt++) {
      final key = keys[(_keyIndex + attempt) % keys.length];
      final result = await _request(key, prompt);
      if (result == '$_kRateLimit') {
        // Rotate key and try again.
        continue;
      }
      if (result != null) return result;
      return null; // non-retriable
    }
    // All keys rate-limited — brief sleep before caller falls to next provider.
    print('  [$name] all keys rate-limited — sleeping 30s');
    await Future<void>.delayed(const Duration(seconds: 30));
    return null;
  }

  Future<String?> _request(String key, String prompt) async {
    final isGemini = url.isEmpty;
    final endpoint = isGemini
        ? 'https://generativelanguage.googleapis.com/v1beta/models'
              '/$model:generateContent?key=$key'
        : url;

    final bodyMap = isGemini
        ? {
            'contents': [
              {
                'parts': [
                  {'text': prompt},
                ],
              },
            ],
            'generationConfig': {'temperature': 0.2, 'maxOutputTokens': 2048},
          }
        : {
            'model': model,
            'messages': [
              {'role': 'user', 'content': prompt},
            ],
            'temperature': 0.2,
            'max_tokens': 2048,
          };

    final client = HttpClient();
    try {
      final request = await client.postUrl(Uri.parse(endpoint));
      final encoded = utf8.encode(jsonEncode(bodyMap));
      request.headers.set('content-type', 'application/json; charset=utf-8');
      request.headers.set('content-length', encoded.length.toString());
      if (!isGemini) request.headers.set('authorization', 'Bearer $key');
      request.add(encoded);

      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();

      if (response.statusCode == 200) {
        final data = jsonDecode(body) as Map<String, dynamic>;
        final text = isGemini
            ? ((((data['candidates'] as List).first)['content'])['parts']
                          as List)
                      .first['text']
                  as String
            : (data['choices'] as List).first['message']['content'] as String;
        return text
            .trim()
            .replaceAll(RegExp(r'^```(?:json)?\s*'), '')
            .replaceAll(RegExp(r'\s*```$'), '')
            .trim();
      }

      if (response.statusCode == 429 || response.statusCode == 403) {
        print('  [$name] key rate-limited — rotating');
        _nextKey();
        return _kRateLimit;
      }

      print(
        '  [$name] ${response.statusCode}: ${body.substring(0, body.length.clamp(0, 150))}',
      );
      return null;
    } catch (e) {
      print('  [$name] request failed: $e');
      return null;
    } finally {
      client.close();
    }
  }
}

const _kRateLimit = '__rate_limited__';

List<String> _envKeys(String varName) => (Platform.environment[varName] ?? '')
    .split(',')
    .map((k) => k.trim())
    .where((k) => k.isNotEmpty)
    .toList();

// Provider priority: best quality first. Script falls through on exhaustion.
final _aiProviders = <_AiProvider>[
  _AiProvider(
    name: 'Gemini',
    keys: _envKeys('GEMINI_API_KEYS'),
    url: '', // Gemini uses key in query param, not Authorization header
    model: 'gemini-2.5-flash',
  ),
  _AiProvider(
    name: 'DeepSeek',
    keys: _envKeys('DEEPSEEK_API_KEYS'),
    url: 'https://api.deepseek.com/chat/completions',
    model: 'deepseek-chat',
  ),
  _AiProvider(
    name: 'Groq',
    keys: _envKeys('GROQ_API_KEYS'),
    url: 'https://api.groq.com/openai/v1/chat/completions',
    model: 'llama-3.3-70b-versatile',
  ),
  _AiProvider(
    name: 'Cerebras',
    keys: _envKeys('CEREBRAS_API_KEYS'),
    url: 'https://api.cerebras.ai/v1/chat/completions',
    model: 'llama-3.3-70b',
  ),
  _AiProvider(
    name: 'SambaNova',
    keys: _envKeys('SAMBANOVA_API_KEYS'),
    url: 'https://api.sambanova.ai/v1/chat/completions',
    model: 'Meta-Llama-3.3-70B-Instruct',
  ),
  _AiProvider(
    name: 'NVIDIA',
    keys: _envKeys('NVIDIA_API_KEYS'),
    url: 'https://integrate.api.nvidia.com/v1/chat/completions',
    model: 'meta/llama-3.3-70b-instruct',
  ),
  _AiProvider(
    name: 'Together',
    keys: _envKeys('TOGETHER_API_KEYS'),
    url: 'https://api.together.xyz/v1/chat/completions',
    model: 'meta-llama/Llama-3.3-70B-Instruct-Turbo',
  ),
  _AiProvider(
    name: 'OpenRouter',
    keys: _envKeys('OPENROUTER_API_KEYS'),
    url: 'https://openrouter.ai/api/v1/chat/completions',
    model: 'meta-llama/llama-3.3-70b-instruct:free',
  ),
  _AiProvider(
    name: 'Mistral',
    keys: _envKeys('MISTRAL_API_KEYS'),
    url: 'https://api.mistral.ai/v1/chat/completions',
    model: 'mistral-small-latest',
  ),
].where((p) => p.hasKeys).toList();

Future<Map<String, dynamic>?> callAi(String prompt) async {
  for (final provider in _aiProviders) {
    final text = await provider.call(prompt);
    if (text != null) {
      try {
        return jsonDecode(text) as Map<String, dynamic>;
      } catch (e) {
        print('  [${provider.name}] JSON parse error: $e');
        // Try next provider — maybe it returns cleaner JSON.
        continue;
      }
    }
  }
  print('  All AI providers exhausted');
  return null;
}

Future<Map<String, dynamic>?> scoreRepo(
  Map<String, dynamic> repo,
  String readme,
  String dartSnippets,
) async {
  final prompt =
      '''
You evaluate Flutter GitHub repos for a showcase library of beautiful standalone UI experiences.

Repo: ${repo['full_name']}
Stars: ${repo['stargazers_count']}
Description: ${repo['description'] ?? 'N/A'}

README (first 2000 chars):
${readme.substring(0, readme.length.clamp(0, 2000))}

Dart source samples:
${dartSnippets.substring(0, dartSnippets.length.clamp(0, 3000))}

WHAT WE WANT — must be ALL of these:
  ✓ Single-screen or single-component UI experience (animation, custom widget, visual demo)
  ✓ Visually impressive, creative, or animated
  ✓ Self-contained — runs without complex backend setup
  ✗ NOT a utility/logic library
  ✗ NOT a full multi-screen app (auth, nav, data fetching, etc.)
  ✗ NOT a pub.dev package meant to be imported, not viewed
  ✗ NOT a tutorial, template, boilerplate, or course project

Score 1-10 (for logging only). Set suitable=true only if ALL criteria above are met. Respond with JSON only — no markdown fences:
{
  "score": <int 1-10>,
  "suitable": <true|false>,
  "reason": "<one sentence>",
  "description": "<one sentence for end-users, max 100 chars>",
  "main_widget_class": "<PascalCase class that IS the main visual widget>",
  "main_dart_file": "<lib/path/to/file.dart containing that class>",
  "orientation": "portrait_only|landscape_only|unspecified"
}''';

  return callAi(prompt);
}

Future<(String, String)?> generateShowcaseFiles(
  Map<String, dynamic> repo,
  Map<String, dynamic> evaluation,
  String sourceDart,
  Map<String, String> missingDeps,
) async {
  final id = showcaseId(repo);
  final cls = pageClass(id);
  final displayName = showcaseDisplayName(repo);
  final orientation = orientationDart(
    evaluation['orientation'] as String? ?? 'unspecified',
  );
  final description = evaluation['description'] as String? ?? '';
  final repoUrl = repo['html_url'] as String;
  final license =
      (repo['license'] as Map<String, dynamic>?)?['spdx_id'] ?? 'MIT';

  final depsNote = missingDeps.isEmpty
      ? ''
      : 'The widget uses these packages (already added to pubspec.yaml in this PR): '
            '${missingDeps.keys.join(', ')}. Include their imports as-is.';

  final prompt =
      '''
Generate two Dart files for the Flexer showcase library.

Showcase ID (folder name): $id
Source repo: $repoUrl
License: $license
Display name: $displayName
Description: $description
Main widget class: ${evaluation['main_widget_class'] ?? '(identify from source)'}
$depsNote

Source Dart:
${sourceDart.substring(0, sourceDart.length.clamp(0, 5000))}

═══ FILE 1: showcase_info.dart ═══
- import 'package:flutter/widgets.dart';
- import 'package:showcase_library/showcase_contract.dart';
- const showcaseInfo = ShowcaseInfo(
    showcaseName: '$displayName',
    githubRepoUrl: '$repoUrl',
    orientation: $orientation,
    description: '$description',
  );
- NO authorHandle field (does not exist in ShowcaseInfo)

═══ FILE 2: ${id}_page.dart ═══
- First line: // Source: $repoUrl
- import 'package:flutter/material.dart';
- class $cls extends StatelessWidget, const constructor
- Adapt/inline the source widget to be self-contained
- If something cannot be inlined: add // TODO: manual integration needed
  and render a placeholder Scaffold showing the showcase name and source URL

Respond with JSON only — no markdown fences:
{
  "showcase_info_dart": "<complete file content>",
  "page_dart": "<complete file content>"
}''';

  final result = await callAi(prompt);
  if (result == null) return null;
  try {
    return (
      result['showcase_info_dart'] as String,
      result['page_dart'] as String,
    );
  } catch (e) {
    print('  Missing keys in code-gen response');
    return null;
  }
}

// ─── Process helpers ──────────────────────────────────────────────────────────

Future<ProcessResult> _run(List<String> cmd, {String? workingDirectory}) =>
    Process.run(
      cmd.first,
      cmd.skip(1).toList(),
      workingDirectory: workingDirectory,
      environment: {...Platform.environment, 'GH_TOKEN': _ghToken},
    );

// ─── PR creation ──────────────────────────────────────────────────────────────

Future<bool> createPr(
  Map<String, dynamic> repo,
  Map<String, dynamic> evaluation,
  String infoDart,
  String pageDart,
  Map<String, String> missingDeps,
) async {
  final id = showcaseId(repo);
  final displayName = showcaseDisplayName(repo);
  final owner = (repo['owner'] as Map)['login'] as String;
  final branch = 'auto/discover-$id';
  final cloneDir = '/tmp/flexer-showcase-$id';

  await _run(['rm', '-rf', cloneDir]);

  var result = await _run(['gh', 'repo', 'clone', _showcaseRepo, cloneDir]);
  if (result.exitCode != 0) {
    print('  Clone failed: ${result.stderr}');
    return false;
  }

  for (final cmd in [
    ['git', 'config', 'user.email', 'agent@flexer.app'],
    ['git', 'config', 'user.name', 'Flexer Showcase Agent'],
    ['git', 'checkout', '-b', branch],
  ]) {
    await _run(cmd, workingDirectory: cloneDir);
  }

  final showcaseDir = Directory('$cloneDir/lib/$id');
  await showcaseDir.create(recursive: true);
  await File('$cloneDir/lib/$id/showcase_info.dart').writeAsString(infoDart);
  await File('$cloneDir/lib/$id/${id}_page.dart').writeAsString(pageDart);

  if (missingDeps.isNotEmpty) {
    final pubspecFile = File('$cloneDir/pubspec.yaml');
    final current = await pubspecFile.readAsString();
    await pubspecFile.writeAsString(mergeDepsIntoPubspec(current, missingDeps));
    print('  Added to pubspec.yaml: ${missingDeps.keys.join(', ')}');
  }

  await _run(['git', 'add', '.'], workingDirectory: cloneDir);
  result = await _run([
    'git',
    'commit',
    '-m',
    'feat: add $displayName showcase',
  ], workingDirectory: cloneDir);
  if (result.exitCode != 0) {
    print('  Commit failed: ${result.stderr}');
    return false;
  }

  result = await _run([
    'git',
    'push',
    'origin',
    branch,
  ], workingDirectory: cloneDir);
  if (result.exitCode != 0) {
    print('  Push failed: ${result.stderr}');
    return false;
  }

  final depsSection = missingDeps.isEmpty
      ? ''
      : '\n**New deps added to pubspec.yaml:**\n'
            '${missingDeps.entries.map((e) => '  - `${e.key}: ${e.value}`').join('\n')}\n';

  final prBody =
      '''## Auto-discovered showcase

- **Source:** ${repo['html_url']}
- **Stars:** ${repo['stargazers_count']}
- **License:** ${(repo['license'] as Map?)?['spdx_id'] ?? 'Unknown'}
- **Author:** @$owner

**Agent score:** ${evaluation['score']}/10
**Reason:** ${evaluation['reason']}
$depsSection
---

## Review checklist

- [ ] `lib/$id/${id}_page.dart` compiles without errors
- [ ] Any `// TODO` comments addressed
- [ ] Visual result matches description
- [ ] License confirmed (MIT / Apache 2.0 / BSD)

---
*Opened by Flexer Showcase Discovery Agent — requires human approval before merge.*''';

  result = await _run([
    'gh',
    'pr',
    'create',
    '--repo',
    _showcaseRepo,
    '--title',
    'feat: $displayName by @$owner',
    '--body',
    prBody,
    '--head',
    branch,
    '--base',
    'main',
  ], workingDirectory: cloneDir);

  if (result.exitCode == 0) {
    print('  PR: ${(result.stdout as String).trim()}');
    return true;
  } else {
    print('  PR failed: ${result.stderr}');
    return false;
  }
}

// ─── Main ─────────────────────────────────────────────────────────────────────

Future<void> main() async {
  print('=== Flexer Showcase Discovery Agent ===');

  final submittedUrls = await alreadySubmittedUrls();
  print('Already submitted (all-time): ${submittedUrls.length} repos');

  final (rejectedRepos, rejectedSha) = await fetchRejectedRepos();
  print('Previously rejected (all-time): ${rejectedRepos.length} repos');
  final newlyRejected = <String>{};

  final List<Map<String, dynamic>> toEvaluate;

  if (_targetRepo.isNotEmpty) {
    // ── Targeted: single repo ──────────────────────────────────────────────
    final ownerRepo = _targetRepo
        .replaceFirst(RegExp(r'^https?://github\.com/'), '')
        .replaceAll(RegExp(r'/$'), '');
    print('Targeted repo: $ownerRepo');
    final repo = await ghRepoInfo(ownerRepo);
    if (repo == null) {
      print('Could not fetch repo info for $ownerRepo — aborting.');
      return;
    }
    toEvaluate = [repo];
  } else if (_targetUser.isNotEmpty) {
    // ── Targeted: all Dart repos of a user ────────────────────────────────
    print('Targeted user: $_targetUser');
    final repos = await ghUserRepos(_targetUser);
    final filtered = repos.where((r) {
      final url = (r['html_url'] as String).replaceAll(RegExp(r'/$'), '');
      return !submittedUrls.contains(url);
    }).toList();
    filtered.sort(
      (a, b) => (b['stargazers_count'] as int).compareTo(
        a['stargazers_count'] as int,
      ),
    );
    toEvaluate = filtered.take(_maxCandidatesToEvaluate).toList();
    print('User repos found: ${repos.length}, evaluating ${toEvaluate.length}');
  } else {
    // ── Broad automatic search ─────────────────────────────────────────────
    final seen = <String>{};
    final candidates = <Map<String, dynamic>>[];

    for (final query in _searchQueries) {
      await Future<void>.delayed(const Duration(seconds: 2));
      try {
        final results = await ghSearch(query);
        for (final repo in results) {
          final fn = repo['full_name'] as String;
          if (seen.contains(fn)) continue;
          seen.add(fn);
          if ((repo['stargazers_count'] as int) < _minStars) continue;
          if (submittedUrls.contains(
            (repo['html_url'] as String).replaceAll(RegExp(r'/$'), ''),
          ))
            continue;
          if (repo['fork'] == true) continue;
          final descWords = (repo['description'] as String? ?? '')
              .toLowerCase()
              .split(' ');
          if (descWords.any(_skipDescriptionWords.contains)) continue;
          candidates.add(repo);
        }
      } catch (e) {
        print('  Search error: $e');
      }
    }

    candidates.sort(
      (a, b) => (b['stargazers_count'] as int).compareTo(
        a['stargazers_count'] as int,
      ),
    );
    toEvaluate = candidates.take(_maxCandidatesToEvaluate).toList();
    print(
      'Candidates: ${candidates.length} found, evaluating top ${toEvaluate.length}',
    );
  }

  final libraryPubspec = await ghFile(_showcaseRepo, 'pubspec.yaml') ?? '';

  var submitted = 0;

  for (final repo in toEvaluate) {
    if (submitted >= _maxPerRun) break;

    print('\n▸ ${repo['full_name']} (${repo['stargazers_count']} ★)');

    final fullName = repo['full_name'] as String;
    if (rejectedRepos.contains(fullName)) {
      print('  Previously rejected — skip');
      continue;
    }

    final readme =
        await ghFile(repo['full_name'] as String, 'README.md') ??
        await ghFile(repo['full_name'] as String, 'readme.md') ??
        '';
    final sourcePubspec =
        await ghFile(repo['full_name'] as String, 'pubspec.yaml') ?? '';

    if (!await repoHasDart(repo['full_name'] as String)) {
      print('  No Dart code — skip');
      continue;
    }

    final tree = await ghTree(repo['full_name'] as String);
    final dartFilePaths = topDartFiles(tree);

    final dartSnippets = StringBuffer();
    for (final path in dartFilePaths) {
      final content = await ghFile(repo['full_name'] as String, path);
      if (content != null) {
        dartSnippets.write('\n// ── $path ──\n');
        dartSnippets.write(content.substring(0, content.length.clamp(0, 1500)));
        dartSnippets.write('\n');
      }
    }

    if (dartSnippets.isEmpty) {
      print('  Tree truncated — evaluating from README only');
    }

    await Future<void>.delayed(Duration(seconds: _geminiDelaySec));
    final evaluation = await scoreRepo(repo, readme, dartSnippets.toString());
    if (evaluation == null) continue;

    final score = evaluation['score'] as int? ?? 0;
    print('  Score $score/10 — ${evaluation['reason']}');

    if (evaluation['suitable'] != true) {
      print('  AI says not suitable (score $score/10) — skip');
      newlyRejected.add(fullName);
      continue;
    }

    final missingDeps = computeMissingDeps(sourcePubspec, libraryPubspec);
    if (missingDeps.isNotEmpty) {
      print('  Missing deps: ${missingDeps.keys.join(', ')}');
    }

    final mainFile = evaluation['main_dart_file'] as String?;
    final sourceDart =
        (mainFile != null
            ? await ghFile(repo['full_name'] as String, mainFile)
            : null) ??
        dartSnippets.toString();

    await Future<void>.delayed(Duration(seconds: _geminiDelaySec));
    final files = await generateShowcaseFiles(
      repo,
      evaluation,
      sourceDart,
      missingDeps,
    );
    if (files == null) {
      print('  Code generation failed — skip');
      continue;
    }

    final (infoDart, pageDart) = files;

    try {
      if (await createPr(repo, evaluation, infoDart, pageDart, missingDeps)) {
        submitted++;
      }
    } catch (e) {
      print('  Error: $e');
    }

    await Future<void>.delayed(const Duration(seconds: 2));
  }

  if (newlyRejected.isNotEmpty) {
    print('\nSaving ${newlyRejected.length} new rejection(s) to gallery...');
    await saveRejectedRepos(
      {...rejectedRepos, ...newlyRejected},
      rejectedSha,
    );
  }

  print('\n=== Done. $submitted PR(s) submitted. ===');
}
