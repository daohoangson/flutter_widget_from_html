import 'package:flutter_test/flutter_test.dart';

import '_.dart';

void main() {
  final explain = explainMargin;

  testWidgets('renders text without margin', (WidgetTester tester) async {
    final html = '<div>Foo</div>';
    final explained = await explain(tester, html);
    expect(explained, equals('[Text:Foo]'));
  });

  group('4 values', () {
    testWidgets('parses all', (WidgetTester tester) async {
      final html = '<div style="margin: 1px 2px 3px 4px">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[Padding:(1,2,3,4),child=[Text:Foo]]'));
    });

    testWidgets('parses top only', (WidgetTester tester) async {
      final html = '<div style="margin: 1px 0 0 0">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[Padding:(1,0,0,0),child=[Text:Foo]]'));
    });

    testWidgets('parses right only', (WidgetTester tester) async {
      final html = '<div style="margin: 0 2px 0 0">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[Padding:(0,2,0,0),child=[Text:Foo]]'));
    });

    testWidgets('parses bottom only', (WidgetTester tester) async {
      final html = '<div style="margin: 0 0 3px 0">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[Padding:(0,0,3,0),child=[Text:Foo]]'));
    });

    testWidgets('parses left only', (WidgetTester tester) async {
      final html = '<div style="margin: 0 0 0 4px">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[Padding:(0,0,0,4),child=[Text:Foo]]'));
    });
  });

  group('2 values', () {
    testWidgets('parses both', (WidgetTester tester) async {
      final html = '<div style="margin: 5px 10px">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[Padding:(5,10,5,10),child=[Text:Foo]]'));
    });

    testWidgets('parses vertical only', (WidgetTester tester) async {
      final html = '<div style="margin: 5px 0">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[Padding:(5,0,5,0),child=[Text:Foo]]'));
    });

    testWidgets('parses horizontal only', (WidgetTester tester) async {
      final html = '<div style="margin: 0 10px">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[Padding:(0,10,0,10),child=[Text:Foo]]'));
    });
  });

  testWidgets('parses margin with 1 value', (WidgetTester tester) async {
    final html = '<div style="margin: 3px">Foo</div>';
    final explained = await explain(tester, html);
    expect(explained, equals('[Padding:(3,3,3,3),child=[Text:Foo]]'));
  });

  testWidgets('renders margin within another', (WidgetTester tester) async {
    final html = '<div style="margin: 1px">' +
        '<div style="margin: 2px">Foo</div></div>';
    final explained = await explain(tester, html);
    expect(explained, equals('[Padding:(2,3,2,3),child=[Text:Foo]]'));
  });

  group('margin-xxx', () {
    testWidgets('parses margin-top', (WidgetTester tester) async {
      final html = '<div style="margin-top: 3px">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[Padding:(3,0,0,0),child=[Text:Foo]]'));
    });

    testWidgets('parses margin-right', (WidgetTester tester) async {
      final html = '<div style="margin-right: 3px">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[Padding:(0,3,0,0),child=[Text:Foo]]'));
    });

    testWidgets('parses margin-bottom', (WidgetTester tester) async {
      final html = '<div style="margin-bottom: 3px">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[Padding:(0,0,3,0),child=[Text:Foo]]'));
    });

    testWidgets('parses margin-left', (WidgetTester tester) async {
      final html = '<div style="margin-left: 3px">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[Padding:(0,0,0,3),child=[Text:Foo]]'));
    });

    testWidgets('overwrites margin with margin-top', (WidgetTester t) async {
      final html = '<div style="margin: 3px; margin-top: 5px">Foo</div>';
      final explained = await explain(t, html);
      expect(explained, equals('[Padding:(5,3,3,3),child=[Text:Foo]]'));
    });

    testWidgets('reset margin with margin-bottom', (WidgetTester t) async {
      final html = '<div style="margin: 3px; margin-bottom: 0">Foo</div>';
      final explained = await explain(t, html);
      expect(explained, equals('[Padding:(3,3,0,3),child=[Text:Foo]]'));
    });
  });

  group('invalid values', () {
    testWidgets('4 values', (WidgetTester tester) async {
      final html = '<div style="margin: a b c d">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[Text:Foo]'));
    });

    testWidgets('2 values', (WidgetTester tester) async {
      final html = '<div style="margin: xxx yyy">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[Text:Foo]'));
    });

    testWidgets('1 value', (WidgetTester tester) async {
      final html = '<div style="margin: xxx">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[Text:Foo]'));
    });

    testWidgets('top', (WidgetTester tester) async {
      final html = '<div style="margin-top: xxx">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[Text:Foo]'));
    });

    testWidgets('right', (WidgetTester tester) async {
      final html = '<div style="margin-right: xxx">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[Text:Foo]'));
    });

    testWidgets('bottom', (WidgetTester tester) async {
      final html = '<div style="margin-bottom: xxx">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[Text:Foo]'));
    });

    testWidgets('left', (WidgetTester tester) async {
      final html = '<div style="margin-left: xxx">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[Text:Foo]'));
    });
  });
}
