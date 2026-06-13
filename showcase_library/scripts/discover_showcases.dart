// Flexer Showcase Discovery Agent.
//
// Searches GitHub broadly for Flutter repos (keyword: flutter, language:dart),
// scores each with Gemini 2.0 Flash (free tier), and opens PRs to
// flexer/flexer-showcase-library for human review.
//
// Each PR adds:
//   lib/<id>/<id>_page.dart
//   lib/<id>/showcase_info.dart
//   (patches showcase_library/pubspec.yaml with any missing deps)
//
// Required env vars:
//   GH_TOKEN        PAT with repo scope on both repos
//   GEMINI_API_KEY  Google AI Studio key (free, 15 req/min / 1M tokens/day)
//   SHOWCASE_REPO   target repo (default: flexer/flexer-showcase-library)

import 'dart:convert';
import 'dart:io';

// ─── Config ───────────────────────────────────────────────────────────────────

final _ghToken = Platform.environment['GH_TOKEN']!;
final _geminiKey = Platform.environment['GEMINI_API_KEY']!;
final _showcaseRepo =
    Platform.environment['SHOWCASE_REPO'] ?? 'flexer/flexer-showcase-library';

const _geminiModel = 'gemini-2.0-flash';
const _minStars = 80;
const _maxPerRun = 3;
const _geminiDelaySec = 5; // 15 req/min free tier
const _scoreThreshold = 7;

