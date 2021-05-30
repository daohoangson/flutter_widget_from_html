import 'package:flutter_test/flutter_test.dart';

import '_.dart';

void main() {
  setUp(mockSetup);
  tearDown(mockTearDown);

  testWidgets('launches url', (WidgetTester tester) async {
    const href = 'http://flutter.dev';
    final html = '<a href="$href">Tap me</a>';
    await explain(tester, html);

    await tester.pumpAndSettle();
    expect(await tapText(tester, 'Tap me'), equals(1));

    expect(mockGetLaunchUrls(), equals(const [href]));
  });
}
