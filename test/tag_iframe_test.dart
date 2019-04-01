import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '_.dart';

void main() {
  final configWithWebView = Config(
    webView: true,
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
        equals('[Padding:(5,0,5,0),child=[AspectRatio:aspectRatio=1.78,' +
            'child=[WebView:http://domain.com]]]'));
  });

  testWidgets('renders web view with specified ratio',
      (WidgetTester tester) async {
    final html = '<iframe src="http://domain.com" ' +
        'width="400" height="300"></iframe>';
    final explained = await explain(tester, html, config: configWithWebView);
    expect(
        explained,
        equals('[Padding:(5,0,5,0),child=[AspectRatio:aspectRatio=1.33,' +
            'child=[WebView:http://domain.com]]]'));
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
