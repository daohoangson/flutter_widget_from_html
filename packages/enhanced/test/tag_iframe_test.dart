import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '_.dart' as helper;

Future<String> explain(WidgetTester tester, String html) =>
    helper.explain(tester, html, webView: true);

void main() {
  final src = 'http://domain.com';
  final defaultAspectRatio = '1.78';

  testWidgets('renders clickable text', (tester) async {
    final html = '<iframe src="$src"></iframe>';
    final explained = await helper.explain(tester, html);
    expect(explained, equals('[GestureDetector:child=[Text:$src]]'));
  });

  testWidgets('renders web view', (tester) async {
    final html = '<iframe src="$src"></iframe>';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[WebView:'
            'url=$src,'
            'aspectRatio=$defaultAspectRatio,'
            'autoResize=true'
            ']'));
  });

  testWidgets('renders web view with specified dimensions', (tester) async {
    final html = '<iframe src="$src" width="400" height="300"></iframe>';
    final explained = await explain(tester, html);
    expect(explained, equals('[WebView:url=$src,aspectRatio=1.33]'));
  });

  group('sandbox', () {
    testWidgets('renders with js', (tester) async {
      final html = '<iframe src="$src"></iframe>';
      final e = await explain(tester, html);
      expect(e, equals('[WebView:url=$src,aspectRatio=1.78,autoResize=true]'));
    });

    testWidgets('renders without js', (tester) async {
      final html = '<iframe src="$src" sandbox></iframe>';
      final e = await explain(tester, html);
      expect(e, equals('[WebView:url=$src,aspectRatio=1.78,js=false]'));
    });

    testWidgets('renders without js (empty)', (tester) async {
      final html = '<iframe src="$src" sandbox=""></iframe>';
      final e = await explain(tester, html);
      expect(e, equals('[WebView:url=$src,aspectRatio=1.78,js=false]'));
    });

    testWidgets('renders without js (allow-forms)', (tester) async {
      final html = '<iframe src="$src" sandbox="allow-forms"></iframe>';
      final e = await explain(tester, html);
      expect(e, equals('[WebView:url=$src,aspectRatio=1.78,js=false]'));
    });

    testWidgets('renders with js (allow-scripts)', (tester) async {
      final html = '<iframe src="$src" sandbox="allow-scripts"></iframe>';
      final e = await explain(tester, html);
      expect(e, equals('[WebView:url=$src,aspectRatio=1.78,autoResize=true]'));
    });
  });

  group('errors', () {
    testWidgets('no src', (tester) async {
      final html = '<iframe></iframe>';
      final explained = await explain(tester, html);
      expect(explained, equals('[widget0]'));
    });

    testWidgets('bad src (cannot build full url)', (tester) async {
      final html = '<iframe src="bad"></iframe>';
      final explained = await explain(tester, html);
      expect(explained, equals('[widget0]'));
    });
  });
}
