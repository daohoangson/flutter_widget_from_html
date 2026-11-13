import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:flutter_widget_from_html_core/src/internal/declarations_cache.dart';
import 'package:html/dom.dart' as dom;

import '../../_.dart' as helper;

void main() {
  group('parseDeclarations', () {
    test('parses declarations', () {
      final declarations = parseDeclarations('color: red; font-size: 1em');
      expect(
          declarations.map((d) => d.property), equals(['color', 'font-size']));
    });

    test('returns the same list for the same string', () {
      final first = parseDeclarations('color: #2828AC');
      final second = parseDeclarations('color: #2828AC');
      expect(identical(first, second), isTrue);
    });

    test('returns an unmodifiable list', () {
      final declarations = parseDeclarations('color: blue');
      expect(() => declarations.clear(), throwsUnsupportedError);
    });

    test('evicts the least recently used entry', () {
      final first = parseDeclarations('margin: 1px');
      for (var i = 0; i < 1000; i++) {
        parseDeclarations('margin: ${i + 2}px');
      }
      expect(identical(parseDeclarations('margin: 1px'), first), isFalse);
    });

    test('keeps recently used entries', () {
      final first = parseDeclarations('padding: 1px');
      for (var i = 0; i < 1000; i++) {
        parseDeclarations('padding: ${i + 2}px');
        expect(identical(parseDeclarations('padding: 1px'), first), isTrue);
      }
    });
  });

  group('DomElementExtension.styles', () {
    test('shares declarations between elements', () {
      final a = dom.Element.tag('a')..attributes['style'] = 'color: red';
      final b = dom.Element.tag('b')..attributes['style'] = 'color: red';
      expect(identical(a.styles, b.styles), isTrue);
    });

    test('returns empty list without style attribute', () {
      expect(dom.Element.tag('a').styles, isEmpty);
    });
  });

  group('rendering', () {
    testWidgets('same inline style on different elements', (tester) async {
      const html = '<span style="color: #F00">a</span> '
          '<b style="color: #F00">b</b> '
          '<span style="color: #F00">c</span>';
      final explained = await helper.explain(tester, html);
      expect(
        explained,
        equals(
          '[RichText:(:(#FFFF0000:a)(: )(#FFFF0000+b:b)(: )(#FFFF0000:c))]',
        ),
      );
    });

    testWidgets('same custom styles on different elements', (tester) async {
      const html = '<span class="x">a</span> <a class="x">b</a> <b>c</b>';
      final explained = await helper.explain(
        tester,
        null,
        hw: HtmlWidget(
          html,
          key: helper.hwKey,
          customStylesBuilder: (element) =>
              element.classes.contains('x') ? const {'color': '#00F'} : null,
        ),
      );
      expect(
        explained,
        equals(
          '[RichText:(:(#FF0000FF:a)(: )(#FF0000FF:b)(: )(+b:c))]',
        ),
      );
    });

    testWidgets('renders again after rebuild', (tester) async {
      const html = '<p style="color: #0F0">a</p><p style="color: #0F0">b</p>';
      const expected = '[Column:children='
          '[CssBlock:child=[RichText:(#FF00FF00:a)]],'
          '[SizedBox:0.0x10.0],'
          '[CssBlock:child=[RichText:(#FF00FF00:b)]]]';
      expect(await helper.explain(tester, html), equals(expected));
      await tester.pumpWidget(const SizedBox.shrink());
      expect(await helper.explain(tester, html), equals(expected));
    });
  });
}
