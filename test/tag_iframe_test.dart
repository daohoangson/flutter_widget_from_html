import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '_.dart';

void main() {
  testWidgets('renders clickable text', (WidgetTester tester) async {
    final html = '<iframe src="http://domain.com"></iframe>';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[GestureDetector:child=[Padding:(0,10,0,10),' +
            'child=[Text:http://domain.com]]]'));
  });

  testWidgets('renders web view with padding', (WidgetTester tester) async {
    final html = 'x<iframe src="http://domain.com"></iframe>x';
    final explained = await explain(
      tester,
      html,
      config: Config(bodyPadding: null, webView: true),
    );
    expect(
        explained,
        equals('[Column:children=[Padding:(0,10,0,10),child=[Text:x]],'
            '[Padding:(5,0,5,0),child=[WebView:url=http://domain.com,aspectRatio=1.78,getDimensions=true,js=true]]'
            ',[Padding:(0,10,0,10),child=[Text:x]]]'));
  });

  testWidgets('renders web view with specified dimensions',
      (WidgetTester tester) async {
    final html = '<iframe src="http://domain.com" ' +
        'width="400" height="300"></iframe>';
    final explained = await explain(
      tester,
      html,
      config: Config(bodyPadding: null, webView: true, webViewPadding: null),
    );
    expect(
        explained,
        equals('[WebView:url=http://domain.com,aspectRatio=1.33'
            ',getDimensions=false,js=true]'));
  });

  group('errors', () {
    testWidgets('no src', (WidgetTester tester) async {
      final html = '<iframe></iframe>';
      final explained = await explain(tester, html);
      expect(explained, equals("[Text:$html]"));
    });

    testWidgets('bad src (cannot build full url)', (WidgetTester tester) async {
      final html = '<iframe src="bad"></iframe>';
      final explained = await explain(tester, html);
      expect(explained, equals("[Text:$html]"));
    });
  });
}
