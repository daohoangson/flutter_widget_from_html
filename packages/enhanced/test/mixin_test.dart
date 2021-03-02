import 'package:flutter_test/flutter_test.dart';

import '_.dart';

void main() {
  testWidgets('renders SVG tag', (tester) async {
    final html = '''<svg height="100" width="100">
  <circle cx="50" cy="50" r="40" stroke="black" stroke-width="3" fill="red" />
  Your browser does not support inline SVG.
</svg>''';
    final e = await explain(tester, html);
    final explained = e.replaceAll(RegExp(r'String#[0-9a-f]+,'), 'String,');
    expect(
        explained,
        equals('[SvgPicture:pictureProvider='
            'StringPicture(String, colorFilter: null)]'));
  });

  testWidgets('renders VIDEO tag', (tester) async {
    final src = 'http://domain.com/video.mp4';
    final html = '<video><source src="$src"></video>';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals('[VideoPlayer:url=http://domain.com/video.mp4,aspectRatio=1.78]'),
    );
  });
}
