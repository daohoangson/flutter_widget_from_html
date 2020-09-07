import 'package:flutter_test/flutter_test.dart';

import '_.dart';

void main() {
  testWidgets('renders SvgPicture for inline SVG', (tester) async {
    final html = '''<svg height="100" width="100">
  <circle cx="50" cy="50" r="40" stroke="black" stroke-width="3" fill="red" />
  Your browser does not support inline SVG.
</svg>''';
    final e = await explain(tester, html);
    final explained = e.replaceAll(RegExp(r'String#[0-9a-f]+,'), 'String,');
    expect(
        explained,
        equals('[CssBlock:child=[SvgPicture:pictureProvider='
            'StringPicture(String, colorFilter: null)]]'));
  });
}
