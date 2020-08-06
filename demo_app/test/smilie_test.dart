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
    await tester.pumpWidget(_TestApp());
    await expectLater(
      find.byType(SmilieScreen),
      matchesGoldenFile('./images/others/smilie.png'),
    );
  });
}
