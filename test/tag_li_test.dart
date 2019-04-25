import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '_.dart';

void main() {
  final config = Config(
    bodyPadding: null,
    textPadding: null,
  );

  testWidgets('renders ordered list', (WidgetTester tester) async {
    final html = '<ol><li>One</li><li>Two</li><li><b>Three</b></li><ol>';
    final explained = await explain(tester, html, config: config);
    expect(
        explained,
        equals('[Column:children=' +
            '[Stack:children=[Padding:(0,0,0,30),child=[Text:One]],[Positioned:child=[Text,align=right:1.]]],' +
            '[Stack:children=[Padding:(0,0,0,30),child=[Text:Two]],[Positioned:child=[Text,align=right:2.]]],' +
            '[Stack:children=[Padding:(0,0,0,30),child=[RichText:(+b:Three)]],[Positioned:child=[Text,align=right:3.]]]' +
            ']'));
  });

  testWidgets('renders unordered list', (WidgetTester tester) async {
    final html = '<ul><li>One</li><li>Two</li><li><em>Three</em></li><ul>';
    final explained = await explain(tester, html, config: config);
    expect(
        explained,
        equals('[Column:children=' +
            '[Stack:children=[Padding:(0,0,0,30),child=[Text:One]],[Positioned:child=[Text,align=right:•]]],' +
            '[Stack:children=[Padding:(0,0,0,30),child=[Text:Two]],[Positioned:child=[Text,align=right:•]]],' +
            '[Stack:children=[Padding:(0,0,0,30),child=[RichText:(+i:Three)]],[Positioned:child=[Text,align=right:•]]]' +
            ']'));
  });

  testWidgets('renders nested list', (WidgetTester tester) async {
    final html = '<ol><li>One</li><li>Two</li><li>Three ' +
        '<ul><li>3.1</li><li>3.2</li></ul></li><li>Four</li><ol>';
    final explained = await explain(tester, html, config: config);
    expect(
        explained,
        equals('[Column:children=' +
            '[Stack:children=[Padding:(0,0,0,30),child=[Text:One]],[Positioned:child=[Text,align=right:1.]]],' +
            '[Stack:children=[Padding:(0,0,0,30),child=[Text:Two]],[Positioned:child=[Text,align=right:2.]]],' +
            '[Stack:children=[Padding:(0,0,0,30),child=[Column:children=[Text:Three],' +
            '[Column:children=' +
            '[Stack:children=[Padding:(0,0,0,30),child=[Text:3.1]],[Positioned:child=[Text,align=right:•]]],' +
            '[Stack:children=[Padding:(0,0,0,30),child=[Text:3.2]],[Positioned:child=[Text,align=right:•]]]' +
            ']]],[Positioned:child=[Text,align=right:3.]]],' +
            '[Stack:children=[Padding:(0,0,0,30),child=[Text:Four]],[Positioned:child=[Text,align=right:4.]]]]'));
  });
}
