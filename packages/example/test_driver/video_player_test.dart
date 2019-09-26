import 'dart:async';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

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

    test(
      'resizes to 1.82',
      () async {
        final src = 'https://www.w3schools.com/html/mov_bbb.mp4';
        await driver.tap(find.byValueKey(src));
        await Future.delayed(Duration(minutes: 1));
        expect(await driver.getText(find.byValueKey('output')), '1.82');
      },
      timeout: const Timeout(Duration(minutes: 2)),
    );
  });
}
