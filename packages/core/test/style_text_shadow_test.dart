import 'package:flutter_test/flutter_test.dart';

import '_.dart';

void main() {
  testWidgets('text-shadow x y blur color', (WidgetTester tester) async {
    const html = '<p style="text-shadow: 1px 1px 2px #FC0;">Anime</p>';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals(
        '[CssBlock:child=[RichText:('
        'Shadow=[color=#FFFFCC00,offset=Offset(1.0, 1.0),blurRadius=2.0]'
        ':Anime)]]',
      ),
    );
  });

  testWidgets('text-shadow color x y blur', (WidgetTester tester) async {
    const html = '<p style="text-shadow: #FC0 1px 0 10px;">Anime</p>';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals(
        '[CssBlock:child=[RichText:('
        'Shadow=[color=#FFFFCC00,offset=Offset(1.0, 0.0),blurRadius=10.0]'
        ':Anime)]]',
      ),
    );
  });

  testWidgets('text-shadow x y color', (WidgetTester tester) async {
    const html = '<p style="text-shadow: 5px 5px #558ABB;">Anime</p>';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals(
        '[CssBlock:child=[RichText:('
        'Shadow=[color=#FF558ABB,offset=Offset(5.0, 5.0),blurRadius=0.0]'
        ':Anime)]]',
      ),
    );
  });

  testWidgets('text-shadow color x y', (WidgetTester tester) async {
    const html = '<p style="text-shadow: red 2px 5px;">Anime</p>';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals(
        '[CssBlock:child=[RichText:('
        'Shadow=[color=#FFFF0000,offset=Offset(2.0, 5.0),blurRadius=0.0]'
        ':Anime)]]',
      ),
    );
  });

  testWidgets('text-shadow x y', (WidgetTester tester) async {
    const html = '<p style="text-shadow: 5px 10px;">Anime</p>';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals(
        '[CssBlock:child=[RichText:('
        'Shadow=[color=#FF001234,offset=Offset(5.0, 10.0),blurRadius=0.0]'
        ':Anime)]]',
      ),
    );
  });

  testWidgets('text-shadow multiple shadows', (WidgetTester tester) async {
    const html =
        '<p style="text-shadow: 1px 1px 2px #558ABB, 0 0 1em #FC0, 0 0 0.2em #FC0;">Anime</p>';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals(
        '[CssBlock:child=[RichText:('
        'Shadow=[color=#FF558ABB,offset=Offset(1.0, 1.0),blurRadius=2.0]'
        'Shadow=[color=#FFFFCC00,offset=Offset(0.0, 0.0),blurRadius=10.0]'
        'Shadow=[color=#FFFFCC00,offset=Offset(0.0, 0.0),blurRadius=2.0]'
        ':Anime)]]',
      ),
    );
  });

  testWidgets('text-shadow no shadow on missing offset', (tester) async {
    const html = '<p style="text-shadow: 1px #558ABB;">Anime</p>';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals('[CssBlock:child=[RichText:(:Anime)]]'),
    );
  });

  testWidgets('text-shadow no shadow on missing offset color first',
      (WidgetTester tester) async {
    const html = '<p style="text-shadow: #558ABB 2px;">Anime</p>';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals('[CssBlock:child=[RichText:(:Anime)]]'),
    );
  });

  testWidgets('text-shadow no shadow on data < 1', (WidgetTester tester) async {
    const html = '<p style="text-shadow: 5px;">Anime</p>';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals('[CssBlock:child=[RichText:(:Anime)]]'),
    );
  });

  testWidgets('text-shadow no shadow on data > 4', (WidgetTester tester) async {
    const html = '<p style="text-shadow: #558ABB 2px 5px 6px 4px;">Anime</p>';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals('[CssBlock:child=[RichText:(:Anime)]]'),
    );
  });

  testWidgets('text-shadow no shadow only has color', (tester) async {
    const html = '<p style="text-shadow: #558ABB;">Anime</p>';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals('[CssBlock:child=[RichText:(:Anime)]]'),
    );
  });
}
