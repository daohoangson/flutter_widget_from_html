import 'dart:convert';
import 'dart:io';

import 'package:demo_app/screens/golden.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

void _test(String name, String html) => testGoldens(name, (tester) async {
      final platform = TargetPlatform.linux;
      debugDefaultTargetPlatformOverride = platform;
      final key = UniqueKey();

      await tester.pumpWidgetBuilder(
        Golden(name, html, targetKey: key),
        wrapper: materialAppWrapper(
          platform: platform,
          theme: ThemeData.light(),
        ),
        surfaceSize: const Size(400, 1200),
      );

      await screenMatchesGolden(tester, name, finder: find.byKey(key));
      debugDefaultTargetPlatformOverride = null;
    }, skip: !Platform.isLinux);

void main() {
  final json = File('test/goldens.json').readAsStringSync();
  final map = jsonDecode(json) as Map;
  map.entries.forEach((entry) => _test(entry.key, entry.value));
}
