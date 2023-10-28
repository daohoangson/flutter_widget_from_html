import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';

import '_.dart';

void main() {
  group('background-color', () {
    testWidgets('renders MARK tag', (WidgetTester tester) async {
      const html = '<mark>Foo</mark>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(color=#FFFFFF00#FF000000:Foo)]'));
    });

    testWidgets('renders block', (WidgetTester tester) async {
      const html = '<div style="background-color: #f00">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Container:color=#FFFF0000,child='
          '[CssBlock:child='
          '[RichText:(:Foo)]]]',
        ),
      );
    });

    testWidgets('renders with margins and paddings', (tester) async {
      const html = '<div style="background-color: #f00; '
          'margin: 1px; padding: 2px">Foo</div>';
      final explained = await explainMargin(tester, html);
      expect(
        explained,
        equals(
          '[SizedBox:0.0x1.0],'
          '[HorizontalMargin:left=1,right=1,child='
          '[Container:color=#FFFF0000,child='
          '[Padding:(2,2,2,2),child='
          '[CssBlock:child='
          '[RichText:(:Foo)]]]'
          ']],[SizedBox:0.0x1.0]',
        ),
      );
    });

    testWidgets('renders blocks', (WidgetTester tester) async {
      const h = '<div style="background-color: #f00"><p>A</p><p>B</p></div>';
      final explained = await explain(tester, h);
      expect(
        explained,
        equals(
          '[Container:color=#FFFF0000,child='
          '[CssBlock:child='
          '[Column:children='
          '[CssBlock:child=[RichText:(:A)]],'
          '[SizedBox:0.0x10.0],'
          '[CssBlock:child=[RichText:(:B)]]'
          ']]]',
        ),
      );
    });

    testWidgets('renders inline', (WidgetTester tester) async {
      const html = 'Foo <span style="background-color: #f00">bar</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo (color=#FFFF0000:bar))]'));
    });

    testWidgets('renders background', (WidgetTester tester) async {
      const html = 'Foo <span style="background: #f00">bar</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo (color=#FFFF0000:bar))]'));
    });

    group('renders without erroneous white spaces', () {
      testWidgets('before', (WidgetTester tester) async {
        const html = 'Foo<span style="background-color: #f00"> bar</span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(:Foo (color=#FFFF0000:bar))]'));
      });

      testWidgets('after', (WidgetTester tester) async {
        const html = 'Foo <span style="background-color: #f00">bar </span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(:Foo (color=#FFFF0000:bar))]'));
      });
    });

    testWidgets('resets in continuous SPANs (#155)', (tester) async {
      const html =
          '<span style="color: #ff0; background-color:#00f;">Foo</span>'
          '<span style="color: #f00;">bar</span>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[RichText:(:(color=#FF0000FF#FFFFFF00:Foo)(#FFFF0000:bar))]',
        ),
      );
    });
  });

  group('background-image', () {
    testWidgets('renders network', (WidgetTester tester) async {
      const src = 'http://domain.com/image.png';
      const html = '<div style="background-image: url($src)">Foo</div>';
      final explained = await mockNetworkImages(() => explain(tester, html));
      expect(
        explained,
        equals(
          '[Container:image=NetworkImage("$src", scale: 1.0),child='
          '[CssBlock:child=[RichText:(:Foo)]]'
          ']',
        ),
      );
    });

    group('asset', () {
      const assetName = 'test/images/logo.png';

      testWidgets('renders asset', (WidgetTester tester) async {
        const html =
            '<div style="background-image: url(asset:$assetName)">Foo</div>';
        final explained = await explain(tester, html);
        expect(
          explained,
          equals(
            '[Container:image=AssetImage(bundle: null, name: "$assetName"),child='
            '[CssBlock:child=[RichText:(:Foo)]]'
            ']',
          ),
        );
      });

      testWidgets('renders asset (specified package)', (tester) async {
        const package = 'flutter_widget_from_html_core';
        const html =
            '<div style="background-image: url(asset:$assetName?package=$package)">Foo</div>';
        final explained = await explain(tester, html);
        expect(
          explained,
          equals(
            '[Container:image=AssetImage(bundle: null, name: "packages/$package/$assetName"),child='
            '[CssBlock:child=[RichText:(:Foo)]]'
            ']',
          ),
        );
      });
    });

    testWidgets('data uri', (WidgetTester tester) async {
      const html = '<div style="background-image: url($kDataUri)">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Container:image=MemoryImage(bytes, scale: 1.0),child='
          '[CssBlock:child=[RichText:(:Foo)]]'
          ']',
        ),
      );
    });

    testWidgets('file uri', (WidgetTester tester) async {
      final filePath = '${Directory.current.path}/test/images/logo.png';
      final fileUri = 'file://$filePath';
      final html = '<div style="background-image: url($fileUri)">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Container:image=FileImage("$filePath", scale: 1.0),child='
          '[CssBlock:child=[RichText:(:Foo)]]'
          ']',
        ),
      );
    });

    testWidgets('renders background', (WidgetTester tester) async {
      const assetName = 'test/images/logo.png';
      const html = '<div style="background: url(asset:$assetName)">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Container:image=AssetImage(bundle: null, name: "$assetName"),child='
          '[CssBlock:child=[RichText:(:Foo)]]'
          ']',
        ),
      );
    });
  });
}
