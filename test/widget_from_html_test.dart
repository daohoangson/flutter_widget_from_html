import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../packages/core/test/_.dart' as _coreTesting;

Future<String> explain(WidgetTester tester, String html,
        {Config config}) async =>
    _coreTesting.explain(
      tester,
      null,
      hw: HtmlWidget(
        html,
        config: config ?? const Config(),
      ),
    );

void main() {
  testWidgets('renders text with padding', (WidgetTester tester) async {
    final html = 'Hello world';
    final explained = await explain(tester, html);
    expect(explained, equals('[Padding:(5,10,5,10),child=[Text:Hello world]]'));
  });

  testWidgets('renders rich text with padding', (WidgetTester tester) async {
    final html = 'Hi <b>there</b>!';
    final explained = await explain(tester, html);
    expect(explained,
        equals('[Padding:(5,10,5,10),child=[RichText:(:Hi (+b:there)(:!))]]'));
  });

  group('A tag', () {
    testWidgets('renders stylings and on tap', (WidgetTester tester) async {
      final html = 'This is a <a href="http://domain.com/href">hyperlink</a>.';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[Padding:(5,10,5,10),child=' +
              '[RichText:(:This is a (#FF0000FF+u+onTap:hyperlink)(:.))]]'));
    });

    testWidgets('renders inner stylings', (WidgetTester tester) async {
      final html = 'This is a <a href="http://domain.com/href">' +
          '<b><i>hyperlink</i></b></a>.';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[Padding:(5,10,5,10),child=' +
              '[RichText:(:This is a (#FF0000FF+u+i+b+onTap:hyperlink)(:.))]]'));
    });

    testWidgets('renders IMG tag inside', (WidgetTester tester) async {
      final html = '<a href="http://domain.com/href">' +
          '<img src="http://domain.com/image.png" /></a>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[GestureDetector:child=[Stack:children=' +
              '[Padding:(10,0,0,0),child=[CachedNetworkImage:]],' +
              '[Positioned:child=[Padding:(10,10,10,10),child=[Icon:]]]]]'));
    });
  });

  testWidgets('renders IMG tag', (WidgetTester tester) async {
    final html = '<img src="http://domain.com/image.png" />';
    final explained = await explain(tester, html);
    expect(
        explained, equals('[Padding:(10,0,0,0),child=[CachedNetworkImage:]]'));
  });

  group('lists', () {
    final noTextPaddingConfig = Config(textPadding: null);

    testWidgets('renders ordered list', (WidgetTester tester) async {
      final html = '<ol><li>One</li><li>Two</li><li><b>Three</b></li><ol>';
      final explained =
          await explain(tester, html, config: noTextPaddingConfig);
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
      final explained =
          await explain(tester, html, config: noTextPaddingConfig);
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
      final explained =
          await explain(tester, html, config: noTextPaddingConfig);
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
  });
}
