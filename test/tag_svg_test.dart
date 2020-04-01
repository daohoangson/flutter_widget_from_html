import 'package:flutter_test/flutter_test.dart';

import '_.dart';

void main() {
  testWidgets('renders SvgPicture for inline SVG', (tester) async {
    final html = '<svg viewBox="0 0 1 1"></svg>';
    final explained = await explain(tester, html);
    expect(explained, equals('[SvgPicture:]'));
  });
}
