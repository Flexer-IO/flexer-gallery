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
//   SAMBANOVA_API_KEYS  cloud.sambanova.ai      — free,                 Meta-Llama-3.3-70B-Instruct
//   CEREBRAS_API_KEYS   cloud.cerebras.ai       — free, ~30 req/min,    gpt-oss-120b
//   GROQ_API_KEYS       console.groq.com        — free,                 llama-3.3-70b-versatile
//   NVIDIA_API_KEYS     build.nvidia.com        — 1000 credits/month,   meta/llama-3.1-70b-instruct
//   OPENROUTER_API_KEYS openrouter.ai           — free,                 google/gemma-3-27b-it:free
//   GEMINI_API_KEYS     ai.google.dev           — free, 15 req/min/key,  gemini-2.5-flash (last resort)
//
//   Example: GEMINI_API_KEYS=key1,key2,key3  GROQ_API_KEYS=key4,key5
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

// Star-range queries — each gets its own 1000-result GitHub API window.
// Splitting into narrow ranges ensures no repo is missed due to the 10-page cap.
const _searchQueries = [
  'flutter language:dart stars:>50000',
  'flutter language:dart stars:10000..50000',
  'flutter language:dart stars:5000..10000',
  'flutter language:dart stars:2000..5000',
  'flutter language:dart stars:1000..2000',
  'flutter language:dart stars:500..1000',
  'flutter language:dart stars:100..500',
  'flutter language:dart stars:$_minStars..100',
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

Future<List<Map<String, dynamic>>> ghSearch(
  String query, {
  int page = 1,
}) async {
  final url = Uri.https('api.github.com', '/search/repositories', {
    'q': query,
    'sort': 'stars',
    'order': 'desc',
    'per_page': '100',
    'page': '$page',
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

  final lines = inDeps.split('\n');
  for (var i = 0; i < lines.length; i++) {
    final m = RegExp(r'^  ([a-z][a-z0-9_-]*):\s*(.*)$').firstMatch(lines[i]);
    if (m == null) continue;
    final name = m.group(1)!;
    final version = m.group(2)!.trim();
    if (_builtinPackages.contains(name)) continue;
    if (version.contains('sdk:') ||
        version.contains('path:') ||
        version.contains('git:'))
      continue;
    // If version is empty, peek at next lines — multiline git/path dep, skip it.
    if (version.isEmpty) {
      final next = i + 1 < lines.length ? lines[i + 1].trim() : '';
      if (next.startsWith('git:') ||
          next.startsWith('path:') ||
          next.startsWith('sdk:'))
        continue;
    }
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
    print('  [$name] all keys exhausted — trying next provider');
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
            'generationConfig': {'temperature': 0.2, 'maxOutputTokens': 8192},
          }
        : {
            'model': model,
            'messages': [
              {'role': 'user', 'content': prompt},
            ],
            'temperature': 0.2,
            'max_tokens': 8192,
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

      // Rate-limit / quota errors — rotate to next key.
      if (response.statusCode == 429 ||
          response.statusCode == 403 ||
          response.statusCode == 503) {
        print('  [$name] ${response.statusCode} — rotating key');
        _nextKey();
        return _kRateLimit;
      }

      // 400 = bad request — rotating keys won't help; print body for diagnosis.
      print(
        '  [$name] ${response.statusCode}: ${body.substring(0, body.length.clamp(0, 300))}',
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

// Provider priority: most reliable / highest quota first. Gemini last (aggressive rate limits).
final _aiProviders = <_AiProvider>[
  // SambaNova — proven working, free 70B, no aggressive rate limits.
  _AiProvider(
    name: 'SambaNova',
    keys: _envKeys('SAMBANOVA_API_KEYS'),
    url: 'https://api.sambanova.ai/v1/chat/completions',
    model: 'Meta-Llama-3.3-70B-Instruct',
  ),
  // Cerebras — fastest inference, generous free quota.
  _AiProvider(
    name: 'Cerebras',
    keys: _envKeys('CEREBRAS_API_KEYS'),
    url: 'https://api.cerebras.ai/v1/chat/completions',
    model: 'gpt-oss-120b',
  ),
  // NVIDIA — Llama 3.1 70B via NIM API (1000 free credits/month).
  _AiProvider(
    name: 'NVIDIA',
    keys: _envKeys('NVIDIA_API_KEYS'),
    url: 'https://integrate.api.nvidia.com/v1/chat/completions',
    model: 'meta/llama-3.1-70b-instruct',
  ),
  // OpenRouter — Gemma 3 27B free tier.
  _AiProvider(
    name: 'OpenRouter',
    keys: _envKeys('OPENROUTER_API_KEYS'),
    url: 'https://openrouter.ai/api/v1/chat/completions',
    model: 'google/gemma-3-27b-it:free',
  ),
  // Groq — fast free inference.
  _AiProvider(
    name: 'Groq',
    keys: _envKeys('GROQ_API_KEYS'),
    url: 'https://api.groq.com/openai/v1/chat/completions',
    model: 'llama-3.3-70b-versatile',
  ),
  // Gemini — last resort; aggressive rate limits with multiple files.
  _AiProvider(
    name: 'Gemini',
    keys: _envKeys('GEMINI_API_KEYS'),
    url: '', // key in query param, not Authorization header
    model: 'gemini-2.5-flash',
  ),
].where((p) => p.hasKeys).toList();

Future<Map<String, dynamic>?> callAi(String prompt, {String label = ''}) async {
  for (final provider in _aiProviders) {
    print(
      '  [${provider.name}] evaluating${label.isNotEmpty ? ' $label' : ''}...',
    );
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

// Returns raw text response — no JSON parsing. Use for code content where
// embedded newlines/quotes would break JSON.
Future<String?> callAiRaw(String prompt, {String label = ''}) async {
  for (final provider in _aiProviders) {
    print(
      '  [${provider.name}] evaluating${label.isNotEmpty ? ' $label' : ''}...',
    );
    final text = await provider.call(prompt);
    if (text != null) return text;
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
  ✓ Self-contained — runs without complex backend setup, no native platform code
  ✗ NOT a utility/logic library
  ✗ NOT a full multi-screen app (auth, nav, data fetching, etc.)
  ✗ NOT a pub.dev package meant to be imported, not viewed
  ✗ NOT a tutorial, template, boilerplate, or course project
  ✗ NOT requiring native Swift/Kotlin/platform-channel code to function

Orientation rules (be precise):
  - landscape_only: wide displays, clocks, horizontal scrollers, games designed for landscape
  - portrait_only: vertical lists, phone-first UIs, tall layouts
  - unspecified: works in both orientations equally

Score 1-10 (for logging only). Set suitable=true only if ALL criteria above are met. Respond with JSON only — no markdown fences:
{
  "score": <int 1-10>,
  "suitable": <true|false>,
  "reason": "<one sentence>",
  "description": "<one sentence for end-users, max 100 chars>",
  "main_dart_file": "<lib/path/to/file.dart containing the main visual widget>",
  "orientation": "portrait_only|landscape_only|unspecified"
}''';

  return callAi(prompt, label: repo['full_name'] as String);
}

// Fetches all dart files under lib/ from a source repo (up to a limit).
Future<Map<String, String>> fetchAllSourceFiles(
  String repo,
  List<Map<String, dynamic>> tree,
) async {
  final files = <String, String>{};
  final paths = tree
      .where(
        (f) =>
            (f['path'] as String).startsWith('lib/') &&
            (f['path'] as String).endsWith('.dart') &&
            !(f['path'] as String).toLowerCase().contains('test') &&
            (f['size'] as int? ?? 0) < 80000,
      )
      .map((f) => f['path'] as String)
      .toList();

  for (final path in paths) {
    final content = await ghFile(repo, path);
    if (content != null) files[path] = content;
  }
  return files;
}

// Fixes package imports from source package → relative imports within showcase dir.
String fixImports(String content, String sourcePackageName) {
  return content.replaceAllMapped(
    RegExp("import 'package:${RegExp.escape(sourcePackageName)}/(.+?)';"),
    (m) => "import '${m.group(1)}';",
  );
}

(String, String) generateShowcaseFiles(
  Map<String, dynamic> repo,
  Map<String, dynamic> evaluation,
  Map<String, String> sourceFiles,
) {
  final id = showcaseId(repo);
  final cls = pageClass(id);
  final displayName = showcaseDisplayName(repo);
  final orientation = orientationDart(
    evaluation['orientation'] as String? ?? 'unspecified',
  );
  final description = (evaluation['description'] as String? ?? '').replaceAll(
    "'",
    r"\'",
  );
  final repoUrl = repo['html_url'] as String;

  // Determine entry file and main widget class from AI hint or fallback.
  final mainFile = evaluation['main_dart_file'] as String?;
  final entryImport = mainFile != null
      ? mainFile.replaceFirst('lib/', '')
      : '${id}_entry.dart';

  // Derive main widget class name from the entry file content if possible.
  String mainClass = cls.replaceAll('Page', '');
  if (mainFile != null && sourceFiles.containsKey(mainFile)) {
    final classMatch = RegExp(
      r'class\s+(\w+)\s+extends\s+Stateful|class\s+(\w+)\s+extends\s+Stateless',
    ).firstMatch(sourceFiles[mainFile]!);
    if (classMatch != null) {
      mainClass = classMatch.group(1) ?? classMatch.group(2) ?? mainClass;
    }
  }

  final infoDart =
      '''// AUTO-GENERATED by Flexer Showcase Discovery Agent
import 'package:showcase_library/showcase_contract.dart';

const showcaseInfo = ShowcaseInfo(
  showcaseName: '$displayName',
  githubRepoUrl: '$repoUrl',
  orientation: $orientation,
  description: '$description',
);
''';

  final pageDart =
      '''// Source: $repoUrl
import 'package:flutter/material.dart';
import '$entryImport';

class $cls extends StatelessWidget {
  const $cls({super.key});

  @override
  Widget build(BuildContext context) => const $mainClass();
}
''';

  return (infoDart, pageDart);
}

// ─── Showcase validation + self-healing ───────────────────────────────────────

// Extracts package names from analyze output where import URI cannot be resolved.
// Machine format line example:
//   ERROR|URI_DOES_NOT_EXIST|...|file.dart|1|8|51|Target of URI doesn't exist: 'package:flutter_clock_helper/model.dart'
Set<String> _missingImportDeps(String analyzeOutput) {
  final set = <String>{};
  for (final line in analyzeOutput.split('\n')) {
    if (!line.contains("doesn't exist") &&
        !line.contains('not found') &&
        !line.contains('URI_DOES_NOT_EXIST'))
      continue;
    final m = RegExp(r"package:([a-z_][a-z0-9_]*)/").firstMatch(line);
    if (m != null) set.add(m.group(1)!);
  }
  return set;
}

Set<String> _failingDeps(String output) {
  final set = <String>{};
  // "Because X ..." patterns
  for (final m in RegExp(
    r"Because ([a-z_][a-z0-9_]*)[ \^]",
  ).allMatches(output)) {
    set.add(m.group(1)!);
  }
  // "X ... doesn't support null safety" / "lower bound" patterns
  for (final m in RegExp(
    r"'([a-z_][a-z0-9_]*)' must be 2\.12",
  ).allMatches(output)) {
    set.add(m.group(1)!);
  }
  // "Incompatible constraints on X"
  for (final m in RegExp(
    r"constraints on ([a-z_][a-z0-9_]*)",
  ).allMatches(output)) {
    set.add(m.group(1)!);
  }
  return set;
}

// Reads a dep's source from the source repo's pubspec (git url or pub.dev).
Future<Map<String, dynamic>?> _depSource(String dep, String sourcePubspec) {
  // Look for git: entry for this dep in the source pubspec.
  final gitMatch = RegExp(
    '  $dep:\\s*\\n    git:\\s*\\n      url:\\s*(\\S+)(?:\\s*\\n      path:\\s*(\\S+))?',
  ).firstMatch(sourcePubspec);
  if (gitMatch != null) {
    return Future.value({
      'type': 'git',
      'url': gitMatch.group(1)!,
      'path': gitMatch.group(2),
    });
  }
  return Future.value({'type': 'pubdev'});
}

// AI fix loop — batches ALL errored files into one call per attempt.
// Loops until clean or no progress (same errors two rounds in a row).
Future<bool> _analyzeAndFix(String dir) async {
  // Collect available local deps so AI knows what relative imports to use.
  final depsDir = Directory('$dir/deps');
  final availableDeps = <String>[];
  if (depsDir.existsSync()) {
    await for (final e in depsDir.list()) {
      if (e is Directory) availableDeps.add(e.path.split('/').last);
    }
  }
  final depsNote = availableDeps.isEmpty
      ? ''
      : '\nLocal deps available via relative import — '
          'e.g. import \'deps/pkg_name/some_file.dart\':\n'
          '${availableDeps.map((d) => '  deps/$d/').join('\n')}\n';

  Set<String> prevErrorKeys = {};
  var attempt = 0;

  while (true) {
    attempt++;
    final result = await _run(['dart', 'analyze', '--format', 'machine', dir]);

    // Collect only ERROR-severity lines (not HINT/WARNING — those are non-blocking).
    final byFile = <String, List<String>>{};
    for (final line in (result.stdout as String).split('\n')) {
      final parts = line.split('|');
      if (parts.length < 8) continue;
      if (parts[0].trim() != 'ERROR') continue; // skip HINT/WARNING
      final filePath = parts[3].trim();
      if (filePath.isEmpty) continue;
      byFile.putIfAbsent(filePath, () => []).add(line);
    }

    if (byFile.isEmpty) return true; // no errors (hints/warnings are fine)

    // Detect no-progress: stop if error set unchanged from previous attempt.
    final errorKeys = byFile.entries
        .expand((e) => e.value.map((l) => '${e.key}:$l'))
        .toSet();
    if (errorKeys == prevErrorKeys) {
      print('    No progress after attempt $attempt — stopping fix loop');
      return false;
    }
    prevErrorKeys = errorKeys;

    print('    Analyze attempt $attempt — ${byFile.length} file(s) with errors:');
    for (final entry in byFile.entries) {
      final fileName = entry.key.split('/').last;
      for (final line in entry.value) {
        final parts = line.split('|');
        final msg = parts.length >= 8 ? parts[7].trim() : line;
        print('      $fileName: $msg');
      }
    }

    // Read all errored files and build one batched prompt.
    final sections = <String>[];
    for (final entry in byFile.entries) {
      final file = File(entry.key);
      if (!file.existsSync()) continue;
      final content = await file.readAsString();
      sections.add(
        '===FILE: ${entry.key}===\n'
        'ERRORS:\n${entry.value.join('\n')}\n\n'
        'CONTENT:\n$content\n'
        '===END===',
      );
    }

    if (sections.isEmpty) return true;

    final fix = await callAiRaw(
      'Fix ALL dart analyze errors in the files below. '
      'Make them null-safe and compatible with Dart 3.$depsNote\n\n'
      '${sections.join('\n\n')}\n\n'
      'Return each fixed file using EXACTLY this format:\n'
      '===FIXED: <original file path>===\n'
      '<complete fixed file content>\n'
      '===END===\n\n'
      'One block per file. No explanation, no markdown, no JSON.',
      label: '${byFile.length} file(s)',
    );

    if (fix != null && fix.trim().isNotEmpty) {
      final blockRe = RegExp(
        r'===FIXED: (.+?)===\n([\s\S]*?)===END===',
        multiLine: true,
      );
      for (final m in blockRe.allMatches(fix)) {
        final path = m.group(1)!.trim();
        var content = m.group(2)!.trim();
        if (content.startsWith('```')) {
          content = content
              .replaceFirst(RegExp(r'^```[a-z]*\n?'), '')
              .replaceFirst(RegExp(r'\n?```\s*$'), '');
        }
        final f = File(path);
        if (f.existsSync()) await f.writeAsString(content);
      }
    }
  }
}

// Fetches a dep's source (git or pub.dev), fixes its code, patches pubspec + imports.
Future<bool> _fetchDep(
  String dep,
  String cloneDir,
  String showcaseId,
  String sourcePubspec,
) async {
  print('    Fetching dep $dep...');
  final depDir = '$cloneDir/lib/$showcaseId/deps/$dep';
  await _run(['mkdir', '-p', depDir]);

  final source = await _depSource(dep, sourcePubspec);

  if (source != null && source['type'] == 'git') {
    final gitUrl = source['url'] as String;
    final subPath = source['path'] as String?;
    final tmpClone = '/tmp/dep-git-$dep';
    await _run(['rm', '-rf', tmpClone]);
    final clone = await _run(['git', 'clone', '--depth=1', gitUrl, tmpClone]);
    if (clone.exitCode != 0) {
      print('    Git clone failed');
      return false;
    }
    final libSrc = subPath != null ? '$tmpClone/$subPath/lib' : '$tmpClone/lib';
    await _run(['bash', '-c', 'cp -r $libSrc/. $depDir/']);
  } else {
    // pub.dev
    final info = await _httpGet('https://pub.dev/api/packages/$dep', {
      'Accept': 'application/json',
    });
    if (info == null) {
      print('    Cannot fetch $dep from pub.dev');
      return false;
    }
    final data = jsonDecode(info) as Map<String, dynamic>;
    final version =
        (data['latest'] as Map<String, dynamic>)['version'] as String;
    final tmpDir = '/tmp/dep-$dep';
    await _run(['rm', '-rf', tmpDir]);
    await _run(['mkdir', '-p', tmpDir]);
    final dl = await _run([
      'curl',
      '-sL',
      '-o',
      '$tmpDir.tar.gz',
      'https://pub.dev/packages/$dep/versions/$version.tar.gz',
    ]);
    if (dl.exitCode != 0) {
      print('    Download failed');
      return false;
    }
    await _run(['tar', '-xzf', '$tmpDir.tar.gz', '-C', tmpDir]);
    await _run(['bash', '-c', 'cp -r $tmpDir/lib/. $depDir/']);
  }

  // Fix the fetched dep's own code (null-safety, deprecated APIs, etc.)
  print('    Fixing dep $dep code...');
  await _analyzeAndFix(depDir);

  // Patch pubspec: replace dep entry with local path.
  final pubspecFile = File('$cloneDir/pubspec.yaml');
  var pubspec = await pubspecFile.readAsString();
  pubspec = pubspec.replaceAllMapped(
    RegExp('  $dep:(?:[^\n]*\n(?:    [^\n]*\n)*)'),
    (_) => '  $dep:\n    path: lib/$showcaseId/deps/$dep\n',
  );
  await pubspecFile.writeAsString(pubspec);

  // Fix imports in showcase dart files: package:dep/ → deps/dep/
  final showcaseLibDir = Directory('$cloneDir/lib/$showcaseId');
  await for (final entity in showcaseLibDir.list(recursive: true)) {
    if (entity is! File || !entity.path.endsWith('.dart')) continue;
    if (entity.path.contains('/deps/')) continue;
    final content = await entity.readAsString();
    final fixed = content.replaceAll(
      RegExp("import 'package:${RegExp.escape(dep)}/"),
      "import 'deps/$dep/",
    );
    if (fixed != content) await entity.writeAsString(fixed);
  }

  print('    Dep $dep → lib/$showcaseId/deps/$dep');
  return true;
}

// Full validation loop: pub get → fetch missing deps → analyze → AI fix.
Future<bool> validateAndFix(
  String cloneDir,
  String showcaseId,
  String sourcePubspec,
) async {
  // Pub get loop: fetch any dep that blocks resolution.
  final fetched = <String>{};
  for (var round = 0; round < 5; round++) {
    final result = await _run([
      'flutter',
      'pub',
      'get',
    ], workingDirectory: cloneDir);
    if (result.exitCode == 0) break;

    final output = '${result.stdout}\n${result.stderr}';
    final failing = _failingDeps(output)..removeAll(fetched);

    if (failing.isEmpty) {
      print('  pub get failed (unrecognized error):\n${result.stderr}');
      return false;
    }

    for (final dep in failing) {
      if (!await _fetchDep(dep, cloneDir, showcaseId, sourcePubspec)) {
        return false;
      }
      fetched.add(dep);
    }

    if (round == 4) {
      print('  pub get still failing after $round dep fetch rounds');
      return false;
    }
  }

  print('  pub get OK — scanning for unresolved package imports...');

  // Pre-analyze: find missing package imports that pub get didn't catch
  // (e.g. packages referenced in source files but absent from pubspec).
  final preAnalyze = await _run([
    'dart',
    'analyze',
    '--format',
    'machine',
    '$cloneDir/lib/$showcaseId',
  ]);
  final missingPkgs =
      _missingImportDeps('${preAnalyze.stdout}\n${preAnalyze.stderr}')
        ..removeAll(fetched)
        ..removeAll(_builtinPackages);

  if (missingPkgs.isNotEmpty) {
    print('  Missing package imports: $missingPkgs — fetching deps...');
    for (final dep in missingPkgs) {
      if (!await _fetchDep(dep, cloneDir, showcaseId, sourcePubspec)) {
        print('  Cannot fetch dep $dep — showcase may fail analyze');
      }
      fetched.add(dep);
    }
    // Re-run pub get after fetching new deps.
    final reget = await _run([
      'flutter',
      'pub',
      'get',
    ], workingDirectory: cloneDir);
    if (reget.exitCode != 0) {
      print('  pub get failed after fetching deps: ${reget.stderr}');
      return false;
    }
  }

  print('  Running dart analyze...');

  // Analyze + AI fix loop on showcase files.
  final ok = await _analyzeAndFix('$cloneDir/lib/$showcaseId');
  if (!ok) print('  Analyze errors remain after fix attempts');
  return ok;
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
  Map<String, String> sourceFiles,
  String sourcePubspec,
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
    [
      'git',
      'remote',
      'set-url',
      'origin',
      'https://x-access-token:$_ghToken@github.com/$_showcaseRepo.git',
    ],
    ['git', 'checkout', '-b', branch],
  ]) {
    await _run(cmd, workingDirectory: cloneDir);
  }

  final showcaseDir = Directory('$cloneDir/lib/$id');
  await showcaseDir.create(recursive: true);

  // Write generated files.
  await File('$cloneDir/lib/$id/showcase_info.dart').writeAsString(infoDart);
  await File('$cloneDir/lib/$id/${id}_page.dart').writeAsString(pageDart);

  // Copy all source dart files with import paths fixed.
  final sourcePackageName = (repo['name'] as String).replaceAll('-', '_');
  for (final entry in sourceFiles.entries) {
    // Strip lib/ prefix — files go into lib/<id>/<rest of path>.
    final relativePath = entry.key.replaceFirst('lib/', '');
    final destFile = File('$cloneDir/lib/$id/$relativePath');
    await destFile.parent.create(recursive: true);
    final fixed = fixImports(entry.value, sourcePackageName);
    await destFile.writeAsString(fixed);
  }

  // Copy README and LICENSE if they exist.
  for (final name in ['README.md', 'readme.md', 'LICENSE', 'LICENSE.txt']) {
    final content = await ghFile(repo['full_name'] as String, name);
    if (content != null) {
      await File('$cloneDir/lib/$id/$name').writeAsString(content);
      break; // Only copy first README found.
    }
  }
  // LICENSE separately.
  for (final name in ['LICENSE', 'LICENSE.txt', 'LICENSE.md']) {
    final content = await ghFile(repo['full_name'] as String, name);
    if (content != null) {
      await File('$cloneDir/lib/$id/LICENSE').writeAsString(content);
      break;
    }
  }

  if (missingDeps.isNotEmpty) {
    final pubspecFile = File('$cloneDir/pubspec.yaml');
    final current = await pubspecFile.readAsString();
    await pubspecFile.writeAsString(mergeDepsIntoPubspec(current, missingDeps));
    print('  Added to pubspec.yaml: ${missingDeps.keys.join(', ')}');
  }

  // Remove workspace resolution — clone runs standalone, no workspace root.
  final clonePubspec = File('$cloneDir/pubspec.yaml');
  final clonePubspecContent = await clonePubspec.readAsString();
  await clonePubspec.writeAsString(
    clonePubspecContent.replaceAll(RegExp(r'resolution:\s*workspace\s*\n'), ''),
  );

  // Validate: pub get + dep vendoring + analyze + AI fix loop.
  print('  Validating showcase...');
  final valid = await validateAndFix(cloneDir, id, sourcePubspec);
  if (!valid) {
    print('  Showcase failed validation — not submitting PR');
    return false;
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
      return !submittedUrls.contains(url) &&
          !rejectedRepos.contains(r['full_name'] as String);
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
      for (var page = 1; page <= 10; page++) {
        await Future<void>.delayed(const Duration(seconds: 2));
        try {
          final results = await ghSearch(query, page: page);
          if (results.isEmpty) break;
          for (final repo in results) {
            final fn = repo['full_name'] as String;
            if (seen.contains(fn)) continue;
            seen.add(fn);
            if (repo['fork'] == true) continue;
            if (rejectedRepos.contains(fn)) continue;
            if (submittedUrls.contains(
              (repo['html_url'] as String).replaceAll(RegExp(r'/$'), ''),
            ))
              continue;
            final descWords = (repo['description'] as String? ?? '')
                .toLowerCase()
                .split(' ');
            if (descWords.any(_skipDescriptionWords.contains)) continue;
            candidates.add(repo);
          }
        } catch (e) {
          print('  Search error: $e');
          break;
        }
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

    // Fetch ALL source dart files for inclusion in the PR.
    final sourceFiles = await fetchAllSourceFiles(
      repo['full_name'] as String,
      tree,
    );
    print('  Source files: ${sourceFiles.length} dart files fetched');

    final (infoDart, pageDart) = generateShowcaseFiles(
      repo,
      evaluation,
      sourceFiles,
    );

    try {
      if (await createPr(
        repo,
        evaluation,
        infoDart,
        pageDart,
        missingDeps,
        sourceFiles,
        sourcePubspec,
      )) {
        submitted++;
      }
    } catch (e) {
      print('  Error: $e');
    }

    await Future<void>.delayed(const Duration(seconds: 2));
  }

  if (newlyRejected.isNotEmpty) {
    print('\nSaving ${newlyRejected.length} new rejection(s) to gallery...');
    await saveRejectedRepos({...rejectedRepos, ...newlyRejected}, rejectedSha);
  }

  print('\n=== Done. $submitted PR(s) submitted. ===');
}
