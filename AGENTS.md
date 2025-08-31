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
