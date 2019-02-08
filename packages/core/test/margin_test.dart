import 'package:flutter_test/flutter_test.dart';

import '_.dart';

void main() {
  testWidgets('renders text without margin', (WidgetTester tester) async {
    final html = 'Foo';
    final explained = await explain(tester, html);
    expect(explained, equals('[Text:Foo]'));
  });

  testWidgets('parses margin with 4 values', (WidgetTester tester) async {
    final html = '<div style="margin: 1px 2px 3px 4px">Foo</div>';
    final explained = await explain(tester, html);
    expect(explained, equals('[Padding:(1,2,3,4),child=[Text:Foo]]'));
  });

  testWidgets('parses margin with 2 values', (WidgetTester tester) async {
    final html = '<div style="margin: 5px 10px">Foo</div>';
    final explained = await explain(tester, html);
    expect(explained, equals('[Padding:(5,10,5,10),child=[Text:Foo]]'));
  });

  testWidgets('parses margin with 1 value', (WidgetTester tester) async {
    final html = '<div style="margin: 3px">Foo</div>';
    final explained = await explain(tester, html);
    expect(explained, equals('[Padding:(3,3,3,3),child=[Text:Foo]]'));
  });

  testWidgets('renders margin within another', (WidgetTester tester) async {
    final html = '<div style="margin: 1px"><div style="margin: 2px">Foo</div></div>';
    final explained = await explain(tester, html);
    expect(explained, equals('[Padding:(1,1,1,1),child=[Padding:(2,2,2,2),child=[Text:Foo]]]'));
  });

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
}
