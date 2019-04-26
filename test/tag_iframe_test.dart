import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '_.dart';

void main() {
  final wf = (BuildContext context) => WidgetFactory(context, webView: true);

  testWidgets('renders clickable text', (WidgetTester tester) async {
    final html = '<iframe src="http://domain.com"></iframe>';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals('[GestureDetector:child=[Text:http://domain.com]]'),
    );
  });

  testWidgets('renders web view', (WidgetTester tester) async {
    final html = '<iframe src="http://domain.com"></iframe>';
    final explained = await explain(tester, html, wf: wf);
    expect(
        explained,
        equals('[WebView:url=http://domain.com,aspectRatio=1.78'
            ',getDimensions=true,js=true]'));
  });

  testWidgets('renders web view with specified dimensions',
      (WidgetTester tester) async {
    final html = '<iframe src="http://domain.com" ' +
        'width="400" height="300"></iframe>';
    final explained = await explain(tester, html, wf: wf);
    expect(
        explained,
        equals('[WebView:url=http://domain.com,aspectRatio=1.33'
            ',getDimensions=false,js=true]'));
  });

  group('errors', () {
    testWidgets('no src', (WidgetTester tester) async {
      final html = '<iframe></iframe>';
      final explained = await explain(tester, html, wf: wf);
      expect(explained, equals("[Text:$html]"));
    });

    testWidgets('bad src (cannot build full url)', (WidgetTester tester) async {
      final html = '<iframe src="bad"></iframe>';
      final explained = await explain(tester, html, wf: wf);
      expect(explained, equals("[Text:$html]"));
    });
  });
}
