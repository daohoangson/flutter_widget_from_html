import 'package:flutter_test/flutter_test.dart';

import '_.dart';

void main() {
  testWidgets('renders SUB tag', (WidgetTester tester) async {
    final html = '<sub>Foo</sub>';
    final explained = await explain(tester, html);
    expect(explained,
        equals('[RichText:[Transform:child=[RichText:(@6.9:Foo)]]@bottom]'));
  });

  testWidgets('renders SUP tag', (WidgetTester tester) async {
    final html = '<sup>Foo</sup>';
    final e = await explain(tester, html);
    expect(e, equals('[RichText:[Transform:child=[RichText:(@6.9:Foo)]]@top]'));
  });

  testWidgets('renders top text', (WidgetTester tester) async {
    final html = '<span style="vertical-align: top">Foo</span>';
    final explained = await explain(tester, html);
    expect(explained, equals('[RichText:[RichText:(:Foo)]@top]'));
  });

  testWidgets('renders bottom text', (WidgetTester tester) async {
    final html = '<span style="vertical-align: bottom">Foo</span>';
    final explained = await explain(tester, html);
    expect(explained, equals('[RichText:[RichText:(:Foo)]@bottom]'));
  });

  testWidgets('renders middle text', (WidgetTester tester) async {
    final html = '<span style="vertical-align: middle">Foo</span>';
    final explained = await explain(tester, html);
    expect(explained, equals('[RichText:[RichText:(:Foo)]@middle]'));
  });
  testWidgets('renders sub text', (WidgetTester tester) async {
    final html = '<span style="vertical-align: sub">Foo</span>';
    final e = await explain(tester, html);
    expect(e, equals('[RichText:[Transform:child=[RichText:(:Foo)]]@bottom]'));
  });

  testWidgets('renders super text', (WidgetTester tester) async {
    final html = '<span style="vertical-align: super">Foo</span>';
    final e = await explain(tester, html);
    expect(e, equals('[RichText:[Transform:child=[RichText:(:Foo)]]@top]'));
  });

  group('image', () {
    final imgSrc = 'http://domain.com/image.png';
    final imgRendered = "[NetworkImage:url=$imgSrc]";
    final imgExplain = (WidgetTester t, String html) => explain(t, html);

    testWidgets('renders top image', (WidgetTester tester) async {
      final html = '<img src="$imgSrc" style="vertical-align: top" />';
      final explained = await imgExplain(tester, html);
      expect(explained, equals('[RichText:$imgRendered@top]'));
    });

    testWidgets('renders bottom image', (WidgetTester tester) async {
      final html = '<img src="$imgSrc" style="vertical-align: bottom" />';
      final explained = await imgExplain(tester, html);
      expect(explained, equals('[RichText:$imgRendered@bottom]'));
    });

    testWidgets('renders middle image', (WidgetTester tester) async {
      final html = '<img src="$imgSrc" style="vertical-align: middle" />';
      final explained = await imgExplain(tester, html);
      expect(explained, equals('[RichText:$imgRendered@middle]'));
    });

    testWidgets('renders after image', (WidgetTester tester) async {
      final html = '<img src="$imgSrc" /><sup>Foo</sup>';
      final explained = await imgExplain(tester, html);
      expect(
          explained,
          equals('[RichText:(:$imgRendered'
              '[Transform:child=[RichText:(@6.9:Foo)]]@top)]'));
    });
  });

  testWidgets('renders styling', (WidgetTester tester) async {
    final html = '<span style="vertical-align: top">F<em>o</em>o</span>';
    final explained = await explain(tester, html);
    expect(explained, equals('[RichText:[RichText:(:F(+i:o)(:o))]@top]'));
  });

  testWidgets('renders styling from outside', (WidgetTester tester) async {
    final html = '<em><span style="vertical-align: top">Foo</span></em>';
    final explained = await explain(tester, html);
    expect(explained, equals('[RichText:[RichText:(+i:Foo)]@top]'));
  });
}
