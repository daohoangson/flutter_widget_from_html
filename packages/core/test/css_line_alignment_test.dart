import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

Finder textFinder(String text) => find.byWidgetPredicate(
      (widget) => widget is RichText && widget.text.toPlainText() == text,
    );

Future<void> pumpHtml(
  WidgetTester tester,
  String html, {
  TextDirection direction = TextDirection.ltr,
  double height = 1,
  double width = 750,
  double scale = 1,
  bool intrinsic = false,
  bool selectable = false,
  void Function(String)? onTap,
  ValueChanged<SelectedContent?>? onSelectionChanged,
}) async {
  Widget content = HtmlWidget(
    html,
    textStyle: TextStyle(fontSize: 26, height: height),
    onTapUrl: (url) {
      onTap?.call(url);
      return true;
    },
  );
  if (intrinsic) {
    content = IntrinsicHeight(child: content);
  }
  if (selectable) {
    content =
        SelectionArea(onSelectionChanged: onSelectionChanged, child: content);
  }
  await tester.pumpWidget(MaterialApp(
    home: Scaffold(
      body: MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(scale)),
        child: Directionality(
          textDirection: direction,
          child: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(width: width, child: content),
          ),
        ),
      ),
    ),
  ));
  await tester.pumpAndSettle();
}

void main() {
  for (final direction in TextDirection.values) {
    for (final size in [10, 26, 40]) {
      for (final height in [1.0, 1.4, 2.0]) {
        testWidgets('line edges $direction size=$size height=$height',
            (tester) async {
          await pumpHtml(
            tester,
            'M <span style="vertical-align:top;font-size:${size}px">T</span> '
            '<span style="vertical-align:bottom;font-size:${size}px">B</span>',
            direction: direction,
            height: height,
          );
          final paragraph = tester.getRect(textFinder('M \uFFFC \uFFFC'));
          final top = tester.getRect(textFinder('T'));
          final bottom = tester.getRect(textFinder('B'));
          expect(top.top, closeTo(paragraph.top, 1));
          expect(bottom.bottom, closeTo(paragraph.bottom, 1));
          expect(top.top, lessThanOrEqualTo(bottom.top + 1));
        });
      }
    }
  }

  testWidgets('mixed sub/super and explicit line breaks', (tester) async {
    await pumpHtml(
      tester,
      'M <span style="vertical-align:super">sup</span> '
      '<span style="vertical-align:sub">sub</span> '
      '<span style="vertical-align:top">T</span> '
      '<span style="vertical-align:bottom">B</span><br>'
      'M <span style="vertical-align:top">T2</span> '
      '<span style="vertical-align:bottom">B2</span>',
      height: 1.4,
    );
    expect(tester.getTopLeft(textFinder('T')).dy,
        lessThan(tester.getTopLeft(textFinder('B')).dy));
    expect(tester.getTopLeft(textFinder('T2')).dy,
        closeTo(tester.getTopLeft(textFinder('B2')).dy, 1));
    expect(tester.takeException(), isNull);
  });

  testWidgets('wrapping, resizing, scaling and intrinsic height',
      (tester) async {
    for (final width in [700.0, 120.0, 400.0]) {
      await pumpHtml(
        tester,
        'M <span style="vertical-align:top;font-size:40px">T</span> '
        'normal <span style="vertical-align:bottom">B</span> normal',
        width: width,
        height: 1.4,
        scale: 1.5,
        intrinsic: true,
      );
      final finder = find.byWidgetPredicate(
          (w) => w is RichText && w.text.toPlainText().startsWith('M \uFFFC'));
      final paragraph = tester.renderObject<RenderParagraph>(finder);
      final dry = paragraph.getDryLayout(paragraph.constraints);
      expect(dry.height, closeTo(paragraph.size.height, 1));
      expect(paragraph.getMaxIntrinsicHeight(paragraph.size.width),
          closeTo(paragraph.size.height, 1));
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('aligned link remains tappable in a selection area',
      (tester) async {
    String? tapped;
    await pumpHtml(
      tester,
      'M <a href="https://example.com" style="vertical-align:top">link</a> '
      '<span style="vertical-align:bottom">B</span>',
      height: 2,
      selectable: true,
      onTap: (url) => tapped = url,
    );
    await tester.tap(textFinder('link'));
    await tester.pump();
    expect(tapped, 'https://example.com');
    expect(tester.takeException(), isNull);
  });
  testWidgets('selection includes text inside an aligned span', (tester) async {
    SelectedContent? selected;
    await pumpHtml(
      tester,
      'M <span style="vertical-align:top">select me</span> '
      '<span style="vertical-align:bottom">B</span>',
      height: 1.4,
      selectable: true,
      onSelectionChanged: (value) => selected = value,
    );
    final paragraph =
        tester.renderObject<RenderParagraph>(textFinder('select me'));
    Offset caret(int offset) =>
        paragraph.localToGlobal(paragraph.getOffsetForCaret(
                TextPosition(offset: offset),
                const Rect.fromLTWH(0, 0, 2, 20)) +
            Offset(1, paragraph.size.height / 2));
    final gesture =
        await tester.startGesture(caret(0), kind: PointerDeviceKind.mouse);
    addTearDown(gesture.removePointer);
    await tester.pump();
    await gesture.moveTo(caret(9));
    await gesture.up();
    await tester.pump();
    expect(selected?.plainText, 'select me');
  });

  testWidgets('ellipsis hides later aligned children', (tester) async {
    await pumpHtml(
      tester,
      '<div style="max-lines:1;text-overflow:ellipsis">M '
      '<span style="vertical-align:top">T</span> more text more text '
      '<span style="vertical-align:bottom">B</span></div>',
      width: 160,
      height: 1.4,
    );
    final finder = find.byWidgetPredicate(
        (w) => w is RichText && w.text.toPlainText().startsWith('M \uFFFC'));
    final paragraph = tester.renderObject<RenderParagraph>(finder);
    expect(paragraph.didExceedMaxLines, isTrue);
    expect(tester.getTopLeft(textFinder('T')).dy,
        closeTo(tester.getTopLeft(finder).dy, 1));
    expect(tester.takeException(), isNull);
  });

  testWidgets('nested line-aligned spans retain their own line edges',
      (tester) async {
    await pumpHtml(
      tester,
      'M <span style="vertical-align:top">outer '
      '<span style="vertical-align:bottom;font-size:10px">inner</span></span> '
      '<span style="vertical-align:bottom">B</span>',
      height: 1.4,
    );
    final outer = tester.getRect(textFinder('outer \uFFFC'));
    final inner = tester.getRect(textFinder('inner'));
    expect(inner.bottom, closeTo(outer.bottom, 1));
    expect(outer.top, closeTo(tester.getTopLeft(textFinder('B')).dy, 1));
  });
}
