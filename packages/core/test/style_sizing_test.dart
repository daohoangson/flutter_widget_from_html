import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '_.dart';

void main() {
  group('height', () {
    testWidgets('renders em', (WidgetTester tester) async {
      final html = '<div style="height: 2em">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssSizing:height=20.0,width=100.0%,child='
              '[RichText:(:Foo)]]'));
    });

    testWidgets('renders pt', (WidgetTester tester) async {
      final html = '<div style="height: 100pt">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssSizing:height=133.3,width=100.0%,child='
              '[RichText:(:Foo)]'
              ']'));
    });

    testWidgets('renders px', (WidgetTester tester) async {
      final html = '<div style="height: 100px">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssSizing:height=100.0,width=100.0%,child='
              '[RichText:(:Foo)]'
              ']'));
    });

    testWidgets('renders invalid', (WidgetTester tester) async {
      final html = '<div style="height: xxx">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
    });
  });

  group('max-height', () {
    testWidgets('renders em', (WidgetTester tester) async {
      final html = '<div style="max-height: 2em">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssSizing:height≤20.0,width=100.0%,child='
              '[RichText:(:Foo)]'
              ']'));
    });

    testWidgets('renders pt', (WidgetTester tester) async {
      final html = '<div style="max-height: 100pt">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssSizing:height≤133.3,width=100.0%,child='
              '[RichText:(:Foo)]'
              ']'));
    });

    testWidgets('renders px', (WidgetTester tester) async {
      final html = '<div style="max-height: 100px">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssSizing:height≤100.0,width=100.0%,child='
              '[RichText:(:Foo)]'
              ']'));
    });

    testWidgets('renders invalid', (WidgetTester tester) async {
      final html = '<div style="max-height: xxx">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
    });
  });

  group('max-width', () {
    testWidgets('renders em', (WidgetTester tester) async {
      final html = '<div style="max-width: 2em">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssSizing:width≤20.0,width=100.0%,child='
              '[RichText:(:Foo)]'
              ']'));
    });

    testWidgets('renders pt', (WidgetTester tester) async {
      final html = '<div style="max-width: 100pt">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssSizing:width≤133.3,width=100.0%,child='
              '[RichText:(:Foo)]'
              ']'));
    });

    testWidgets('renders px', (WidgetTester tester) async {
      final html = '<div style="max-width: 100px">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssSizing:width≤100.0,width=100.0%,child='
              '[RichText:(:Foo)]'
              ']'));
    });

    testWidgets('renders invalid', (WidgetTester tester) async {
      final html = '<div style="max-width: xxx">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
    });
  });

  group('min-height', () {
    testWidgets('renders em', (WidgetTester tester) async {
      final html = '<div style="min-height: 2em">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssSizing:height≥20.0,width=100.0%,child='
              '[RichText:(:Foo)]'
              ']'));
    });

    testWidgets('renders pt', (WidgetTester tester) async {
      final html = '<div style="min-height: 100pt">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssSizing:height≥133.3,width=100.0%,child='
              '[RichText:(:Foo)]'
              ']'));
    });

    testWidgets('renders px', (WidgetTester tester) async {
      final html = '<div style="min-height: 100px">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssSizing:height≥100.0,width=100.0%,child='
              '[RichText:(:Foo)]'
              ']'));
    });

    testWidgets('renders invalid', (WidgetTester tester) async {
      final html = '<div style="min-height: xxx">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
    });
  });

  group('min-width', () {
    testWidgets('renders em', (WidgetTester tester) async {
      final html = '<div style="min-width: 2em">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssSizing:width≥20.0,width=100.0%,child='
              '[RichText:(:Foo)]'
              ']'));
    });

    testWidgets('renders pt', (WidgetTester tester) async {
      final html = '<div style="min-width: 100pt">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssSizing:width≥133.3,width=100.0%,child='
              '[RichText:(:Foo)]'
              ']'));
    });

    testWidgets('renders px', (WidgetTester tester) async {
      final html = '<div style="min-width: 100px">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssSizing:width≥100.0,width=100.0%,child='
              '[RichText:(:Foo)]'
              ']'));
    });

    testWidgets('renders invalid', (WidgetTester tester) async {
      final html = '<div style="min-width: xxx">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
    });
  });

  group('width', () {
    testWidgets('renders em', (WidgetTester tester) async {
      final html = '<div style="width: 2em">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssSizing:width=20.0,child='
              '[RichText:(:Foo)]'
              ']'));
    });

    testWidgets('renders pt', (WidgetTester tester) async {
      final html = '<div style="width: 100pt">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssSizing:width=133.3,child='
              '[RichText:(:Foo)]'
              ']'));
    });

    testWidgets('renders px', (WidgetTester tester) async {
      final html = '<div style="width: 100px">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssSizing:width=100.0,child='
              '[RichText:(:Foo)]'
              ']'));
    });

    testWidgets('renders invalid', (WidgetTester tester) async {
      final html = '<div style="width: xxx">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
    });
  });

  testWidgets('renders complicated box', (WidgetTester tester) async {
    final html = '''
<div style="background-color: red; color: white; padding: 20px;">
  <div style="background-color: green;">
    <div style="background-color: blue; height: 100px; margin: 15px; padding: 5px; width: 100px;">
      Foo
    </div>
  </div>
</div>
''';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[CssBlock:child=[DecoratedBox:bg=#FFFF0000,child='
            '[Padding:(20,20,20,20),child='
            '[CssBlock:child=[DecoratedBox:bg=#FF008000,child='
            '[Padding:(0,15,0,15),child='
            '[CssSizing:height=100.0,width=100.0,child='
            '[DecoratedBox:bg=#FF0000FF,child='
            '[Padding:(5,5,5,5),child='
            '[RichText:(#FFFFFFFF:Foo)]'
            ']]]]]]]]]'));
  });

  group('block', () {
    testWidgets('renders block within block', (WidgetTester tester) async {
      final html =
          '<div style="width: 10px; height: 10px;"><div>Foo</div></div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssSizing:height=10.0,width=10.0,child='
              '[CssBlock:child=[RichText:(:Foo)]]'
              ']'));
    });

    testWidgets('renders block within non-block', (tester) async {
      final html =
          '<span style="width: 10px; height: 10px;"><div>Foo</div></span>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssSizing:height=10.0,width=10.0,child='
              '[CssBlock:child=[RichText:(:Foo)]]'
              ']'));
    });
  });

  group('inline', () {
    testWidgets('renders img with sizing', (WidgetTester tester) async {
      final src = 'https://domain.com/image.jpg';
      final html = 'Foo <img src="$src" style="width: 10px; height: 10px;" />';
      final explained = await mockNetworkImagesFor(() => explain(tester, html));
      expect(
          explained,
          equals('[RichText:(:Foo '
              '[CssSizing:height≥0.0,height=10.0,width≥0.0,width=10.0,child=[Image:image=NetworkImage("$src", scale: 1.0)]]'
              ')]'));
    });
  });
}
