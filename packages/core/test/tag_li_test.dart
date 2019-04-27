import 'package:flutter_test/flutter_test.dart';

import '_.dart';

void main() {
  final padding = 'Padding:(0,0,0,40)';

  testWidgets('renders list with padding', (WidgetTester tester) async {
    final html = 'x<ul><li>Foo</li></ul>x';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[Column:children=[Text:x],'
            '[Padding:(10,0,10,0),child='
            '[Stack:children=[Padding:(0,0,0,40),child=[Text:Foo]],[Positioned:child=[Text,align=right:•]]]'
            '],[Text:x]]'));
  });

  testWidgets('renders ordered list', (WidgetTester tester) async {
    final html = '<ol><li>One</li><li>Two</li><li><b>Three</b></li><ol>';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[Column:children='
            '[Stack:children=[$padding,child=[Text:One]],[Positioned:child=[Text,align=right:1.]]],'
            '[Stack:children=[$padding,child=[Text:Two]],[Positioned:child=[Text,align=right:2.]]],'
            '[Stack:children=[$padding,child=[RichText:(+b:Three)]],[Positioned:child=[Text,align=right:3.]]]'
            ']'));
  });

  testWidgets('renders unordered list', (WidgetTester tester) async {
    final html = '<ul><li>One</li><li>Two</li><li><em>Three</em></li><ul>';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[Column:children='
            '[Stack:children=[$padding,child=[Text:One]],[Positioned:child=[Text,align=right:•]]],'
            '[Stack:children=[$padding,child=[Text:Two]],[Positioned:child=[Text,align=right:•]]],'
            '[Stack:children=[$padding,child=[RichText:(+i:Three)]],[Positioned:child=[Text,align=right:•]]]'
            ']'));
  });

  testWidgets('renders nested list', (WidgetTester tester) async {
    final html = '<ol><li>One</li><li>Two</li><li>Three '
        '<ul><li>3.1</li><li>3.2</li></ul></li><li>Four</li><ol>';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[Column:children='
            '[Stack:children=[$padding,child=[Text:One]],[Positioned:child=[Text,align=right:1.]]],'
            '[Stack:children=[$padding,child=[Text:Two]],[Positioned:child=[Text,align=right:2.]]],'
            '[Stack:children=[$padding,child=[Column:children=[Text:Three],'
            '[Column:children='
            '[Stack:children=[$padding,child=[Text:3.1]],[Positioned:child=[Text,align=right:•]]],'
            '[Stack:children=[$padding,child=[Text:3.2]],[Positioned:child=[Text,align=right:•]]]'
            ']]],[Positioned:child=[Text,align=right:3.]]],'
            '[Stack:children=[$padding,child=[Text:Four]],[Positioned:child=[Text,align=right:4.]]]]'));
  });
}
