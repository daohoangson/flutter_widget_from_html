import 'package:flutter_test/flutter_test.dart';

import '_.dart';

void main() {
  final sizingConstraints = 'height≥0.0,height=auto,width≥0.0,width=auto';
  final src = 'http://domain.com/transparent.gif';

  testWidgets('renders CachedNetworkImage', (WidgetTester tester) async {
    final html = '<img src="$src" />';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals('[CssSizing:$sizingConstraints,child='
          '[CachedNetworkImage:imageUrl=$src]'
          ']'),
    );
  });

  testWidgets('renders Image for data uri', (WidgetTester tester) async {
    final html = '<img src="$kDataUri" />';
    final explained = (await explain(tester, html))
        .replaceAll(RegExp(r'Uint8List#[0-9a-f]+,'), 'bytes,');
    expect(
        explained,
        equals('[CssSizing:$sizingConstraints,child='
            '[Image:image=MemoryImage(bytes, scale: 1.0)]'
            ']'));
  });

  testWidgets('renders progress indicator', (WidgetTester tester) async {
    final html = '<img src="${src}yolo" />';
    final explained = await explain(
      tester,
      html,
      useExplainer: false,
    );
    expect(explained, contains('CircularProgressIndicator'));
  });

  testWidgets('renders raw image', (WidgetTester tester) async {
    final html = '<img src="$src" />';
    final explained = await explain(tester, html, useExplainer: false);
    expect(explained, contains('RawImage'));
  });

  testWidgets('handles error', (WidgetTester tester) async {
    final html = '<img src="http://domain.com/error.jpg" />';
    final explained = await explain(tester, html, useExplainer: false);
    expect(explained, contains('Text("❌")'));
  });
}
