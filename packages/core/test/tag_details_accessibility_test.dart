// Keep semantics inspection compatible with the minimum Flutter 3.32 SDK.
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

// Deliberately independent of _.dart, whose harness excludes semantics.
Future<void> pumpHtml(
  WidgetTester tester,
  String html, {
  CustomWidgetBuilder? customWidgetBuilder,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: HtmlWidget(html, customWidgetBuilder: customWidgetBuilder),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('summary supports keyboard focus and Enter/Space activation', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    try {
      await pumpHtml(
        tester,
        '<details><summary>More information</summary>Hidden content</details>',
      );

      final summary = find.bySemanticsLabel(RegExp('More information'));
      expect(
          tester.getSemantics(summary).hasFlag(SemanticsFlag.isButton), isTrue);
      expect(
        tester.getSemantics(summary).hasFlag(SemanticsFlag.hasExpandedState),
        isTrue,
      );
      expect(tester.getSemantics(summary).hasFlag(SemanticsFlag.isExpanded),
          isFalse);
      expect(find.bySemanticsLabel('Hidden content'), findsNothing);

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();
      expect(tester.getSemantics(summary).hasFlag(SemanticsFlag.isFocused),
          isTrue);
      final outline = find.descendant(
        of: find.byType(FocusableActionDetector),
        matching: find.byType(DecoratedBox),
      );
      expect(
        (tester.widget<DecoratedBox>(outline).decoration as BoxDecoration)
            .border,
        isNotNull,
      );

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(tester.getSemantics(summary).hasFlag(SemanticsFlag.isExpanded),
          isTrue);
      expect(find.bySemanticsLabel('Hidden content'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pumpAndSettle();
      expect(tester.getSemantics(summary).hasFlag(SemanticsFlag.isExpanded),
          isFalse);
      expect(find.bySemanticsLabel('Hidden content'), findsNothing);
      expect(tester.getSemantics(summary).hasFlag(SemanticsFlag.isFocused),
          isTrue);
    } finally {
      semantics.dispose();
    }
  });

  testWidgets('default summary exposes initial open state and semantic tap', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    try {
      await pumpHtml(tester, '<details open>Contents</details>');
      final summary = find.bySemanticsLabel(RegExp('Details'));
      final node = tester.getSemantics(summary);
      expect(node.hasFlag(SemanticsFlag.isExpanded), isTrue);
      tester.binding.pipelineOwner.semanticsOwner!.performAction(
        node.id,
        SemanticsAction.tap,
      );
      await tester.pumpAndSettle();
      expect(tester.getSemantics(summary).hasFlag(SemanticsFlag.isExpanded),
          isFalse);
      expect(find.bySemanticsLabel('Contents'), findsNothing);
    } finally {
      semantics.dispose();
    }
  });

  testWidgets('summary does not handle Space from a focused child',
      (tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    await pumpHtml(
      tester,
      '<details><summary><custom-text-field></custom-text-field></summary>'
      'Hidden content</details>',
      customWidgetBuilder: (element) => element.localName == 'custom-text-field'
          ? TextField(controller: controller)
          : null,
    );

    await tester.tap(find.byType(TextField));
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pumpAndSettle();

    expect(find.bySemanticsLabel('Hidden content'), findsNothing);
    expect(
        tester
            .widget<EditableText>(find.byType(EditableText))
            .focusNode
            .hasFocus,
        isTrue);
    await tester.enterText(find.byType(EditableText), ' ');
    expect(controller.text, ' ');
  });

  testWidgets('baseline link, heading text, and image description are exposed',
      (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    try {
      await pumpHtml(
        tester,
        '<h1>Heading text</h1><p><a href="https://example.com">Link text</a></p>'
        '<img alt="Image description">',
      );
      expect(find.bySemanticsLabel('Heading text'), findsOneWidget);
      final nodes = <SemanticsNode>[];
      void collect(SemanticsNode node) {
        nodes.add(node);
        node.visitChildren((child) {
          collect(child);
          return true;
        });
      }

      collect(tester.binding.pipelineOwner.semanticsOwner!.rootSemanticsNode!);
      final link = nodes.singleWhere((node) => node.label == 'Link text');
      expect(link.hasFlag(SemanticsFlag.isLink), isTrue);
      expect(link.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);
      expect(find.bySemanticsLabel('Image description'), findsOneWidget);
    } finally {
      semantics.dispose();
    }
  });
}
