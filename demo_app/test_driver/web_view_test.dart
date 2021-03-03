import 'dart:async';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

import '_1.dart';

void main() {
  group('WebView', () {
    FlutterDriver driver;
    final s1Finder = find.byValueKey('input-1.0');
    final s2Finder = find.byValueKey('input-2.0');
    final s3Finder = find.byValueKey('input-3.0');
    final issue375S1Finder = find.byValueKey('input-1.0-issue375');
    final issue375S2Finder = find.byValueKey('input-2.0-issue375');
    final issue375S3Finder = find.byValueKey('input-3.0-issue375');

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        await driver.close();
      }
    });

    test('resizes to 1.0', () async {
      await driver.tap(s1Finder);
      await Future.delayed(const Duration(seconds: 10));
      expectAspectRatio(driver, 1);
    });

    test('renders 2.0 without resizing', () async {
      await driver.tap(s2Finder);
      await Future.delayed(const Duration(seconds: 10));
      expectAspectRatio(driver, 16 / 9);
    });

    test('renders 3.0 without resizing', () async {
      await driver.tap(s3Finder);
      await Future.delayed(const Duration(seconds: 10));
      expectAspectRatio(driver, 16 / 9);
    });

    group('unsupportedWorkaroundForIssue375', () {
      test('resizes to 1.0', () async {
        await driver.tap(issue375S1Finder);
        await Future.delayed(const Duration(seconds: 10));
        expectAspectRatio(driver, 1);
      });

      test('renders 2.0 without resizing', () async {
        await driver.tap(issue375S2Finder);
        await Future.delayed(const Duration(seconds: 10));
        expectAspectRatio(driver, 16 / 9);
      });

      test('renders 3.0 without resizing', () async {
        await driver.tap(issue375S3Finder);
        await Future.delayed(const Duration(seconds: 10));
        expectAspectRatio(driver, 16 / 9);
      });
    });
  });
}
