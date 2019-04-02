import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '_.dart';

void main() {
  final configWithWebView = Config(
    webView: true,
    webViewPadding: const EdgeInsets.all(0),
  );

  testWidgets('renders clickable text', (WidgetTester tester) async {
    final html = '<iframe src="http://domain.com"></iframe>';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[GestureDetector:child=[Padding:(5,10,5,10),' +
            'child=[Text:http://domain.com]]]'));
  });

  testWidgets('renders web view', (WidgetTester tester) async {
    final html = '<iframe src="http://domain.com"></iframe>';
    final explained = await explain(tester, html, config: configWithWebView);
    expect(
      explained,
      equals('[WebView:url=http://domain.com,height=null,js=true,width=null]'),
    );
  });

  testWidgets('renders web view with specified dimensions',
      (WidgetTester tester) async {
    final html = '<iframe src="http://domain.com" ' +
        'width="400" height="300"></iframe>';
    final explained = await explain(tester, html, config: configWithWebView);
    expect(
      explained,
      equals('[WebView:url=http://domain.com,height=300.0,' +
          'js=true,width=400.0]'),
    );
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