const _searchQueries = [
  'flutter in:name,description language:dart stars:>200 pushed:>2024-01-01',
  'flutter in:name,description language:dart stars:>100 pushed:>2024-06-01',
  'flutter ui in:name,description language:dart stars:>150 pushed:>2023-06-01',
  'flutter animation in:name,description language:dart stars:>100 pushed:>2024-01-01',
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

// ─── HTTP helpers ─────────────────────────────────────────────────────────────

Map<String, String> get _ghHeaders => {
  'Authorization': 'Bearer $_ghToken',
  'Accept': 'application/vnd.github+json',
  'X-GitHub-Api-Version': '2022-11-28',
};

Future<String?> _httpGet(String url, Map<String, String> headers) async {
  final client = HttpClient();
  try {
    final request = await client.getUrl(Uri.parse(url));
    headers.forEach(request.headers.set);
    final response = await request.close();
    if (response.statusCode == 200) {
      return await response.transform(utf8.decoder).join();
    }
    return null;
  } catch (e) {
    print('  GET $url failed: $e');
    return null;
  } finally {
    client.close();
  }
}

Future<String?> _httpPost(
  String url,
  Map<String, String> headers,
  Map<String, dynamic> body,
) async {
  final client = HttpClient();
  try {
    final request = await client.postUrl(Uri.parse(url));
    headers.forEach(request.headers.set);
    request.headers.set('content-type', 'application/json');
    request.write(jsonEncode(body));
    final response = await request.close();
    return await response.transform(utf8.decoder).join();
  } catch (e) {
    print('  POST $url failed: $e');
    return null;
  } finally {
    client.close();
  }
}

// ─── GitHub helpers ───────────────────────────────────────────────────────────

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

Future<Set<String>> alreadySubmittedUrls() async {
  final urls = <String>{};

  // From committed showcase_info.dart files in the library.
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

  // From open PR bodies.
  final prResult = await _run([
    'gh',
    'pr',
    'list',
    '--repo',
    _showcaseRepo,
    '--state',
    'open',
    '--json',
    'body',
    '--limit',
    '100',
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
  // Find the dependencies: block and extract package lines.
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

// ─── Gemini helpers ───────────────────────────────────────────────────────────

Future<Map<String, dynamic>?> gemini(String prompt) async {
  final url =
      'https://generativelanguage.googleapis.com/v1beta/models/$_geminiModel:generateContent?key=$_geminiKey';

  final raw = await _httpPost(url, {}, {
    'contents': [
      {
        'parts': [
          {'text': prompt},
        ],
      },
    ],
    'generationConfig': {'temperature': 0.2, 'maxOutputTokens': 2048},
  });

  if (raw == null) return null;
  try {
    final data = jsonDecode(raw) as Map<String, dynamic>;
    final text =
        ((((data['candidates'] as List).first)['content'])['parts'] as List)
                .first['text']
            as String;

    // Strip markdown fences.
    final cleaned = text
        .trim()
        .replaceAll(RegExp(r'^```(?:json)?\s*', multiLine: false), '')
        .replaceAll(RegExp(r'\s*```$', multiLine: false), '')
        .trim();

    return jsonDecode(cleaned) as Map<String, dynamic>;
  } catch (e) {
    print('  Gemini parse error: $e');
    return null;
  }
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

Score 1-10 (threshold to submit: $_scoreThreshold). Respond with JSON only — no markdown fences:
{
  "score": <int 1-10>,
  "suitable": <true|false>,
  "reason": "<one sentence>",
  "description": "<one sentence for end-users, max 100 chars>",
  "main_widget_class": "<PascalCase class that IS the main visual widget>",
  "main_dart_file": "<lib/path/to/file.dart containing that class>",
  "orientation": "portrait_only|landscape_only|unspecified"
}''';

  return gemini(prompt);
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

  final result = await gemini(prompt);
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

Future<ProcessResult> _run(List<String> cmd, {String? workingDirectory}) async {
  return Process.run(
    cmd.first,
    cmd.skip(1).toList(),
    workingDirectory: workingDirectory,
    environment: {...Platform.environment, 'GH_TOKEN': _ghToken},
  );
}

// ─── PR creation ──────────────────────────────────────────────────────────────

Future<bool> createPr(
  Map<String, dynamic> repo,
  Map<String, dynamic> evaluation,
  String infoDart,
  String pageDart,
  Map<String, String> missingDeps,
  String libraryPubspec,
) async {
  final id = showcaseId(repo);
  final displayName = showcaseDisplayName(repo);
  final owner = (repo['owner'] as Map)['login'] as String;
  final branch = 'auto/discover-$id';
  final cloneDir = '/tmp/flexer-showcase-$id';

  // Clean up any previous failed attempt.
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

  // Write showcase files.
  final showcaseDir = Directory('$cloneDir/lib/$id');
  await showcaseDir.create(recursive: true);
  await File('$cloneDir/lib/$id/showcase_info.dart').writeAsString(infoDart);
  await File('$cloneDir/lib/$id/${id}_page.dart').writeAsString(pageDart);

  // Patch pubspec.yaml with missing deps.
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
  print('Already submitted/open: ${submittedUrls.length} repos');

  final seen = <String>{};
  final candidates = <Map<String, dynamic>>[];

  for (final query in _searchQueries) {
    await Future<void>.delayed(const Duration(seconds: 1));
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
    (a, b) =>
        (b['stargazers_count'] as int).compareTo(a['stargazers_count'] as int),
  );
  print('New candidates: ${candidates.length}');

  // Fetch showcase library pubspec once — reused for dep diffing.
  final libraryPubspec = await ghFile(_showcaseRepo, 'pubspec.yaml') ?? '';

  var submitted = 0;

  for (final repo in candidates) {
    if (submitted >= _maxPerRun) break;

    print('\n▸ ${repo['full_name']} (${repo['stargazers_count']} ★)');

    final readme =
        await ghFile(repo['full_name'] as String, 'README.md') ??
        await ghFile(repo['full_name'] as String, 'readme.md') ??
        '';

    final sourcePubspec =
        await ghFile(repo['full_name'] as String, 'pubspec.yaml') ?? '';

    final tree = await ghTree(repo['full_name'] as String);
    final dartFilePaths = topDartFiles(tree);
    if (dartFilePaths.isEmpty) {
      print('  No dart files — skip');
      continue;
    }

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
      print('  Could not fetch dart source — skip');
      continue;
    }

    await Future<void>.delayed(Duration(seconds: _geminiDelaySec));
    final evaluation = await scoreRepo(repo, readme, dartSnippets.toString());
    if (evaluation == null) continue;

    final score = evaluation['score'] as int? ?? 0;
    print('  Score $score/10 — ${evaluation['reason']}');

    if (evaluation['suitable'] != true || score < _scoreThreshold) {
      print('  Below threshold — skip');
      continue;
    }

    final missingDeps = computeMissingDeps(sourcePubspec, libraryPubspec);
    if (missingDeps.isNotEmpty) {
      print('  Missing deps: ${missingDeps.keys.join(', ')}');
    }

    final mainFile = evaluation['main_dart_file'] as String?;
    final sourceDart = mainFile != null
        ? await ghFile(repo['full_name'] as String, mainFile) ??
              dartSnippets.toString()
        : dartSnippets.toString();

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
      if (await createPr(
        repo,
        evaluation,
        infoDart,
        pageDart,
        missingDeps,
        libraryPubspec,
      )) {
        submitted++;
      }
    } catch (e) {
      print('  Error: $e');
    }

    await Future<void>.delayed(const Duration(seconds: 2));
  }

  print('\n=== Done. $submitted PR(s) submitted. ===');
}
