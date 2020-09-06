import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart'
    as enhanced;
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart'
    as core;
import 'package:golden_toolkit/golden_toolkit.dart';

final _withEnhancedRegExp = RegExp(r'(^(A|HR)$|colspan|rowspan)');

class _TestApp extends StatelessWidget {
  final String html;
  final Key targetKey;
  final bool withEnhanced;

  const _TestApp(
    this.html, {
    Key key,
    this.targetKey,
    this.withEnhanced,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      Text(html),
      Divider(),
      if (withEnhanced)
        Text(
          'flutter_widget_from_html_core:\n',
          style: Theme.of(context).textTheme.caption,
        ),
      LimitedBox(
        child: core.HtmlWidget(html),
        maxHeight: 400,
      ),
    ];

    if (withEnhanced) {
      children.addAll(<Widget>[
        Divider(),
        Text(
          'flutter_widget_from_html:\n',
          style: Theme.of(context).textTheme.caption,
        ),
        LimitedBox(
          child: enhanced.HtmlWidget(html),
          maxHeight: 400,
        ),
      ]);
    }

    return SingleChildScrollView(
      child: RepaintBoundary(
        child: Container(
          child: Padding(
            child: Column(
              children: children,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
            ),
            padding: const EdgeInsets.all(10),
          ),
          color: Colors.white,
        ),
        key: targetKey,
      ),
    );
  }
}

void _test(String name, String html) => testGoldens(name, (tester) async {
      final key = UniqueKey();

      await tester.pumpWidgetBuilder(
        _TestApp(
          html,
          targetKey: key,
          withEnhanced: _withEnhancedRegExp.hasMatch(name),
        ),
        wrapper: materialAppWrapper(theme: ThemeData.light()),
        surfaceSize: Size(400, 1200),
      );

      await screenMatchesGolden(tester, name, finder: find.byKey(key));
    });

void main() {
  final json = File('goldens.json').readAsStringSync();
  final map = jsonDecode(json) as Map;
  map.entries.forEach((entry) => _test(entry.key, entry.value));
}
