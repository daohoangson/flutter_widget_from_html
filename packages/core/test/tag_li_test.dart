import 'package:flutter_test/flutter_test.dart';

import '_.dart';

void main() {
  final padding = 'Padding:(0,0,0,25)';

  testWidgets('renders list with padding', (WidgetTester tester) async {
    final html = '<ul><li>Foo</li></ul>';
    final explained = await explainMargin(tester, html);
    expect(
        explained,
        equals('[SizedBox:0.0x10.0],'
            '[Stack:children=[$padding,child=[RichText:(:Foo)]],'
            '[Positioned:child=[RichText,align=right:(:•)]]],'
            '[SizedBox:0.0x10.0]'));
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
    final html = """
<ul>
  <li>One</li>
  <li>
    Two
    <ul>
      <li>2.1</li>
      <li>
        2.2
        <ul>
          <li>2.2.1</li>
          <li>2.2.2</li>
        </ul>
      </li>
      <li>2.3</li>
    </ul>
  </li>
  <li>Three</li>
</ul>""";
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[Column:children='
            '[Stack:children=[$padding,child=[RichText:(:One)]],[Positioned:child=[RichText,align=right:(:•)]]],'
            '[Stack:children=[$padding,child='
            '[Column:children=[RichText:(:Two)],'
            '[Stack:children=[$padding,child=[RichText:(:2.1)]],[Positioned:child=[RichText,align=right:(:-)]]],'
            '[Stack:children=[$padding,child='
            '[Column:children=[RichText:(:2.2)],'
            '[Stack:children=[$padding,child=[RichText:(:2.2.1)]],[Positioned:child=[RichText,align=right:(:+)]]],'
            '[Stack:children=[$padding,child=[RichText:(:2.2.2)]],[Positioned:child=[RichText,align=right:(:+)]]]'
            ']],[Positioned:child=[RichText,align=right:(:-)]]],'
            '[Stack:children=[$padding,child=[RichText:(:2.3)]],[Positioned:child=[RichText,align=right:(:-)]]]'
            ']],[Positioned:child=[RichText,align=right:(:•)]]],'
            '[Stack:children=[$padding,child=[RichText:(:Three)]],[Positioned:child=[RichText,align=right:(:•)]]]'
            ']'));
  });
}
