import 'dart:io';

import 'package:demo_app/screens/smilie.dart';
import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

void main() {
  final goldenSkipEnvVar = Platform.environment['GOLDEN_SKIP'];
  final goldenSkip = goldenSkipEnvVar == null
      ? Platform.isLinux
          ? null
          : 'Linux only'
      : 'GOLDEN_SKIP=$goldenSkipEnvVar';

  testGoldens(
    'smilie',
    (tester) async {
      await tester.pumpWidgetBuilder(
        const SmilieScreen(),
        wrapper: materialAppWrapper(theme: ThemeData.light()),
        surfaceSize: const Size(400, 200),
      );

      await screenMatchesGolden(tester, 'others/smilie');
    },
    skip: goldenSkip != null,
  );
}
