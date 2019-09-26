import 'dart:async';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('WebView', () {
    FlutterDriver driver;
    final s1Finder = find.byValueKey('input-1.0');
    final s2Finder = find.byValueKey('input-2.0');
    final s3Finder = find.byValueKey('input-3.0');
    final rFinder = find.byValueKey('output');

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
      await Future.delayed(Duration(seconds: 20));
      expect(await driver.getText(rFinder), '1.00');
    });

    test('renders 2.0 without resizing', () async {
      await driver.tap(s2Finder);
      await Future.delayed(Duration(seconds: 20));
      expect(await driver.getText(rFinder), '1.78');
    });

    test('renders 3.0 without resizing', () async {
      await driver.tap(s3Finder);
      await Future.delayed(Duration(seconds: 20));
      expect(await driver.getText(rFinder), '1.78');
    });
  });
}
