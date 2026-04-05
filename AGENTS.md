# Repository Guidelines

## Project Structure & Module Organization

- `packages/`: Dart/Flutter packages. Core at `packages/core`, public wrapper at `packages/enhanced`, and feature add‑ons under `packages/fwfh_*`.
- `demo_app/`: Example Flutter app for manual testing and screenshots.
- `tool/`: Helper scripts (notably `tool/test.sh`).
- `docs/`, `.github/`: Documentation and CI.
  - Use `context7CompatibleLibraryID=/flutter/website` with `context7.get-library-docs` tool for latest Flutter documentation.
- Tests live in each package’s `test/` and in `demo_app/test/`. Golden assets are under `test/images/`.

## Build, Test, and Development Commands

- Install latest deps: `./tool/pub-get.sh`.
- Analyze all + run tests: `./tool/test.sh` (accepts extra flags like `--coverage` or `--update-goldens`).
- Format code: `dart format .`.
- Per‑package checks: `flutter analyze` and `flutter test` from each package dir.

## Coding Style & Naming Conventions

- Dart style with 2‑space indentation; keep lines focused and readable.
- Lints: `package:lint` plus repo rules (see each `analysis_options.yaml`). Prefer relative imports, avoid relative `lib/` imports.
- Names: classes `PascalCase`, members `camelCase`, constants `SCREAMING_SNAKE_CASE`, private with leading `_`.

## Testing Guidelines

- Frameworks: `flutter_test`, `test`, and `golden_toolkit` for widget/golden tests.
- Location: place tests next to code in `package/test/*.dart` with `_test.dart` suffix.
- Goldens: store expected images under `test/images/`; regenerate with `--update-goldens` and review diffs.
- Web interop (when applicable): see `packages/fwfh_webview` integration tests; ensure Chrome/driver available if running locally.
- Golden images must be generated on Linux, not macOS (font rendering differs). Use Docker or CI with `--update-goldens`.
- Always run `dart format .` before committing. The tall style formatter can cause large reformats.

## Release Workflow

- CHANGELOGs are updated at tagging time, not at merge time. Do not add changelog entries during feature work.
- Core and enhanced READMEs share the same feature list structure. When adding a feature to core, update both `packages/core/README.md` and `packages/enhanced/README.md`.
- Sub‑package README version pins (e.g., `^0.16.0` not `^0.16.1`) are intentional. Do not bump these to patch versions.
- Verify Flutter stable compatibility before adopting new Android toolchain versions (e.g., AGP 9 required Flutter APIs not yet in stable).

## Community PR Workflow

- Push fixes to the contributor's fork remote, not origin. Add the fork as a remote first.
- SonarQube failures on fork PRs are expected because secrets are unavailable to external contributors.
- Clean up unrelated changes (example app modifications, `.gitignore` additions) before merging.
- PRs are squash‑merged with a clean single commit message.

## Code Patterns

- CSS property implementations go in `packages/core/lib/src/internal/ops/style_*.dart`.
- Tests mirror at `packages/core/test/style_*_test.dart` or `tag_*_test.dart`.
- If code is unused, delete it. Do not keep commented‑out references or re‑export stubs.
- `list-style-type` intentionally falls through to canvas‑drawn shapes (disc/circle/square) when a value is not in the `CssCounterStyle` registry.
