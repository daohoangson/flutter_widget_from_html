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
<svg height="100px" width="100px">
  <circle cx="50" cy="50" r="40" stroke="black" stroke-width="3" fill="red" />
  SVG support is not enabled.
</svg>''';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals(
        '[CssSizing:height≥0.0,height=100.0,width≥0.0,width=100.0,child='
        '[SvgPicture:bytesLoader=SvgStringLoader]'
        ']',
      ),
    );
  });

  testWidgets('renders IMG tag with .svg', (WidgetTester tester) async {
    const sizingConstraints = 'height≥0.0,height=auto,width≥0.0,width=auto';
    const assetName = 'test/images/icon.svg';
    const html = '<img src="asset:$assetName" />';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals(
        '[CssSizing:$sizingConstraints,child='
        '[SvgPicture:'
        'bytesLoader=SvgAssetLoader(assetName: $assetName, packageName: null)'
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
