import 'package:flutter_test/flutter_test.dart';

import '_.dart';

void main() {
  testWidgets('renders AUDIO tag', (tester) async {
    const src = 'http://domain.com/audio.mp3';
    const html = '<audio src="$src"></audio>';
    final explained = await explain(tester, html);
    expect(explained, equals('[AudioPlayer:url=$src]'));
  });

  testWidgets('renders SVG tag', (tester) async {
    const html = '''
<svg height="100" width="100">
  <circle cx="50" cy="50" r="40" stroke="black" stroke-width="3" fill="red" />
  SVG support is not enabled.
</svg>''';
    final e = await explain(tester, html);
    final explained = e.replaceAll(RegExp('String#[0-9a-f]+,'), 'String,');
    expect(
      explained,
      equals(
        '[SvgPicture:pictureProvider='
        'StringPicture(String, colorFilter: null)]',
      ),
    );
  });

  testWidgets('renders IMG tag with .svg', (WidgetTester tester) async {
    const sizingConstraints = 'height≥0.0,height=auto,width≥0.0,width=auto';
    const assetName = 'test/images/logo.svg';
    const html = '<img src="asset:$assetName" />';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals(
        '[CssSizing:$sizingConstraints,child='
        '[SvgPicture:'
        'pictureProvider=ExactAssetPicture(name: "$assetName", '
        'bundle: null, colorFilter: null)'
        ']]',
      ),
    );
  });

  testWidgets('renders VIDEO tag', (tester) async {
    const src = 'http://domain.com/video.mp4';
    const html = '<video><source src="$src"></video>';
    final explained = await explain(tester, html);
    expect(explained, equals('[VideoPlayer:url=$src,aspectRatio=1.78]'));
  });
}
