import 'package:flutter_test/flutter_test.dart';

import '_.dart';

void main() {
  final padding = 'Padding:(0,0,0,40)';

  testWidgets('renders list with padding', (WidgetTester tester) async {
    final html = '<ul><li>Foo</li></ul>';
    final explained = await explainMargin(tester, html);
    expect(
        explained,
        equals('[Padding:(10,0,10,0),child='
            '[Stack:children=[Padding:(0,0,0,40),child=[RichText:(:Foo)]],'
            '[Positioned:child=[RichText,align=right:(:•)]]]]'));
  });

  testWidgets('renders ordered list', (WidgetTester tester) async {
    final html = '<ol><li>One</li><li>Two</li><li><b>Three</b></li><ol>';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[Column:children='
            '[Stack:children=[$padding,child=[RichText:(:One)]],[Positioned:child=[RichText,align=right:(:1.)]]],'
            '[Stack:children=[$padding,child=[RichText:(:Two)]],[Positioned:child=[RichText,align=right:(:2.)]]],'
            '[Stack:children=[$padding,child=[RichText:(+b:Three)]],[Positioned:child=[RichText,align=right:(:3.)]]]'
            ']'));
  });

  testWidgets('renders unordered list', (WidgetTester tester) async {
    final html = '<ul><li>One</li><li>Two</li><li><em>Three</em></li><ul>';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[Column:children='
            '[Stack:children=[$padding,child=[RichText:(:One)]],[Positioned:child=[RichText,align=right:(:•)]]],'
            '[Stack:children=[$padding,child=[RichText:(:Two)]],[Positioned:child=[RichText,align=right:(:•)]]],'
            '[Stack:children=[$padding,child=[RichText:(+i:Three)]],[Positioned:child=[RichText,align=right:(:•)]]]'
            ']'));
  });

  testWidgets('renders nested list', (WidgetTester tester) async {
    final html = '<ol><li>One</li><li>Two</li><li>Three '
        '<ul><li>3.1</li><li>3.2</li></ul></li><li>Four</li><ol>';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[Column:children='
            '[Stack:children=[$padding,child=[RichText:(:One)]],[Positioned:child=[RichText,align=right:(:1.)]]],'
            '[Stack:children=[$padding,child=[RichText:(:Two)]],[Positioned:child=[RichText,align=right:(:2.)]]],'
            '[Stack:children=[$padding,child=[Column:children=[RichText:(:Three)],'
            '[Stack:children=[$padding,child=[RichText:(:3.1)]],[Positioned:child=[RichText,align=right:(:⚬)]]],'
            '[Stack:children=[$padding,child=[RichText:(:3.2)]],[Positioned:child=[RichText,align=right:(:⚬)]]]'
            ']],[Positioned:child=[RichText,align=right:(:3.)]]],'
            '[Stack:children=[$padding,child=[RichText:(:Four)]],[Positioned:child=[RichText,align=right:(:4.)]]]]'));
  });
}
