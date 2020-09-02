import 'package:demo_app/screens/smilie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

class _TestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        home: SmilieScreen(),
        theme: ThemeData.light(),
      );
}

void main() {
  testGoldens('smilie', (tester) async {
    await tester.pumpWidgetBuilder(
      SmilieScreen(),
      wrapper: materialAppWrapper(theme: ThemeData.light()),
      surfaceSize: Size(400, 200),
    );

    await screenMatchesGolden(tester, 'others/smilie');
  });
}
