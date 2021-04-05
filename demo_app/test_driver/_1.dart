import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

import '_0.dart';

Future<void> expectAspectRatio(FlutterDriver driver, double value,
    {double epsilon = 0.1}) async {
  final text = await driver.getText(find.byValueKey(kResultKey));
  final parsed = double.tryParse(text);
  expect(parsed, isNotNull);

  expect((value - parsed) < epsilon, isTrue);
}
