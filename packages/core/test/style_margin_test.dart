import 'package:flutter_test/flutter_test.dart';

import '_.dart';

void main() {
  final explain = explainMargin;

  testWidgets('renders text without margin', (WidgetTester tester) async {
    final html = '<div>Foo</div>';
    final explained = await explain(tester, html);
    expect(explained, equals('[RichText:(:Foo)]'));
  });

  group('4 values', () {
    testWidgets('parses all', (WidgetTester tester) async {
      final html = '<div style="margin: 1px 2px 3px 4px">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[SizedBox:0.0x1.0],'
              '[Padding:(0,2,0,4),child=[RichText:(:Foo)]],'
              '[SizedBox:0.0x3.0]'));
    });

    testWidgets('parses top only', (WidgetTester tester) async {
      final html = '<div style="margin: 1px 0 0 0">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[SizedBox:0.0x1.0],[RichText:(:Foo)]'));
    });

    testWidgets('parses right only', (WidgetTester tester) async {
      final html = '<div style="margin: 0 2px 0 0">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[Padding:(0,2,0,0),child=[RichText:(:Foo)]]'));
    });

    testWidgets('parses bottom only', (WidgetTester tester) async {
      final html = '<div style="margin: 0 0 3px 0">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)],[SizedBox:0.0x3.0]'));
    });

    testWidgets('parses left only', (WidgetTester tester) async {
      final html = '<div style="margin: 0 0 0 4px">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[Padding:(0,0,0,4),child=[RichText:(:Foo)]]'));
    });
  });

  group('2 values', () {
    testWidgets('parses both', (WidgetTester tester) async {
      final html = '<div style="margin: 5px 10px">Foo</div>';
      final e = await explain(tester, html);
      expect(
          e,
          equals('[SizedBox:0.0x5.0],'
              '[Padding:(0,10,0,10),child=[RichText:(:Foo)]],'
              '[SizedBox:0.0x5.0]'));
    });

    testWidgets('parses vertical only', (WidgetTester tester) async {
      final html = '<div style="margin: 5px 0">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[SizedBox:0.0x5.0],'
              '[RichText:(:Foo)],'
              '[SizedBox:0.0x5.0]'));
    });

    testWidgets('parses horizontal only', (WidgetTester tester) async {
      final html = '<div style="margin: 0 10px">Foo</div>';
      final e = await explain(tester, html);
      expect(e, equals('[Padding:(0,10,0,10),child=[RichText:(:Foo)]]'));
    });
  });

  testWidgets('parses margin with 1 value', (WidgetTester tester) async {
    final html = '<div style="margin: 3px">Foo</div>';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[SizedBox:0.0x3.0],'
            '[Padding:(0,3,0,3),child=[RichText:(:Foo)]],'
            '[SizedBox:0.0x3.0]'));
  });

  testWidgets('renders margin within another', (WidgetTester tester) async {
    final html = '<div style="margin: 1px">' +
        '<div style="margin: 2px">Foo</div></div>';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[SizedBox:0.0x2.0],'
            '[Padding:(0,3,0,3),child=[RichText:(:Foo)]],'
            '[SizedBox:0.0x2.0]'));
  });

  testWidgets('renders margins back to back', (WidgetTester tester) async {
    final html = '<div style="margin: 3px">1</div>'
        '<div style="margin: 3px">2</div>'
        '<div style="margin: 3px">3</div>';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[SizedBox:0.0x3.0],'
            '[Padding:(0,3,0,3),child=[RichText:(:1)]],'
            '[SizedBox:0.0x3.0],'
            '[Padding:(0,3,0,3),child=[RichText:(:2)]],'
            '[SizedBox:0.0x3.0],'
            '[Padding:(0,3,0,3),child=[RichText:(:3)]],'
            '[SizedBox:0.0x3.0]'));
  });

  testWidgets('renders block margins back to back', (tester) async {
    final html = '<div style="margin: 3px"><div>1a</div><div>1b</div></div>'
        '<div style="margin: 3px"><div>2a</div><div>2b</div></div>';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[SizedBox:0.0x3.0],'
            '[Padding:(0,3,0,3),child=[RichText:(:1a)]],'
            '[Padding:(0,3,0,3),child=[RichText:(:1b)]],'
            '[SizedBox:0.0x3.0],'
            '[Padding:(0,3,0,3),child=[RichText:(:2a)]],'
            '[Padding:(0,3,0,3),child=[RichText:(:2b)]],'
            '[SizedBox:0.0x3.0]'));
  });

  group('margin-xxx', () {
    testWidgets('parses margin-top', (WidgetTester tester) async {
      final html = '<div style="margin-top: 3px">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[SizedBox:0.0x3.0],[RichText:(:Foo)]'));
    });

    testWidgets('parses margin-right', (WidgetTester tester) async {
      final html = '<div style="margin-right: 3px">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[Padding:(0,3,0,0),child=[RichText:(:Foo)]]'));
    });

    testWidgets('parses margin-bottom', (WidgetTester tester) async {
      final html = '<div style="margin-bottom: 3px">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)],[SizedBox:0.0x3.0]'));
    });

    testWidgets('parses margin-left', (WidgetTester tester) async {
      final html = '<div style="margin-left: 3px">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[Padding:(0,0,0,3),child=[RichText:(:Foo)]]'));
    });

    testWidgets('overwrites margin with margin-top', (WidgetTester t) async {
      final html = '<div style="margin: 3px; margin-top: 5px">Foo</div>';
      final explained = await explain(t, html);
      expect(
          explained,
          equals('[SizedBox:0.0x5.0],'
              '[Padding:(0,3,0,3),child=[RichText:(:Foo)]],'
              '[SizedBox:0.0x3.0]'));
    });

    testWidgets('reset margin with margin-bottom', (WidgetTester t) async {
      final html = '<div style="margin: 3px; margin-bottom: 0">Foo</div>';
      final explained = await explain(t, html);
      expect(
          explained,
          equals('[SizedBox:0.0x3.0],'
              '[Padding:(0,3,0,3),child=[RichText:(:Foo)]]'));
    });
  });

  group('invalid values', () {
    testWidgets('4 values', (WidgetTester tester) async {
      final html = '<div style="margin: a b c d">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });

    testWidgets('2 values', (WidgetTester tester) async {
      final html = '<div style="margin: xxx yyy">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });

    testWidgets('1 value', (WidgetTester tester) async {
      final html = '<div style="margin: xxx">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });

    testWidgets('top', (WidgetTester tester) async {
      final html = '<div style="margin-top: xxx">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });

    testWidgets('right', (WidgetTester tester) async {
      final html = '<div style="margin-right: xxx">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });

    testWidgets('bottom', (WidgetTester tester) async {
      final html = '<div style="margin-bottom: xxx">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });

    testWidgets('left', (WidgetTester tester) async {
      final html = '<div style="margin-left: xxx">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });
  });
}
