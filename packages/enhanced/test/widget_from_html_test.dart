import 'package:flutter_test/flutter_test.dart';

import '_.dart';

void main() {
  testWidgets('renders HR tag', (WidgetTester tester) async {
    final html = '<hr/>';
    final explained = await explain(tester, html);
    expect(explained, equals('[CssBlock:child=[Divider]]'));
  });
}
