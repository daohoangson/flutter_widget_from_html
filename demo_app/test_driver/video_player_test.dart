import 'dart:async';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

import '_1.dart';

void main() {
  group('VideoPlayer', () {
    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        await driver.close();
      }
    });

    test('resizes to 1.78', () async {
      const src =
          'https://interactive-examples.mdn.mozilla.net/media/cc0-videos/flower.mp4';
      await driver.tap(find.byValueKey(src));
      await Future.delayed(const Duration(seconds: 20));
      await expectAspectRatio(driver, 1.78);
    });
  });
}
