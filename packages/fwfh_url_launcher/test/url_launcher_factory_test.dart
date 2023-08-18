import 'package:flutter_test/flutter_test.dart';

import '_.dart';
import 'mock_url_launcher_platform.dart';

void main() {
  setUp(mockUrlLauncherPlatform);

  testWidgets('launches url', (WidgetTester tester) async {
    const href = 'http://domain.com/can-launch';
    const html = '<a href="$href">Tap me</a>';
    await explain(tester, html);

    await tester.pumpAndSettle();
    expect(await tapText(tester, 'Tap me'), equals(1));

    expect(mockLaunchedUrls, equals(const [href]));
  });

  testWidgets('handles unsupported url', (WidgetTester tester) async {
    const href = 'http://domain.com/cant-launch';
    const html = '<a href="$href">Tap me</a>';
    await explain(tester, html);

    await tester.pumpAndSettle();
    expect(await tapText(tester, 'Tap me'), equals(1));

    expect(mockLaunchedUrls, equals(const []));
  });

  testWidgets('handles invalid URI', (WidgetTester tester) async {
    const html = '<a href="://empty.scheme">Tap me</a>';
    await explain(tester, html);

    await tester.pumpAndSettle();
    expect(await tapText(tester, 'Tap me'), equals(1));

    expect(mockLaunchedUrls, equals(const []));
  });
}
