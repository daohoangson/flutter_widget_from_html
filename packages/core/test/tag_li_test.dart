import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '_.dart';

const disc = '[_ListMarkerDisc]';
const circle = '[_ListMarkerCircle]';
const square = '[_ListMarkerSquare]';

const sizedBox = '[SizedBox:0.0x10.0]';

String padding(String child) =>
    '[CssBlock:child=[Padding:(0,0,0,40),child=$child]]';

String list(List<String> children) => '[Column:children=${children.join(",")}]';

String item(String markerText, String contents, {String child}) =>
    '[_ListItem:children=${child ?? '[RichText:(:$contents)]'},${marker(markerText)}]';

String marker(String text) =>
    text.startsWith('[_ListMarker') ? text : '[RichText:maxLines=1,(:$text)]';

void main() async {
  await loadAppFonts();

  testWidgets('renders list with padding', (WidgetTester tester) async {
    final html = '<ul><li>Foo</li></ul>';
    final e = await explainMargin(tester, html);
    expect(e, equals('$sizedBox,${padding(item(disc, "Foo"))},$sizedBox'));
  });

  testWidgets('renders ordered list', (WidgetTester tester) async {
    final html =
        '<ol><li>One</li><li>Two</li><li><strong>Three</strong></li><ol>';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals(padding(list([
          item('1.', 'One'),
          item('2.', 'Two'),
          item('3.', '', child: '[RichText:(+b:Three)]'),
        ]))));
  });

  testWidgets('renders unordered list', (WidgetTester tester) async {
    final html = '<ul><li>One</li><li>Two</li><li><em>Three</em></li><ul>';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals(padding(list([
          item(disc, 'One'),
          item(disc, 'Two'),
          item(disc, '', child: '[RichText:(+i:Three)]'),
        ]))));
  });

  testWidgets('renders nested list', (WidgetTester tester) async {
    final html = '''
<ul>
  <li>One</li>
  <li>
    Two
    <ul>
      <li>2.1</li>
      <li>
        2.2
        <ul>
          <li>2.2.1</li>
          <li>2.2.2</li>
        </ul>
      </li>
      <li>2.3</li>
    </ul>
  </li>
  <li>Three</li>
</ul>''';
    final explained = await explain(tester, html);

    final li221And222 = padding(list([
      item(square, '2.2.1'),
      item(square, '2.2.2'),
    ]));
    final li21And22And23 = padding(list([
      item(circle, '2.1'),
      item(circle, '',
          child: '[Column:children=[RichText:(:2.2)],$li221And222]'),
      item(circle, '2.3'),
    ]));
    expect(
        explained,
        equals(padding(list([
          item(disc, 'One'),
          item(disc, '',
              child: '[Column:children=[RichText:(:Two)],$li21And22And23]'),
          item(disc, 'Three'),
        ]))));
  });

  testWidgets('renders nested list (single child)', (tester) async {
    final html = '''
<ul>
  <li>Foo</li>
  <li><ul><li>Bar</li></ul></li>
</ul>''';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals(padding(list([
          item(disc, 'Foo'),
          item(disc, null, child: padding(item(circle, 'Bar'))),
        ]))));
  });

  group('OL reversed', () {
    testWidgets('renders 123 (default)', (WidgetTester tester) async {
      final html = '<ol><li>x</li><li>x</li><li>x</li><ol>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals(padding(list([
            item('1.', 'x'),
            item('2.', 'x'),
            item('3.', 'x'),
          ]))));
    });

    testWidgets('renders 321', (WidgetTester tester) async {
      final html = '<ol reversed><li>x</li><li>x</li><li>x</li><ol>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals(padding(list([
            item('3.', 'x'),
            item('2.', 'x'),
            item('1.', 'x'),
          ]))));
    });

    testWidgets('renders from 99', (WidgetTester tester) async {
      final html = '<ol reversed start="99"><li>x</li><li>x</li><li>x</li><ol>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals(padding(list([
            item('99.', 'x'),
            item('98.', 'x'),
            item('97.', 'x'),
          ]))));
    });
  });

  group('OL start', () {
    testWidgets('renders from 1 (default)', (WidgetTester tester) async {
      final html = '<ol><li>x</li><ol>';
      final explained = await explain(tester, html);
      expect(explained, equals(padding(item('1.', 'x'))));
    });

    testWidgets('renders from 99', (WidgetTester tester) async {
      final html = '<ol start="99"><li>x</li><ol>';
      final explained = await explain(tester, html);
      expect(explained, equals(padding(item('99.', 'x'))));
    });

    testWidgets('renders xyz', (WidgetTester tester) async {
      final html = '<ol start="24" type="a"><li>x</li><li>x</li><li>x</li><ol>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals(padding(list([
            item('x.', 'x'),
            item('y.', 'x'),
            item('z.', 'x'),
          ]))));
    });
  });

  group('OL type', () {
    testWidgets('renders 1 (default)', (WidgetTester tester) async {
      final html = '<ol><li>x</li><ol>';
      final explained = await explain(tester, html);
      expect(explained, equals(padding(item('1.', 'x'))));
    });

    testWidgets('renders a (lower-alpha)', (WidgetTester tester) async {
      final html = '<ol type="a"><li>x</li><ol>';
      final explained = await explain(tester, html);
      expect(explained, equals(padding(item('a.', 'x'))));
    });

    testWidgets('renders A (upper-alpha)', (WidgetTester tester) async {
      final html = '<ol type="A"><li>x</li><ol>';
      final explained = await explain(tester, html);
      expect(explained, equals(padding(item('A.', 'x'))));
    });

    testWidgets('renders i (lower-roman)', (WidgetTester tester) async {
      final html = '<ol type="i"><li>x</li><ol>';
      final explained = await explain(tester, html);
      expect(explained, equals(padding(item('i.', 'x'))));
    });

    testWidgets('renders I (upper-roman)', (WidgetTester tester) async {
      final html = '<ol type="I"><li>x</li><ol>';
      final explained = await explain(tester, html);
      expect(explained, equals(padding(item('I.', 'x'))));
    });

    testWidgets('renders 1 (decimal)', (WidgetTester tester) async {
      final html = '<ol type="1"><li>x</li><ol>';
      final explained = await explain(tester, html);
      expect(explained, equals(padding(item('1.', 'x'))));
    });

    testWidgets('renders LI type', (WidgetTester tester) async {
      final html = '''
<ol type="a">
  <li type="1">decimal</li>
  <li type="i">lower-roman</li>
  <li>lower-alpha</li>
<ol>
''';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals(padding(list([
            item('1.', 'decimal'),
            item('ii.', 'lower-roman'),
            item('c.', 'lower-alpha'),
          ]))));
    });
  });

  group('inline style', () {
    group('list-style-type', () {
      testWidgets('renders disc (default for UL)', (WidgetTester tester) async {
        final html = '<ul><li>Foo</li></ul>';
        final explained = await explain(tester, html);
        expect(explained, equals(padding(item(disc, 'Foo'))));
      });

      testWidgets('renders disc (OL)', (WidgetTester tester) async {
        final html = '<ol style="list-style-type: disc"><li>Foo</li></ol>';
        final explained = await explain(tester, html);
        expect(explained, equals(padding(item(disc, 'Foo'))));
      });

      testWidgets('renders circle', (WidgetTester tester) async {
        final html = '<ul style="list-style-type: circle"><li>Foo</li></ul>';
        final explained = await explain(tester, html);
        expect(explained, equals(padding(item(circle, 'Foo'))));
      });

      testWidgets('renders square', (WidgetTester tester) async {
        final html = '<ul style="list-style-type: square"><li>Foo</li></ul>';
        final explained = await explain(tester, html);
        expect(explained, equals(padding(item(square, 'Foo'))));
      });

      testWidgets('renders LI list-style-type', (WidgetTester tester) async {
        final html = '''
<ul style="list-style-type: circle">
  <li style="list-style-type: disc"">disc</li>
  <li style="list-style-type: square">square</li>
  <li>circle</li>
<ul>
''';
        final explained = await explain(tester, html);
        expect(
            explained,
            equals(padding(list([
              item(disc, 'disc'),
              item(square, 'square'),
              item(circle, 'circle'),
            ]))));
      });

      group('serial', () {
        testWidgets('renders decimal (default for OL)', (tester) async {
          final html = '<ol><li>x</li><li>x</li><li>x</li></ol>';
          final explained = await explain(tester, html);
          expect(
              explained,
              equals(padding(list([
                item('1.', 'x'),
                item('2.', 'x'),
                item('3.', 'x'),
              ]))));
        });

        testWidgets('renders decimal (UL)', (WidgetTester tester) async {
          final lis = '<li>x</li>' * 3;
          final html = '<ul style="list-style-type: decimal">$lis</ul>';
          final explained = await explain(tester, html);
          expect(
              explained,
              equals(padding(list([
                item('1.', 'x'),
                item('2.', 'x'),
                item('3.', 'x'),
              ]))));
        });

        testWidgets('renders lower-alpha', (WidgetTester tester) async {
          final lis = '<li>x</li>' * 26;
          final html = '<ul style="list-style-type: lower-alpha">$lis</ul>';
          final explained = await explain(tester, html);
          expect(
              explained,
              equals(padding(list([
                item('a.', 'x'),
                item('b.', 'x'),
                item('c.', 'x'),
                item('d.', 'x'),
                item('e.', 'x'),
                item('f.', 'x'),
                item('g.', 'x'),
                item('h.', 'x'),
                item('i.', 'x'),
                item('j.', 'x'),
                item('k.', 'x'),
                item('l.', 'x'),
                item('m.', 'x'),
                item('n.', 'x'),
                item('o.', 'x'),
                item('p.', 'x'),
                item('q.', 'x'),
                item('r.', 'x'),
                item('s.', 'x'),
                item('t.', 'x'),
                item('u.', 'x'),
                item('v.', 'x'),
                item('w.', 'x'),
                item('x.', 'x'),
                item('y.', 'x'),
                item('z.', 'x'),
              ]))));
        });

        testWidgets('renders lower-latin', (WidgetTester tester) async {
          final lis = '<li>x</li>' * 26;
          final html = '<ul style="list-style-type: lower-latin">$lis</ul>';
          final explained = await explain(tester, html);
          expect(
              explained,
              equals(padding(list([
                item('a.', 'x'),
                item('b.', 'x'),
                item('c.', 'x'),
                item('d.', 'x'),
                item('e.', 'x'),
                item('f.', 'x'),
                item('g.', 'x'),
                item('h.', 'x'),
                item('i.', 'x'),
                item('j.', 'x'),
                item('k.', 'x'),
                item('l.', 'x'),
                item('m.', 'x'),
                item('n.', 'x'),
                item('o.', 'x'),
                item('p.', 'x'),
                item('q.', 'x'),
                item('r.', 'x'),
                item('s.', 'x'),
                item('t.', 'x'),
                item('u.', 'x'),
                item('v.', 'x'),
                item('w.', 'x'),
                item('x.', 'x'),
                item('y.', 'x'),
                item('z.', 'x'),
              ]))));
        });

        testWidgets('renders lower-roman', (WidgetTester tester) async {
          final lis = '<li>x</li>' * 10;
          final html = '<ul style="list-style-type: lower-roman">$lis</ul>';
          final explained = await explain(tester, html);
          expect(
              explained,
              equals(padding(list([
                item('i.', 'x'),
                item('ii.', 'x'),
                item('iii.', 'x'),
                item('iv.', 'x'),
                item('v.', 'x'),
                item('vi.', 'x'),
                item('vii.', 'x'),
                item('viii.', 'x'),
                item('ix.', 'x'),
                item('x.', 'x'),
              ]))));
        });

        testWidgets('renders upper-alpha', (WidgetTester tester) async {
          final lis = '<li>x</li>' * 26;
          final html = '<ul style="list-style-type: upper-alpha">$lis</ul>';
          final explained = await explain(tester, html);
          expect(
              explained,
              equals(padding(list([
                item('A.', 'x'),
                item('B.', 'x'),
                item('C.', 'x'),
                item('D.', 'x'),
                item('E.', 'x'),
                item('F.', 'x'),
                item('G.', 'x'),
                item('H.', 'x'),
                item('I.', 'x'),
                item('J.', 'x'),
                item('K.', 'x'),
                item('L.', 'x'),
                item('M.', 'x'),
                item('N.', 'x'),
                item('O.', 'x'),
                item('P.', 'x'),
                item('Q.', 'x'),
                item('R.', 'x'),
                item('S.', 'x'),
                item('T.', 'x'),
                item('U.', 'x'),
                item('V.', 'x'),
                item('W.', 'x'),
                item('X.', 'x'),
                item('Y.', 'x'),
                item('Z.', 'x'),
              ]))));
        });

        testWidgets('renders upper-latin', (WidgetTester tester) async {
          final lis = '<li>x</li>' * 26;
          final html = '<ul style="list-style-type: upper-latin">$lis</ul>';
          final explained = await explain(tester, html);
          expect(
              explained,
              equals(padding(list([
                item('A.', 'x'),
                item('B.', 'x'),
                item('C.', 'x'),
                item('D.', 'x'),
                item('E.', 'x'),
                item('F.', 'x'),
                item('G.', 'x'),
                item('H.', 'x'),
                item('I.', 'x'),
                item('J.', 'x'),
                item('K.', 'x'),
                item('L.', 'x'),
                item('M.', 'x'),
                item('N.', 'x'),
                item('O.', 'x'),
                item('P.', 'x'),
                item('Q.', 'x'),
                item('R.', 'x'),
                item('S.', 'x'),
                item('T.', 'x'),
                item('U.', 'x'),
                item('V.', 'x'),
                item('W.', 'x'),
                item('X.', 'x'),
                item('Y.', 'x'),
                item('Z.', 'x'),
              ]))));
        });

        testWidgets('renders upper-roman', (WidgetTester tester) async {
          final lis = '<li>x</li>' * 10;
          final html = '<ul style="list-style-type: upper-roman">$lis</ul>';
          final explained = await explain(tester, html);
          expect(
              explained,
              equals(padding(list([
                item('I.', 'x'),
                item('II.', 'x'),
                item('III.', 'x'),
                item('IV.', 'x'),
                item('V.', 'x'),
                item('VI.', 'x'),
                item('VII.', 'x'),
                item('VIII.', 'x'),
                item('IX.', 'x'),
                item('X.', 'x'),
              ]))));
        });
      });
    });

    group('padding-inline-start', () {
      testWidgets('renders 99px', (WidgetTester tester) async {
        final html = '<ul style="padding-inline-start: 99px"><li>Foo</li></ul>';
        final explained = await explain(tester, html);
        expect(
            explained,
            equals('[CssBlock:child=[Padding:(0,0,0,99),child='
                '${item(disc, "Foo")}'
                ']]'));
      });

      testWidgets('renders LI padding-inline-start', (tester) async {
        // TODO: doesn't match browser output
        final html = '''
<ul style="padding-inline-start: 99px">
  <li style="padding-inline-start: 199px">199px</li>
  <li style="padding-inline-start: 299px">299px</li>
  <li>99px</li>
</ul>
''';
        final explained = await explain(tester, html);
        expect(
            explained,
            equals('[CssBlock:child=[Padding:(0,0,0,99),child=[Column:children='
                '[Padding:(0,0,0,199),child=[_ListItem:children=[RichText:(:199px)],${marker(disc)}]],'
                '[Padding:(0,0,0,299),child=[_ListItem:children=[RichText:(:299px)],${marker(disc)}]],'
                '${item(disc, "99px")}'
                ']]]'));
      });
    });
  });

  group('error handling', () {
    testWidgets('standalone UL', (WidgetTester tester) async {
      final html = '<ul>Foo</ul>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals(
              '[CssBlock:child=[Padding:(0,0,0,40),child=[RichText:(:Foo)]]]'));
    });

    testWidgets('standalone OL', (WidgetTester tester) async {
      final html = '<ol>Foo</ol>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals(
              '[CssBlock:child=[Padding:(0,0,0,40),child=[RichText:(:Foo)]]]'));
    });

    testWidgets('standalone LI', (WidgetTester tester) async {
      // TODO: doesn't match browser output
      final html = '<li>Foo</li>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });

    testWidgets('LI within LI', (WidgetTester tester) async {
      final html = '<ol><li><li>Foo</li></li></ol>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals(padding(list([
            item('1.', '', child: '[widget0]'),
            item('2.', 'Foo'),
          ]))));
    });

    testWidgets('UL is direct child of UL', (WidgetTester tester) async {
      final html = '''
<ul>
  <li>One</li>
  <ul>
    <li>Two</li>
    <li>Three</li>
  </ul>
</ul>''';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals(padding(list([
            item(disc, 'One'),
            padding(list([
              item(circle, 'Two'),
              item(circle, 'Three'),
            ])),
          ]))));
    });

    testWidgets('#112: LI has empty A', (WidgetTester tester) async {
      final html = '''<ol>
  <li>One</li>
  <li><a href="https://flutter.dev"></a></li>
  <li>Three</li>
</ol>''';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals(padding(list([
            item('1.', 'One'),
            item('2.', '', child: '[widget0]'),
            item('3.', 'Three'),
          ]))));
    });
  });

  group('rtl', () {
    final html = '<ol><li>One</li><li>Two</li><li><b>Three</b></li><ol>';

    final explainerExpected =
        '[CssBlock:child=[Padding:(0,40,0,0),child=[Column:dir=rtl,children='
        '[_ListItem:children=[RichText:dir=rtl,(:One)],[RichText:maxLines=1,dir=rtl,(:1.)]],'
        '[_ListItem:children=[RichText:dir=rtl,(:Two)],[RichText:maxLines=1,dir=rtl,(:2.)]],'
        '[_ListItem:children=[RichText:dir=rtl,(+b:Three)],[RichText:maxLines=1,dir=rtl,(:3.)]]'
        ']]]';

    final nonExplainerExpected = 'TshWidget\n'
        '└ColumnPlaceholder(BuildMetadata(root))\n'
        ' └CssBlock()\n'
        '  └Padding(padding: EdgeInsets(0.0, 0.0, 40.0, 0.0))\n'
        '   └Column(textDirection: rtl)\n'
        '    ├WidgetPlaceholder<BuildTree>(BuildTree#0 tsb#1(parent=#2):\n'
        '    ││  "One"\n'
        '    ││)\n'
        '    │└_ListItem(textDirection: rtl)\n'
        '    │ ├RichText(textDirection: rtl, text: "One")\n'
        '    │ └RichText(textDirection: rtl, maxLines: 1, text: "1.")\n'
        '    ├WidgetPlaceholder<BuildTree>(BuildTree#3 tsb#4(parent=#2):\n'
        '    ││  "Two"\n'
        '    ││)\n'
        '    │└_ListItem(textDirection: rtl)\n'
        '    │ ├RichText(textDirection: rtl, text: "Two")\n'
        '    │ └RichText(textDirection: rtl, maxLines: 1, text: "2.")\n'
        '    └WidgetPlaceholder<BuildTree>(BuildTree#5 tsb#6(parent=#2):\n'
        '     │  BuildTree#7 tsb#8(parent=#6):\n'
        '     │    "Three"\n'
        '     │)\n'
        '     └_ListItem(textDirection: rtl)\n'
        '      ├RichText(textDirection: rtl, text: "Three")\n'
        '      └RichText(textDirection: rtl, maxLines: 1, text: "3.")\n'
        '\n';

    testWidgets('renders ordered list', (WidgetTester tester) async {
      final explained = await explain(tester, null,
          hw: Directionality(
            child: HtmlWidget(html, key: hwKey),
            textDirection: TextDirection.rtl,
          ));
      expect(explained, equals(explainerExpected));
    });

    testWidgets('renders ordered list useExplainer=false', (tester) async {
      final explained = await explain(
        tester,
        null,
        hw: Directionality(
          child: HtmlWidget(html, key: hwKey),
          textDirection: TextDirection.rtl,
        ),
        useExplainer: false,
      );
      expect(explained, equals(nonExplainerExpected));
    });

    testWidgets('renders within dir attribute', (tester) async {
      final _dirRtl = '<div dir="rtl">$html</div>';
      final explained = await explain(tester, _dirRtl, useExplainer: false);
      expect(explained, equals(nonExplainerExpected));
    });
  });

  group('_ListItem', () {
    testWidgets('updates textDirection', (tester) async {
      final html = '<ul><li>Foo</li></ul>';

      final ltr = await explain(tester, html, rtl: false, useExplainer: false);
      expect(ltr, contains('_ListItem()'));

      final rtl = await explain(tester, html, rtl: true, useExplainer: false);
      expect(rtl, contains('_ListItem(textDirection: rtl)'));
    });

    testWidgets('performs hit test', (tester) async {
      const kHref = 'href';
      final urls = <String>[];

      await tester.pumpWidget(_HitTestApp(href: kHref, onTapUrl: urls.add));
      await tester.pumpAndSettle();
      expect(await tapText(tester, 'Tap me'), equals(1));
      expect(urls, equals(const [kHref]));
    });

    GoldenToolkit.runWithConfiguration(
      () {
        group('baseline calculation', () {
          final assetName = 'test/images/logo.png';
          final testCases = <String, String>{
            'img_block':
                '<img src="asset:$assetName" style="display: block; height: 30px;" />',
            'img_block_between_text':
                'foo <img src="asset:$assetName" style="display: block; height: 30px;" /> bar',
            'img_block_then_text':
                '<img src="asset:$assetName" style="display: block; height: 30px;" /> foo',
            'img_inline':
                '<img src="asset:$assetName" style="height: 30px;" />',
            'img_inline_between_text':
                'foo <img src="asset:$assetName" style="height: 30px;" /> bar',
            'img_inline_then_text':
                '<img src="asset:$assetName" style="height: 30px;" /> foo',
            'li_within_li': '<li>Foo</li>',
            'list_within_li': '<ul><li>Foo</li></ul>',
            'list_of_items_within_li': '<ol><li>Foo</li><li>Bar</li></ol>',
            'multiline':
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit.<br />\n' *
                    3,
            'padding': '<div style="padding: 10px">Foo</div>',
            'ruby': '<ruby>明日 <rp>(</rp><rt>Ashita</rt><rp>)</rp></ruby>',
          };

          for (final testCase in testCases.entries) {
            testGoldens(testCase.key, (tester) async {
              await tester.pumpWidgetBuilder(
                _Golden(testCase.value),
                wrapper: materialAppWrapper(theme: ThemeData.light()),
                surfaceSize: Size(600, 400),
              );

              await screenMatchesGolden(tester, testCase.key);
            }, skip: null);
          }
        }, skip: Platform.isLinux ? null : 'Linux only');
      },
      config: GoldenToolkitConfiguration(
        fileNameFactory: (name) => '$kGoldenFilePrefix/li/$name.png',
      ),
    );
  });
}

