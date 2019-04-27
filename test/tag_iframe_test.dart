import 'package:flutter_test/flutter_test.dart';

import '_.dart' as _;

Future<String> explain(WidgetTester tester, String html) =>
    _.explain(tester, html, webView: true);

void main() {
  testWidgets('renders clickable text', (WidgetTester tester) async {
    final html = '<iframe src="http://domain.com"></iframe>';
    final explained = await _.explain(tester, html);
    expect(
      explained,
      equals('[GestureDetector:child=[Text:http://domain.com]]'),
    );
  });

  testWidgets('renders web view', (WidgetTester tester) async {
    final html = '<iframe src="http://domain.com"></iframe>';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[WebView:url=http://domain.com,aspectRatio=1.78'
            ',getDimensions=true,js=true]'));
  });

  testWidgets('renders web view with specified dimensions',
      (WidgetTester tester) async {
    final html = '<iframe src="http://domain.com" ' +
        'width="400" height="300"></iframe>';
    final explained = await explain(tester, html);
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
