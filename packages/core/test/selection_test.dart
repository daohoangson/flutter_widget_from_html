import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '_.dart';

Offset textOffsetToPosition(RenderParagraph paragraph, int offset) {
  final caretOffset = paragraph.getOffsetForCaret(
    TextPosition(offset: offset),
    const Rect.fromLTWH(0.0, 0.0, 2.0, 20.0),
  );
  return paragraph.localToGlobal(caretOffset);
}

Future<void> selectGesture(
  WidgetTester tester,
  String from,
  String to, {
  int fromOffset = 0,
  int toOffset = 0,
}) async {
  final fromParagraph = tester.renderObject<RenderParagraph>(findText(from));
  final gesture = await tester.startGesture(
    textOffsetToPosition(fromParagraph, fromOffset),
    kind: PointerDeviceKind.mouse,
  );
  addTearDown(gesture.removePointer);
  await tester.pump();

  final toParagraph = tester.renderObject<RenderParagraph>(findText(to));
  await gesture.moveTo(textOffsetToPosition(toParagraph, toOffset));
  await gesture.up();
  await tester.pump();
}

void main() async {
  testWidgets('allows text selection in Column', (WidgetTester tester) async {
    const html = '<p>Foo</p><p>Column</p><p>Bar</p>';

    SelectedContent? content;
    await explain(
      tester,
      null,
      hw: SelectionArea(
        onSelectionChanged: (v) => content = v,
        child: HtmlWidget(html, key: hwKey),
      ),
    );

    await selectGesture(tester, 'Foo', 'Bar');
    expect(content?.plainText, 'FooColumn');
  });

  testWidgets('allows text selection in ListView', (WidgetTester tester) async {
    const html = '<p>Foo</p><p>ListView</p><p>Bar</p>';

    SelectedContent? content;
    await explain(
      tester,
      null,
      hw: SelectionArea(
        onSelectionChanged: (v) => content = v,
        child: HtmlWidget(
          html,
          key: hwKey,
          renderMode: RenderMode.listView,
        ),
      ),
    );

    await selectGesture(tester, 'Foo', 'Bar');
    expect(content?.plainText, 'FooListView');
  });

  testWidgets('#1224: supports nested HtmlWidget in ListView', (tester) async {
    const html = '<p>Foo</p><span>?</span><p>Bar</p>';

    SelectedContent? content;
    await explain(
      tester,
      null,
      hw: SelectionArea(
        onSelectionChanged: (v) => content = v,
        child: HtmlWidget(
          html,
          customWidgetBuilder: (element) {
            if (element.localName == 'span') {
              return const HtmlWidget('Nested');
            }
            return null;
          },
          key: hwKey,
          renderMode: RenderMode.listView,
        ),
      ),
    );

    await selectGesture(tester, 'Foo', 'Bar');
    expect(content?.plainText, 'FooNested');
  });

  testWidgets('allows text selection in SliverList', (tester) async {
    const html = '<p>Foo</p><p>SliverList</p><p>Bar</p>';

    SelectedContent? content;
    await explain(
      tester,
      null,
      hw: SelectionArea(
        onSelectionChanged: (v) => content = v,
        child: CustomScrollView(
          slivers: [
            HtmlWidget(
              html,
              key: hwKey,
              renderMode: RenderMode.sliverList,
            ),
          ],
        ),
      ),
    );

    await selectGesture(tester, 'Foo', 'Bar');
    expect(content?.plainText, 'FooSliverList');
  });
}
