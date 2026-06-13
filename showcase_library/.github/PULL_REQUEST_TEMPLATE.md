# Showcase Submission

## Showcase Info

- **Name:**
- **GitHub repo URL:** (your showcase's GitHub repo — used as unique identifier)

## Structure

Each showcase is **exactly two files** inside `lib/<id>/`:

```
lib/
  <author>_<showcase_name>/
    showcase_info.dart       ← metadata
    <author>_<showcase_name>_page.dart  ← the Flutter page
```

No `pubspec.yaml` per showcase — all dependencies are shared via the root `pubspec.yaml`.
If your showcase needs packages not already in the root `pubspec.yaml`, list them below
and the reviewer will add them.

**Extra packages needed (if any):**
- none

## Checklist

- [ ] Folder named `<author>_<showcase_name>` (e.g. `dev_maverick_fluid_sidebar`)
- [ ] `<id>_page.dart` — Flutter page that launches when the experience opens
- [ ] `showcase_info.dart` — uses `ShowcaseInfo(showcaseName, githubRepoUrl, orientation?, description?)`. No `author` field — extracted from `githubRepoUrl` automatically
- [ ] No existing showcase from this GitHub repo (one showcase per repo)
- [ ] Licensed under MIT, Apache 2.0, or BSD — license stated in the source repo
- [ ] Showcase runs without errors on Android and iOS
- [ ] I am the author or have explicit permission to submit this work
