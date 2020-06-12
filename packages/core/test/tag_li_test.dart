import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '_.dart';

void main() {
  final padding = 'Padding:(0,0,0,25)';
  final positioned = 'Positioned:(0.0,810.0,null,null)';
  final disc = '•';
  final circle = '-';
  final square = '+';

  testWidgets('renders list with padding', (WidgetTester tester) async {
    final html = '<ul><li>Foo</li></ul>';
    final explained = await explainMargin(tester, html);
    expect(
        explained,
        equals('[SizedBox:0.0x10.0],'
            '[$padding,child=[Stack:children=[RichText:(:Foo)],[$positioned,child=[RichText,align=right:(:$disc)]]]],'
            '[SizedBox:0.0x10.0]'));
  });

  testWidgets('renders ordered list', (WidgetTester tester) async {
    final html = '<ol><li>One</li><li>Two</li><li><b>Three</b></li><ol>';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[$padding,child=[Column:children='
            '[Stack:children=[RichText:(:One)],[$positioned,child=[RichText,align=right:(:1.)]]],'
            '[Stack:children=[RichText:(:Two)],[$positioned,child=[RichText,align=right:(:2.)]]],'
            '[Stack:children=[RichText:(+b:Three)],[$positioned,child=[RichText,align=right:(:3.)]]]'
            ']]'));
  });

  testWidgets('renders unordered list', (WidgetTester tester) async {
    final html = '<ul><li>One</li><li>Two</li><li><em>Three</em></li><ul>';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[$padding,child=[Column:children='
            '[Stack:children=[RichText:(:One)],[$positioned,child=[RichText,align=right:(:$disc)]]],'
            '[Stack:children=[RichText:(:Two)],[$positioned,child=[RichText,align=right:(:$disc)]]],'
            '[Stack:children=[RichText:(+i:Three)],[$positioned,child=[RichText,align=right:(:$disc)]]]'
            ']]'));
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
    expect(
        explained,
        equals('[$padding,child=[Column:children='
            '[Stack:children=[RichText:(:One)],[$positioned,child=[RichText,align=right:(:$disc)]]],'
            '[Stack:children='
            '[Column:children=[RichText:(:Two)],[$padding,child=[Column:children='
            '[Stack:children=[RichText:(:2.1)],[$positioned,child=[RichText,align=right:(:$circle)]]],'
            '[Stack:children='
            '[Column:children=[RichText:(:2.2)],[$padding,child=[Column:children='
            '[Stack:children=[RichText:(:2.2.1)],[$positioned,child=[RichText,align=right:(:$square)]]],'
            '[Stack:children=[RichText:(:2.2.2)],[$positioned,child=[RichText,align=right:(:$square)]]]'
            ']]],[$positioned,child=[RichText,align=right:(:$circle)]]],'
            '[Stack:children=[RichText:(:2.3)],[$positioned,child=[RichText,align=right:(:$circle)]]]'
            ']]],[$positioned,child=[RichText,align=right:(:$disc)]]],'
            '[Stack:children=[RichText:(:Three)],[$positioned,child=[RichText,align=right:(:$disc)]]]'
            ']]'));
  });

  testWidgets('renders nested list (single child)',
      (WidgetTester tester) async {
    final html = '''
<ul>
  <li>Foo</li>
  <li><ul><li>Bar</li></ul></li>
</ul>''';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[$padding,child=[Column:children='
            '[Stack:children=[RichText:(:Foo)],[$positioned,child=[RichText,align=right:(:$disc)]]],'
            '[$padding,child=[Stack:children=[RichText:(:Bar)],[$positioned,child=[RichText,align=right:(:$circle)]]]]'
            ']]'));
  });

  group('OL reversed', () {
    final olReversedLiHtml = '<li>x</li>';
    final olReversedLiPrefix =
        'Stack:children=[RichText:(:x)],[$positioned,child=[RichText,align=right:';
    final olReversedLiPostfix = ']]';

    testWidgets('renders 123 (default)', (WidgetTester tester) async {
      final lis = olReversedLiHtml * 3;
      final html = '<ol>$lis<ol>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[$padding,child=[Column:children='
              '[$olReversedLiPrefix(:1.)$olReversedLiPostfix],'
              '[$olReversedLiPrefix(:2.)$olReversedLiPostfix],'
              '[$olReversedLiPrefix(:3.)$olReversedLiPostfix]'
              ']]'));
    });

    testWidgets('renders 321', (WidgetTester tester) async {
      final lis = olReversedLiHtml * 3;
      final html = '<ol reversed>$lis<ol>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[$padding,child=[Column:children='
              '[$olReversedLiPrefix(:3.)$olReversedLiPostfix],'
              '[$olReversedLiPrefix(:2.)$olReversedLiPostfix],'
              '[$olReversedLiPrefix(:1.)$olReversedLiPostfix]'
              ']]'));
    });

    testWidgets('renders from 99', (WidgetTester tester) async {
      final lis = olReversedLiHtml * 3;
      final html = '<ol reversed start="99">$lis<ol>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[$padding,child=[Column:children='
              '[$olReversedLiPrefix(:99.)$olReversedLiPostfix],'
              '[$olReversedLiPrefix(:98.)$olReversedLiPostfix],'
              '[$olReversedLiPrefix(:97.)$olReversedLiPostfix]'
              ']]'));
    });
  });

  group('OL start', () {
    final olStartLiHtml = '<li>x</li>';
    final olStartLiPrefix =
        'Stack:children=[RichText:(:x)],[$positioned,child=[RichText,align=right:';
    final olStartLiPostfix = ']]';

    testWidgets('renders from 1 (default)', (WidgetTester tester) async {
      final html = '<ol>$olStartLiHtml<ol>';
      final explained = await explain(tester, html);
      expect(explained,
          equals('[$padding,child=[$olStartLiPrefix(:1.)$olStartLiPostfix]]'));
    });

    testWidgets('renders from 99', (WidgetTester tester) async {
      final html = '<ol start="99">$olStartLiHtml<ol>';
      final explained = await explain(tester, html);
      expect(explained,
          equals('[$padding,child=[$olStartLiPrefix(:99.)$olStartLiPostfix]]'));
    });

    testWidgets('renders xyz', (WidgetTester tester) async {
      final lis = olStartLiHtml * 3;
      final html = '<ol start="24" type="a">$lis<ol>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[$padding,child=[Column:children='
              '[$olStartLiPrefix(:x.)$olStartLiPostfix],'
              '[$olStartLiPrefix(:y.)$olStartLiPostfix],'
              '[$olStartLiPrefix(:z.)$olStartLiPostfix]'
              ']]'));
    });
  });

  group('OL type', () {
    final olTypeLiHtml = '<li>x</li>';
    final olTypeLiPrefix =
        '$padding,child=[Stack:children=[RichText:(:x)],[$positioned,child=[RichText,align=right:';
    final olTypeLiPostfix = ']]]';

    testWidgets('renders 1 (default)', (WidgetTester tester) async {
      final html = '<ol>$olTypeLiHtml<ol>';
      final explained = await explain(tester, html);
      expect(explained, equals('[$olTypeLiPrefix(:1.)$olTypeLiPostfix]'));
    });

    testWidgets('renders a (lower-alpha)', (WidgetTester tester) async {
      final html = '<ol type="a">$olTypeLiHtml<ol>';
      final explained = await explain(tester, html);
      expect(explained, equals('[$olTypeLiPrefix(:a.)$olTypeLiPostfix]'));
    });

    testWidgets('renders A (upper-alpha)', (WidgetTester tester) async {
      final html = '<ol type="A">$olTypeLiHtml<ol>';
      final explained = await explain(tester, html);
      expect(explained, equals('[$olTypeLiPrefix(:A.)$olTypeLiPostfix]'));
    });

    testWidgets('renders i (lower-roman)', (WidgetTester tester) async {
      final html = '<ol type="i">$olTypeLiHtml<ol>';
      final explained = await explain(tester, html);
      expect(explained, equals('[$olTypeLiPrefix(:i.)$olTypeLiPostfix]'));
    });

    testWidgets('renders I (upper-roman)', (WidgetTester tester) async {
      final html = '<ol type="I">$olTypeLiHtml<ol>';
      final explained = await explain(tester, html);
      expect(explained, equals('[$olTypeLiPrefix(:I.)$olTypeLiPostfix]'));
    });

    testWidgets('renders 1 (decimal)', (WidgetTester tester) async {
      final html = '<ol type="1">$olTypeLiHtml<ol>';
      final explained = await explain(tester, html);
      expect(explained, equals('[$olTypeLiPrefix(:1.)$olTypeLiPostfix]'));
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
          equals('[$padding,child=[Column:children='
              '[Stack:children=[RichText:(:decimal)],[$positioned,child=[RichText,align=right:(:1.)]]],'
              '[Stack:children=[RichText:(:lower-roman)],[$positioned,child=[RichText,align=right:(:ii.)]]],'
              '[Stack:children=[RichText:(:lower-alpha)],[$positioned,child=[RichText,align=right:(:c.)]]]'
              ']]'));
    });
  });

  group('inline style', () {
    group('list-style-type', () {
      testWidgets('renders disc (default for UL)', (WidgetTester tester) async {
        final html = '<ul><li>Foo</li></ul>';
        final explained = await explain(tester, html);
        expect(
            explained,
            equals('[$padding,child=[Stack:children=[RichText:(:Foo)],'
                '[$positioned,child=[RichText,align=right:(:$disc)]]]]'));
      });

      testWidgets('renders disc (OL)', (WidgetTester tester) async {
        final html = '<ol style="list-style-type: disc"><li>Foo</li></ol>';
        final explained = await explain(tester, html);
        expect(
            explained,
            equals('[$padding,child=[Stack:children=[RichText:(:Foo)],'
                '[$positioned,child=[RichText,align=right:(:$disc)]]]]'));
      });

      testWidgets('renders circle', (WidgetTester tester) async {
        final html = '<ul style="list-style-type: circle"><li>Foo</li></ul>';
        final explained = await explain(tester, html);
        expect(
            explained,
            equals('[$padding,child=[Stack:children=[RichText:(:Foo)],'
                '[$positioned,child=[RichText,align=right:(:$circle)]]]]'));
      });

      testWidgets('renders square', (WidgetTester tester) async {
        final html = '<ul style="list-style-type: square"><li>Foo</li></ul>';
        final explained = await explain(tester, html);
        expect(
            explained,
            equals('[$padding,child=[Stack:children=[RichText:(:Foo)],'
                '[$positioned,child=[RichText,align=right:(:$square)]]]]'));
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
            equals('[$padding,child=[Column:children='
                '[Stack:children=[RichText:(:disc)],[$positioned,child=[RichText,align=right:(:$disc)]]],'
                '[Stack:children=[RichText:(:square)],[$positioned,child=[RichText,align=right:(:$square)]]],'
                '[Stack:children=[RichText:(:circle)],[$positioned,child=[RichText,align=right:(:$circle)]]]'
                ']]'));
      });

      group('serial', () {
        final serialLiHtml = '<li>x</li>';
        final serialLiPrefix =
            'Stack:children=[RichText:(:x)],[$positioned,child=[RichText,align=right:';
        final serialLiPostfix = ']]';

        testWidgets('renders decimal (default for OL)', (tester) async {
          final html = '<ol>$serialLiHtml$serialLiHtml$serialLiHtml</ol>';
          final explained = await explain(tester, html);
          expect(
              explained,
              equals('[$padding,child=[Column:children='
                  '[$serialLiPrefix(:1.)$serialLiPostfix],'
                  '[$serialLiPrefix(:2.)$serialLiPostfix],'
                  '[$serialLiPrefix(:3.)$serialLiPostfix]'
                  ']]'));
        });

        testWidgets('renders decimal (UL)', (WidgetTester tester) async {
          final lis = '$serialLiHtml$serialLiHtml$serialLiHtml';
          final html = '<ul style="list-style-type: decimal">$lis</ul>';
          final explained = await explain(tester, html);
          expect(
              explained,
              equals('[$padding,child=[Column:children='
                  '[$serialLiPrefix(:1.)$serialLiPostfix],'
                  '[$serialLiPrefix(:2.)$serialLiPostfix],'
                  '[$serialLiPrefix(:3.)$serialLiPostfix]'
                  ']]'));
        });

        testWidgets('renders lower-alpha', (WidgetTester tester) async {
          final lis = serialLiHtml * 26;
          final html = '<ul style="list-style-type: lower-alpha">$lis</ul>';
          final explained = await explain(tester, html);
          expect(
              explained,
              equals('[$padding,child=[Column:children='
                  '[$serialLiPrefix(:a.)$serialLiPostfix],'
                  '[$serialLiPrefix(:b.)$serialLiPostfix],'
                  '[$serialLiPrefix(:c.)$serialLiPostfix],'
                  '[$serialLiPrefix(:d.)$serialLiPostfix],'
                  '[$serialLiPrefix(:e.)$serialLiPostfix],'
                  '[$serialLiPrefix(:f.)$serialLiPostfix],'
                  '[$serialLiPrefix(:g.)$serialLiPostfix],'
                  '[$serialLiPrefix(:h.)$serialLiPostfix],'
                  '[$serialLiPrefix(:i.)$serialLiPostfix],'
                  '[$serialLiPrefix(:j.)$serialLiPostfix],'
                  '[$serialLiPrefix(:k.)$serialLiPostfix],'
                  '[$serialLiPrefix(:l.)$serialLiPostfix],'
                  '[$serialLiPrefix(:m.)$serialLiPostfix],'
                  '[$serialLiPrefix(:n.)$serialLiPostfix],'
                  '[$serialLiPrefix(:o.)$serialLiPostfix],'
                  '[$serialLiPrefix(:p.)$serialLiPostfix],'
                  '[$serialLiPrefix(:q.)$serialLiPostfix],'
                  '[$serialLiPrefix(:r.)$serialLiPostfix],'
                  '[$serialLiPrefix(:s.)$serialLiPostfix],'
                  '[$serialLiPrefix(:t.)$serialLiPostfix],'
                  '[$serialLiPrefix(:u.)$serialLiPostfix],'
                  '[$serialLiPrefix(:v.)$serialLiPostfix],'
                  '[$serialLiPrefix(:w.)$serialLiPostfix],'
                  '[$serialLiPrefix(:x.)$serialLiPostfix],'
                  '[$serialLiPrefix(:y.)$serialLiPostfix],'
                  '[$serialLiPrefix(:z.)$serialLiPostfix]'
                  ']]'));
        });

        testWidgets('renders lower-latin', (WidgetTester tester) async {
          final lis = serialLiHtml * 26;
          final html = '<ul style="list-style-type: lower-latin">$lis</ul>';
          final explained = await explain(tester, html);
          expect(
              explained,
              equals('[$padding,child=[Column:children='
                  '[$serialLiPrefix(:a.)$serialLiPostfix],'
                  '[$serialLiPrefix(:b.)$serialLiPostfix],'
                  '[$serialLiPrefix(:c.)$serialLiPostfix],'
                  '[$serialLiPrefix(:d.)$serialLiPostfix],'
                  '[$serialLiPrefix(:e.)$serialLiPostfix],'
                  '[$serialLiPrefix(:f.)$serialLiPostfix],'
                  '[$serialLiPrefix(:g.)$serialLiPostfix],'
                  '[$serialLiPrefix(:h.)$serialLiPostfix],'
                  '[$serialLiPrefix(:i.)$serialLiPostfix],'
                  '[$serialLiPrefix(:j.)$serialLiPostfix],'
                  '[$serialLiPrefix(:k.)$serialLiPostfix],'
                  '[$serialLiPrefix(:l.)$serialLiPostfix],'
                  '[$serialLiPrefix(:m.)$serialLiPostfix],'
                  '[$serialLiPrefix(:n.)$serialLiPostfix],'
                  '[$serialLiPrefix(:o.)$serialLiPostfix],'
                  '[$serialLiPrefix(:p.)$serialLiPostfix],'
                  '[$serialLiPrefix(:q.)$serialLiPostfix],'
                  '[$serialLiPrefix(:r.)$serialLiPostfix],'
                  '[$serialLiPrefix(:s.)$serialLiPostfix],'
                  '[$serialLiPrefix(:t.)$serialLiPostfix],'
                  '[$serialLiPrefix(:u.)$serialLiPostfix],'
                  '[$serialLiPrefix(:v.)$serialLiPostfix],'
                  '[$serialLiPrefix(:w.)$serialLiPostfix],'
                  '[$serialLiPrefix(:x.)$serialLiPostfix],'
                  '[$serialLiPrefix(:y.)$serialLiPostfix],'
                  '[$serialLiPrefix(:z.)$serialLiPostfix]'
                  ']]'));
        });

        testWidgets('renders lower-roman', (WidgetTester tester) async {
          final lis = serialLiHtml * 10;
          final html = '<ul style="list-style-type: lower-roman">$lis</ul>';
          final explained = await explain(tester, html);
          expect(
              explained,
              equals('[$padding,child=[Column:children='
                  '[$serialLiPrefix(:i.)$serialLiPostfix],'
                  '[$serialLiPrefix(:ii.)$serialLiPostfix],'
                  '[$serialLiPrefix(:iii.)$serialLiPostfix],'
                  '[$serialLiPrefix(:iv.)$serialLiPostfix],'
                  '[$serialLiPrefix(:v.)$serialLiPostfix],'
                  '[$serialLiPrefix(:vi.)$serialLiPostfix],'
                  '[$serialLiPrefix(:vii.)$serialLiPostfix],'
                  '[$serialLiPrefix(:viii.)$serialLiPostfix],'
                  '[$serialLiPrefix(:ix.)$serialLiPostfix],'
                  '[$serialLiPrefix(:x.)$serialLiPostfix]'
                  ']]'));
        });

        testWidgets('renders upper-alpha', (WidgetTester tester) async {
          final lis = serialLiHtml * 26;
          final html = '<ul style="list-style-type: upper-alpha">$lis</ul>';
          final explained = await explain(tester, html);
          expect(
              explained,
              equals('[$padding,child=[Column:children='
                  '[$serialLiPrefix(:A.)$serialLiPostfix],'
                  '[$serialLiPrefix(:B.)$serialLiPostfix],'
                  '[$serialLiPrefix(:C.)$serialLiPostfix],'
                  '[$serialLiPrefix(:D.)$serialLiPostfix],'
                  '[$serialLiPrefix(:E.)$serialLiPostfix],'
                  '[$serialLiPrefix(:F.)$serialLiPostfix],'
                  '[$serialLiPrefix(:G.)$serialLiPostfix],'
                  '[$serialLiPrefix(:H.)$serialLiPostfix],'
                  '[$serialLiPrefix(:I.)$serialLiPostfix],'
                  '[$serialLiPrefix(:J.)$serialLiPostfix],'
                  '[$serialLiPrefix(:K.)$serialLiPostfix],'
                  '[$serialLiPrefix(:L.)$serialLiPostfix],'
                  '[$serialLiPrefix(:M.)$serialLiPostfix],'
                  '[$serialLiPrefix(:N.)$serialLiPostfix],'
                  '[$serialLiPrefix(:O.)$serialLiPostfix],'
                  '[$serialLiPrefix(:P.)$serialLiPostfix],'
                  '[$serialLiPrefix(:Q.)$serialLiPostfix],'
                  '[$serialLiPrefix(:R.)$serialLiPostfix],'
                  '[$serialLiPrefix(:S.)$serialLiPostfix],'
                  '[$serialLiPrefix(:T.)$serialLiPostfix],'
                  '[$serialLiPrefix(:U.)$serialLiPostfix],'
                  '[$serialLiPrefix(:V.)$serialLiPostfix],'
                  '[$serialLiPrefix(:W.)$serialLiPostfix],'
                  '[$serialLiPrefix(:X.)$serialLiPostfix],'
                  '[$serialLiPrefix(:Y.)$serialLiPostfix],'
                  '[$serialLiPrefix(:Z.)$serialLiPostfix]'
                  ']]'));
        });

        testWidgets('renders upper-latin', (WidgetTester tester) async {
          final lis = serialLiHtml * 26;
          final html = '<ul style="list-style-type: upper-latin">$lis</ul>';
          final explained = await explain(tester, html);
          expect(
              explained,
              equals('[$padding,child=[Column:children='
                  '[$serialLiPrefix(:A.)$serialLiPostfix],'
                  '[$serialLiPrefix(:B.)$serialLiPostfix],'
                  '[$serialLiPrefix(:C.)$serialLiPostfix],'
                  '[$serialLiPrefix(:D.)$serialLiPostfix],'
                  '[$serialLiPrefix(:E.)$serialLiPostfix],'
                  '[$serialLiPrefix(:F.)$serialLiPostfix],'
                  '[$serialLiPrefix(:G.)$serialLiPostfix],'
                  '[$serialLiPrefix(:H.)$serialLiPostfix],'
                  '[$serialLiPrefix(:I.)$serialLiPostfix],'
                  '[$serialLiPrefix(:J.)$serialLiPostfix],'
                  '[$serialLiPrefix(:K.)$serialLiPostfix],'
                  '[$serialLiPrefix(:L.)$serialLiPostfix],'
                  '[$serialLiPrefix(:M.)$serialLiPostfix],'
                  '[$serialLiPrefix(:N.)$serialLiPostfix],'
                  '[$serialLiPrefix(:O.)$serialLiPostfix],'
                  '[$serialLiPrefix(:P.)$serialLiPostfix],'
                  '[$serialLiPrefix(:Q.)$serialLiPostfix],'
                  '[$serialLiPrefix(:R.)$serialLiPostfix],'
                  '[$serialLiPrefix(:S.)$serialLiPostfix],'
                  '[$serialLiPrefix(:T.)$serialLiPostfix],'
                  '[$serialLiPrefix(:U.)$serialLiPostfix],'
                  '[$serialLiPrefix(:V.)$serialLiPostfix],'
                  '[$serialLiPrefix(:W.)$serialLiPostfix],'
                  '[$serialLiPrefix(:X.)$serialLiPostfix],'
                  '[$serialLiPrefix(:Y.)$serialLiPostfix],'
                  '[$serialLiPrefix(:Z.)$serialLiPostfix]'
                  ']]'));
        });

        testWidgets('renders upper-roman', (WidgetTester tester) async {
          final lis = serialLiHtml * 10;
          final html = '<ul style="list-style-type: upper-roman">$lis</ul>';
          final explained = await explain(tester, html);
          expect(
              explained,
              equals('[$padding,child=[Column:children='
                  '[$serialLiPrefix(:I.)$serialLiPostfix],'
                  '[$serialLiPrefix(:II.)$serialLiPostfix],'
                  '[$serialLiPrefix(:III.)$serialLiPostfix],'
                  '[$serialLiPrefix(:IV.)$serialLiPostfix],'
                  '[$serialLiPrefix(:V.)$serialLiPostfix],'
                  '[$serialLiPrefix(:VI.)$serialLiPostfix],'
                  '[$serialLiPrefix(:VII.)$serialLiPostfix],'
                  '[$serialLiPrefix(:VIII.)$serialLiPostfix],'
                  '[$serialLiPrefix(:IX.)$serialLiPostfix],'
                  '[$serialLiPrefix(:X.)$serialLiPostfix]'
                  ']]'));
        });
      });
    });

    group('padding-inline-start', () {
      testWidgets('renders 99px', (WidgetTester tester) async {
        final html = '<ul style="padding-inline-start: 99px"><li>Foo</li></ul>';
        final explained = await explain(tester, html);
        expect(
            explained,
            equals(
                '[Padding:(0,0,0,99),child=[Stack:children=[RichText:(:Foo)],'
                '[$positioned,child=[RichText,align=right:(:$disc)]]]]'));
      });

      testWidgets('renders LI padding-inline-start', (tester) async {
        // TODO: doesn't match browser output
        final html = '''
<ul style="padding-inline-start: 99px">
  <li style="padding-inline-start: 199px">199px</li>
  <li style="padding-inline-start: 299px">299px</li>
  <li>99px</li>
<ul>
''';
        final explained = await explain(tester, html);
        expect(
            explained,
            equals('[Padding:(0,0,0,99),child=[Column:children='
                '[Padding:(0,0,0,199),child=[Stack:children=[RichText:(:199px)],[$positioned,child=[RichText,align=right:(:$disc)]]]],'
                '[Padding:(0,0,0,299),child=[Stack:children=[RichText:(:299px)],[$positioned,child=[RichText,align=right:(:$disc)]]]],'
                '[Stack:children=[RichText:(:99px)],[$positioned,child=[RichText,align=right:(:$disc)]]]'
                ']]'));
      });
    });
  });

  group('error handling', () {
    testWidgets('standalone UL', (WidgetTester tester) async {
      final html = '<ul>Foo</ul>';
      final explained = await explain(tester, html);
      expect(explained, equals('[$padding,child=[RichText:(:Foo)]]'));
    });

    testWidgets('standalone OL', (WidgetTester tester) async {
      final html = '<ol>Foo</ol>';
      final explained = await explain(tester, html);
      expect(explained, equals('[$padding,child=[RichText:(:Foo)]]'));
    });

    testWidgets('standalone LI', (WidgetTester tester) async {
      // TODO: doesn't match browser output
      final html = '<li>Foo</li>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
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
          equals('[$padding,child=[Column:children='
              '[Stack:children=[RichText:(:One)],[$positioned,child=[RichText,align=right:(:$disc)]]],'
              '[$padding,child=[Column:children='
              '[Stack:children=[RichText:(:Two)],[$positioned,child=[RichText,align=right:(:$circle)]]],'
              '[Stack:children=[RichText:(:Three)],[$positioned,child=[RichText,align=right:(:$circle)]]]'
              ']]'
              ']]'));
    });

    testWidgets('LI has empty A', (WidgetTester tester) async {
      // https://github.com/daohoangson/flutter_widget_from_html/issues/112#issuecomment-550116179
      final html = '''<ol>
  <li>One</li>
  <li><a href="https://flutter.dev"></a></li>
  <li>Three</li>
</ol>''';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[$padding,child=[Column:children='
              '[Stack:children=[RichText:(:One)],[$positioned,child=[RichText,align=right:(:1.)]]],'
              '[Stack:children=[widget0],[$positioned,child=[RichText,align=right:(:2.)]]],'
              '[Stack:children=[RichText:(:Three)],[$positioned,child=[RichText,align=right:(:3.)]]]'
              ']]'));
    });
  });

  group('rtl', () {
    final rtlPadding = 'Padding:(0,25,0,0)';
    final rtlPositioned = 'Positioned:(0.0,null,null,810.0)';
    testWidgets('renders ordered list', (WidgetTester tester) async {
      final html = '<ol><li>One</li><li>Two</li><li><b>Three</b></li><ol>';
      final explained = await explain(tester, null,
          hw: Directionality(
            child: HtmlWidget(
              html,
              key: hwKey,
              bodyPadding: const EdgeInsets.all(0),
            ),
            textDirection: TextDirection.rtl,
          ));
      expect(
          explained,
          equals('[$rtlPadding,child=[Column:children='
              '[Stack:children=[RichText:(:One)],[$rtlPositioned,child=[RichText,align=left:(:1.)]]],'
              '[Stack:children=[RichText:(:Two)],[$rtlPositioned,child=[RichText,align=left:(:2.)]]],'
              '[Stack:children=[RichText:(+b:Three)],[$rtlPositioned,child=[RichText,align=left:(:3.)]]]'
              ']]'));
    });
  });
}
