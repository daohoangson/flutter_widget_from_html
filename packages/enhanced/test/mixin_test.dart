import 'package:flutter_test/flutter_test.dart';

import '_.dart';

void main() {
  testWidgets('renders AUDIO tag', (tester) async {
    final src = 'http://domain.com/audio.mp3';
    final html = '<audio src="$src"></audio>';
    final explained = await explain(tester, html);
    expect(explained, equals('[AudioPlayer:url=$src]'));
  });

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

  testWidgets('renders IMG tag with .svg', (WidgetTester tester) async {
    final sizingConstraints = 'height≥0.0,height=auto,width≥0.0,width=auto';
    final assetName = 'test/images/logo.svg';
    final package = 'fwfh_svg';
    final html = '<img src="asset:$assetName?package=$package" />';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals('[CssSizing:$sizingConstraints,child='
          '[SvgPicture:'
          'pictureProvider=ExactAssetPicture(name: "packages/$package/$assetName", bundle: null, colorFilter: null)'
          ']]'),
    );
  });

  testWidgets('renders VIDEO tag', (tester) async {
    final src = 'http://domain.com/video.mp4';
    final html = '<video><source src="$src"></video>';
    final explained = await explain(tester, html);
    expect(explained, equals('[VideoPlayer:url=$src,aspectRatio=1.78]'));
  });
}