class _Golden extends StatelessWidget {
  final String contents;

  const _Golden(this.contents, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext _) => Scaffold(
        body: Padding(
          child: Column(
            children: [
              Text(contents),
              Divider(),
              Builder(
                builder: (context) => Text(
                  'UL:\n',
                  style: Theme.of(context).textTheme.caption,
                ),
              ),
              HtmlWidget('''
<ul>
  <li>Above</li>
  <li>$contents</li>
  <li>Below</li>
</ul>
'''),
              Divider(),
              Builder(
                builder: (context) => Text(
                  'OL:\n',
                  style: Theme.of(context).textTheme.caption,
                ),
              ),
              HtmlWidget('''
<ol>
  <li>First</li>
  <li>$contents</li>
  <li>Third</li>
</ol>
'''),
            ],
            crossAxisAlignment: CrossAxisAlignment.stretch,
          ),
          padding: const EdgeInsets.all(8.0),
        ),
      );
}

class _HitTestApp extends StatelessWidget {
  final String href;
  final void Function(String) onTapUrl;

  const _HitTestApp({this.href, Key key, this.onTapUrl}) : super(key: key);

  @override
  Widget build(BuildContext _) => MaterialApp(
        home: Scaffold(
          body: HtmlWidget(
            '<ul><li><a href="$href">Tap me</a></li></ul>',
            onTapUrl: onTapUrl,
          ),
        ),
      );
}
