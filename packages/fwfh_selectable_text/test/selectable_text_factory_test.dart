import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fwfh_selectable_text/fwfh_selectable_text.dart';

import '_.dart';

void main() {
  testWidgets('renders SelectableText', (WidgetTester tester) async {
    const html = 'Foo';
    final explained = await explain(tester, html, _FactoryDefault());
    expect(explained, equals('[SelectableText:(:Foo)]'));
  });

  testWidgets('skips SelectableText if disabled', (WidgetTester tester) async {
    const html = 'Foo';
    final explained = await explain(tester, html, _FactoryGetterReturnsFalse());
    expect(explained, equals('[RichText:(:Foo)]'));
  });

  group('text-overflow', () {
    testWidgets('renders clip', (WidgetTester tester) async {
      const html = '<div style="text-overflow: clip">Foo</div>';
      final explained = await explain(tester, html, _FactoryDefault());
      expect(explained, equals('[CssBlock:child=[SelectableText:(:Foo)]]'));
    });

    testWidgets('skips ellipsis', (WidgetTester tester) async {
      const html = '<div style="text-overflow: ellipsis">Foo</div>';
      final e = await explain(tester, html, _FactoryDefault());
      expect(e, equals('[CssBlock:child=[RichText:overflow=ellipsis,(:Foo)]]'));
    });
  });

  group('selectableTextOnChanged', () {
    testWidgets('sets onSelectionChanged', (WidgetTester tester) async {
      const html = 'Foo';
      final explained = await explain(tester, html, _FactoryWithCallback());
      expect(explained, equals('[SelectableText:+onSelectionChanged,(:Foo)]'));
    });

    testWidgets('calls callback', (WidgetTester tester) async {
      const html = 'Foo';
      final list = [];
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HtmlWidget(
              html,
              factoryBuilder: () => _FactoryWithCallback(list),
            ),
          ),
        ),
      );

      expect(list, isEmpty);
      await tester.tap(find.byType(SelectableText));

      expect(list, isNotEmpty);
      expect(list[0], isA<TextSelection>());
      expect(list[1], equals(SelectionChangedCause.tap));
    });
  });
}

class _FactoryDefault extends WidgetFactory with SelectableTextFactory {}

class _FactoryGetterReturnsFalse extends WidgetFactory
    with SelectableTextFactory {
  @override
  bool get selectableText => false;
}

class _FactoryWithCallback extends WidgetFactory with SelectableTextFactory {
  final List? list;

  _FactoryWithCallback([this.list]);

  @override
  SelectionChangedCallback? get selectableTextOnChanged =>
      (selection, cause) => list?.addAll([selection, cause]);
}
