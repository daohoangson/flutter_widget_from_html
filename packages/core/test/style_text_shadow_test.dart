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

  testWidgets('text-shadow red x y', (WidgetTester tester) async {
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

  testWidgets('text-shadow x y color', (WidgetTester tester) async {
    const html = '<p style="text-shadow: 1px 1px 2px #558ABB;">Anime</p>';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals(
        '[CssBlock:child=[RichText:('
        'Shadow=[color=#FF558ABB,offset=Offset(1.0, 1.0),blurRadius=2.0]'
        ':Anime)]]',
      ),
    );
  });
}
