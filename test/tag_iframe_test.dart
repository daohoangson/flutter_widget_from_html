import 'package:flutter_test/flutter_test.dart';

import '_.dart' as helper;

Future<String> explain(WidgetTester tester, String html) =>
    helper.explain(tester, html, webView: true);

void main() {
  final src = 'http://domain.com';

  testWidgets('renders clickable text', (tester) async {
    final html = '<iframe src="$src"></iframe>';
    final explained = await helper.explain(tester, html);
    expect(explained, equals("[GestureDetector:child=[Text:$src]]"));
  });

  testWidgets('renders web view', (tester) async {
    final html = '<iframe src="$src"></iframe>';
    final explained = await explain(tester, html);
    expect(explained,
        equals('[WebView:url=$src,aspectRatio=1.78,getDimensions=1,js=1]'));
  });

  testWidgets('renders web view with specified dimensions', (tester) async {
    final html = '<iframe src="$src" width="400" height="300"></iframe>';
    final explained = await explain(tester, html);
    expect(explained,
        equals("[WebView:url=$src,aspectRatio=1.33,getDimensions=0,js=1]"));
  });

  group('errors', () {
    testWidgets('no src', (tester) async {
      final html = '<iframe></iframe>';
      final explained = await explain(tester, html);
      expect(explained, equals("[widget0]"));
    });

    testWidgets('bad src (cannot build full url)', (tester) async {
      final html = '<iframe src="bad"></iframe>';
      final explained = await explain(tester, html);
      expect(explained, equals("[widget0]"));
    });
  });
}
