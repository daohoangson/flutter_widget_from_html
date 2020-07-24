import 'package:flutter_test/flutter_test.dart';

import '_.dart';

void main() {
  testWidgets('renders SvgPicture for inline SVG', (tester) async {
    final html = '<svg viewBox="0 0 1 1"></svg>';
    final e = await explain(tester, html);
    final explained = e.replaceAll(RegExp(r'String#[0-9a-f]+,'), 'String,');
    expect(
        explained,
        equals('[CssBlock:child=[SvgPicture:pictureProvider='
            'StringPicture(String, colorFilter: null)]]'));
  });
}
