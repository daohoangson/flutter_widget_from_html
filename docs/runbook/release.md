# Release Runbook

## Overview

This monorepo contains multiple packages that are versioned and released independently.
A release is prepared as a single PR with one commit per bumped package, followed by an "Update files" commit.

## Packages (publish order)

Packages must be published in dependency order (core first, enhanced last):

1. `packages/core` — `flutter_widget_from_html_core`
2. `packages/fwfh_cached_network_image`
3. `packages/fwfh_chewie`
4. `packages/fwfh_just_audio`
5. `packages/fwfh_svg`
6. `packages/fwfh_url_launcher`
7. `packages/fwfh_webview`
8. `packages/enhanced` — `flutter_widget_from_html`

## Step 1: Identify what changed

Find the most recent release tag:

```sh
git tag --sort=-creatordate | head -5
```

For each package, check for changes since that tag:

```sh
git log <tag>..origin/master --oneline -- packages/<package>/
```

Skip docs-only and formatting-only commits (they don't affect the published package).

## Step 2: Create the release branch

```sh
git checkout -b prepare/v<version> origin/master
```

The branch name uses the enhanced package version (the "main" package).

## Step 3: Bump each changed package

Create **one commit per package**, in dependency order. Each commit includes:

| File                             | Change                                       |
| -------------------------------- | -------------------------------------------- |
| `packages/<pkg>/pubspec.yaml`    | Bump `version:`                              |
| `packages/<pkg>/CHANGELOG.md`    | Add new version section at the top           |
| `packages/<pkg>/README.md`       | Update version in the `pubspec.yaml` snippet |
| `packages/enhanced/pubspec.yaml` | Bump dependency constraint for the package   |

### Commit message format

```
[<package_short_name>] v<version>
```

Examples: `[core] v0.17.2`, `[fwfh_webview] v0.15.7`, `[enhanced] v0.17.2`

### Changelog conventions

- List features first, then fixes
- Reference PR/issue numbers: `(#1234)`
- Credit external contributors: `(#1234, authored by @username)`
- Do not include docs-only or formatting-only changes

Example:

```markdown
## 0.17.2

- Add `text-emphasis` / `text-emphasis-style` support (#1561, authored by @CaptainDario)
- Fix border-radius with background-color for inline elements (#1569)
```

### Dependency constraints

When bumping a package, update the `^` constraint in downstream packages even if the old
constraint technically covers the new version. For example, if core goes from `0.17.1` to
`0.17.2`, update enhanced's `flutter_widget_from_html_core: ^0.17.1` to `^0.17.2`.

## Step 4: Update demo app files

```sh
./tool/update-demo_app-files.sh
```

This recreates the demo app's platform files and pubspec.lock. Commit the result:

```
Update files
```

## Step 5: Publish to pub.dev

Publish **before** pushing the PR. Some backward compatibility CI checks depend on
the new versions being available on pub.dev.

Requires `yq` (`brew install yq`).

```sh
./tool/pub-publish.sh
```

This script:

1. Checks each package for uncommitted changes
2. Skips packages whose version already exists on pub.dev
3. Removes `dependency_overrides`, runs `flutter pub get` and tests
4. Publishes via `flutter pub publish`
5. Reverts local changes after publishing

Packages are published in dependency order (core first, enhanced last).

## Step 6: Create the PR

```sh
git push -u origin prepare/v<version>
gh pr create --title "Prepare v<version> releases" --body ""
```

Previous release PRs have empty bodies. The per-commit messages are sufficient.

## Step 7: Merge and tag

After CI passes, merge the PR. Then tag:

```sh
git tag v<version>
git push origin v<version>
```
