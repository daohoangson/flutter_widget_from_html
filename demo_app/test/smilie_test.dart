import 'dart:io';

import 'package:demo_app/screens/smilie.dart';
import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

void main() {
  testGoldens('smilie', (tester) async {
    await tester.pumpWidgetBuilder(
      SmilieScreen(),
      wrapper: materialAppWrapper(theme: ThemeData.light()),
      surfaceSize: Size(400, 200),
    );

    await screenMatchesGolden(tester, 'others/smilie');
  }, skip: !Platform.isLinux);
}
