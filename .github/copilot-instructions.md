# Flutter Widget from HTML

Flutter Widget from HTML is a monorepo containing Flutter/Dart packages that render HTML as Flutter widgets. The repository includes a core package, enhanced wrapper, feature extensions, and a demo app for testing.

Always reference these instructions first and fallback to search or bash commands only when you encounter unexpected information that does not match the info here.

## Working Effectively

Bootstrap, build, and test the repository:
- Check Flutter installation: `flutter --version` -- should show Flutter 3.35.2+ and Dart 3.9.0+
- Install dependencies: `./tool/pub-get.sh` -- takes 30 seconds. Dependencies are installed across all packages.
- Run full analysis and tests: `./tool/test.sh` -- takes 3-4 minutes. NEVER CANCEL. Set timeout to 10+ minutes.
- Run tests with coverage: `./tool/test.sh --coverage` -- takes 2-3 minutes. NEVER CANCEL. Set timeout to 8+ minutes.
- Format code: `dart format . --output none` -- takes 2-3 seconds.

## Build Commands

Web demo app:
- Build for web: `cd demo_app && flutter build web --release` -- takes 45 seconds. NEVER CANCEL. Set timeout to 2+ minutes.
- Run web app: `cd demo_app && flutter run -d web-server --web-port 8080 --web-hostname 0.0.0.0` -- starts development server.

Android demo app:
- Build debug APK: `cd demo_app && flutter build apk --debug` -- takes 1-2 minutes. NEVER CANCEL. Set timeout to 5+ minutes.
- Build release APKs: `cd demo_app && flutter build apk --release --split-per-abi` -- takes 2-3 minutes. NEVER CANCEL. Set timeout to 8+ minutes.

## Testing and Validation

Run tests with different options:
- Run all tests: `./tool/test.sh` -- takes 3-4 minutes. Runs analysis and tests for all packages.
- Run with coverage: `./tool/test.sh --coverage` -- takes 2-3 minutes. Generates coverage reports.
- Update golden files: `./tool/test.sh --update-goldens` -- takes 2-3 minutes. Updates visual regression test images.
- Update goldens only: `./tool/update-goldens.sh` -- convenience script for updating golden files.

Individual package testing:
- Analyze specific package: `cd packages/core && flutter analyze` -- takes 1-2 seconds.
- Test specific package: `cd packages/core && flutter test` -- takes 40-45 seconds.
- Test enhanced package: `cd packages/enhanced && flutter test` -- takes 20-25 seconds.

Integration testing:
- Web integration tests require chromedriver running on port 4444.
- Start chromedriver: `chromedriver --port=4444 &` then set `CHROMEDRIVER_PORT_4444=yes`.

## Validation Scenarios

Always test these scenarios after making changes:
- **Basic HTML rendering**: Run `cd demo_app && flutter test` to verify golden file tests pass -- takes 5-10 seconds.
- **Web demo functionality**: Build and run the demo app with `cd demo_app && flutter build web && flutter run -d web-server` and verify HTML rendering works.
- **Core package functionality**: Run `cd packages/core && flutter test` to ensure core widget functionality works.
- **Enhanced package features**: Run `cd packages/enhanced && flutter test` to verify enhanced features work.
- **Code formatting**: Run `dart format . --output none` and ensure no files are changed.

## Repository Structure

Key directories and their purposes:
- `packages/core/`: Core HTML widget package (`flutter_widget_from_html_core`)
- `packages/enhanced/`: Enhanced wrapper package (`flutter_widget_from_html`)
- `packages/fwfh_*/`: Feature extension packages (cached images, webview, audio, etc.)
- `demo_app/`: Example Flutter app for manual testing and screenshots
- `tool/`: Helper scripts for dependency management, testing, and publishing
- `test/images/`: Golden file assets for visual regression testing

## Package Dependencies

SDK requirements:
- Flutter: >=3.32.0
- Dart: >=3.4.0

Main dependencies across packages:
- `csslib`: CSS parsing
- `html`: HTML parsing
- `logging`: Logging framework
- `flutter_test`, `test`, `golden_toolkit`: Testing frameworks

## Common Tasks

Check for outdated dependencies:
- `./tool/pub-outdated.sh` -- shows outdated packages across all modules.

Publish packages to pub.dev:
- `./tool/pub-publish.sh` -- publishes all packages. Requires clean git state and version bumps.

Update demo app platform files:
- `./tool/update-demo_app-files.sh` -- regenerates iOS, Android, macOS, and web platform files.

## Development Workflow

When making changes:
1. Run `./tool/pub-get.sh` to ensure all dependencies are current
2. Make your changes to the appropriate package(s)
3. Format code with `dart format .`
4. Run relevant tests: `./tool/test.sh` or individual package tests
5. For UI changes, verify golden files with `./tool/test.sh --update-goldens`
6. Build and test the demo app to verify changes work end-to-end

## Key Files

Configuration files:
- `analysis_options.yaml`: Linting rules in each package directory
- `pubspec.yaml`: Package configuration in each package directory
- `dart_test.yaml`: Test configuration in demo_app

Important scripts:
- `tool/test.sh`: Main test runner with analysis and testing
- `tool/pub-get.sh`: Dependency installation across all packages
- `tool/update-goldens.sh`: Golden file update helper

## Known Issues and Workarounds

Format checking in CI:
- `dart format --set-exit-if-changed` is commented out in CI due to GitHub Actions issues
- Always run `dart format .` locally before committing

Web integration tests:
- Require Chrome/chromedriver for JavaScript interop testing
- Only run when `CHROMEDRIVER_PORT_4444` environment variable is set

Golden file testing:
- Visual regression tests use `golden_toolkit` framework
- Golden files stored in `test/images/` directories
- Regenerate with `--update-goldens` flag when making UI changes

## Timeout Guidelines

**CRITICAL**: Always use appropriate timeouts and NEVER CANCEL long-running commands:

- Dependency installation (`./tool/pub-get.sh`): 30 seconds -- use 2+ minute timeout
- Full test suite (`./tool/test.sh`): 3-4 minutes -- use 10+ minute timeout, NEVER CANCEL
- Coverage tests (`./tool/test.sh --coverage`): 2-3 minutes -- use 8+ minute timeout, NEVER CANCEL
- Golden updates (`./tool/test.sh --update-goldens`): 2-3 minutes -- use 8+ minute timeout, NEVER CANCEL
- Web build (`flutter build web`): 45 seconds -- use 2+ minute timeout, NEVER CANCEL
- APK builds (`flutter build apk`): 1-3 minutes -- use 5-8+ minute timeout, NEVER CANCEL
- Individual package tests: 20-45 seconds -- use 2+ minute timeout

Build and test commands may take longer than expected. This is NORMAL. Always wait for completion.