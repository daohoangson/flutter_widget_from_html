import 'package:flutter_test/flutter_test.dart';

import '../tool/metadata.dart';

void main() {
  test('Flutter metadata keeps only comparison fields', () {
    final filtered = filterFlutterVersion({
      'frameworkVersion': '3.47.0',
      'channel': 'stable',
      'repositoryUrl': 'https://example.com/custom/flutter.git',
      'frameworkRevision': 'framework-revision',
      'frameworkCommitDate': '2026-08-11 11:53:49 -0700',
      'engineRevision': 'engine-revision',
      'engineCommitDate': '2026-08-11 16:38:36.000Z',
      'engineContentHash': 'engine-content-hash',
      'engineBuildDate': '2026-08-12 00:18:15.653',
      'dartSdkVersion': '3.13.0',
      'devToolsVersion': '2.60.0',
      'flutterVersion': '3.47.0',
      'flutterRoot': '/Users/alice/flutter',
    });

    expect(filtered, {
      'frameworkVersion': '3.47.0',
      'channel': 'stable',
      'frameworkRevision': 'framework-revision',
      'frameworkCommitDate': '2026-08-11 11:53:49 -0700',
      'engineRevision': 'engine-revision',
      'engineCommitDate': '2026-08-11 16:38:36.000Z',
      'engineContentHash': 'engine-content-hash',
      'engineBuildDate': '2026-08-12 00:18:15.653',
      'dartSdkVersion': '3.13.0',
      'devToolsVersion': '2.60.0',
    });
  });

  test('device metadata describes only the selected target', () {
    final sanitized = sanitizeDevice(
      [
        {
          'name': "Alice's iPhone",
          'id': '00001234-000A123456789ABC',
          'targetPlatform': 'ios',
          'sdk': 'iOS 26.0',
        },
        {
          'name': "Alice's MacBook Pro",
          'id': 'macos',
          'targetPlatform': 'darwin',
          'sdk': 'macOS 15.6 24G84 darwin-arm64',
        },
      ],
      'macos',
      osVersion: '15.6',
      architecture: 'arm64',
    );

    expect(sanitized, {
      'platform': 'darwin',
      'osVersion': '15.6',
      'architecture': 'arm64',
    });
  });

  test('web metadata retains the selected browser version', () {
    final sanitized = sanitizeDevice(
      [
        {
          'name': 'Chrome',
          'id': 'chrome',
          'targetPlatform': 'web-javascript',
          'sdk': 'Google Chrome 151.0.7922.174',
        },
      ],
      'chrome',
      osVersion: '15.6',
      architecture: 'arm64',
    );

    expect(sanitized, {
      'platform': 'web-javascript',
      'osVersion': '15.6',
      'architecture': 'arm64',
      'browserVersion': '151.0.7922.174',
    });
  });
}
