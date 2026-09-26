import 'dart:io';

import 'package:demo_app/screens/smilie.dart';
import 'package:flutter/widgets.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import 'material_app.dart';

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
        wrapper: materialUiAppWrapper,
        surfaceSize: const Size(400, 200),
      );

      await screenMatchesGolden(tester, 'others/smilie');
    },
    skip: goldenSkip != null,
  );
}
