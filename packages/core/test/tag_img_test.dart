import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';

import '_.dart' as helper;

void main() {
  const sizingConstraints = 'height≥0.0,height=auto,width≥0.0,width=auto';

  group('image.png', () {
    const src = 'http://domain.com/image.png';
    Future<String> explain(WidgetTester tester, String html) =>
        mockNetworkImages(() => helper.explain(tester, html));

    testWidgets('renders src', (WidgetTester tester) async {
      const html = '<img src="$src" />';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssSizing:$sizingConstraints,child='
          '[Image:image=NetworkImage("$src", scale: 1.0)]'
          ']',
        ),
      );
    });

    testWidgets('renders src+alt', (WidgetTester tester) async {
      const html = '<img src="$src" alt="Foo" />';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssSizing:$sizingConstraints,child='
          '[Image:'
          'image=NetworkImage("$src", scale: 1.0),'
          'semanticLabel=Foo'
          ']]',
        ),
      );
    });

    testWidgets('renders src+title', (WidgetTester tester) async {
      const html = '<img src="$src" title="Bar" />';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssSizing:$sizingConstraints,child='
          '[Tooltip:'
          'message=Bar,'
          'child=[Image:'
          'image=NetworkImage("$src", scale: 1.0),'
          'semanticLabel=Bar'
          ']]]',
        ),
      );
    });

    testWidgets('renders src+alt+title', (WidgetTester tester) async {
      const html = '<img src="$src" alt="Foo" title="Bar" />';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssSizing:$sizingConstraints,child='
          '[Tooltip:'
          'message=Bar,'
          'child=[Image:'
          'image=NetworkImage("$src", scale: 1.0),'
          'semanticLabel=Foo'
          ']]]',
        ),
      );
    });

    testWidgets('renders in one RichText', (WidgetTester tester) async {
      const html = '<img src="$src" /> <img src="$src" />';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[RichText:(:'
          '[CssSizing:$sizingConstraints,child=[Image:image=NetworkImage("$src", scale: 1.0)]]'
          '(: )'
          '[CssSizing:$sizingConstraints,child=[Image:image=NetworkImage("$src", scale: 1.0)]]'
          ')]',
        ),
      );
    });

    testWidgets('renders alt', (WidgetTester tester) async {
      const html = '<img alt="Foo" /> bar';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo bar)]'));
    });

    testWidgets('renders title', (WidgetTester tester) async {
      const html = '<img title="Foo" /> bar';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo bar)]'));
    });

    testWidgets('renders dimensions', (WidgetTester tester) async {
      const html = '<img src="$src" width="800" height="600" />';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssSizing:height≥0.0,height=600.0,width≥0.0,width=800.0,child='
          '[AspectRatio:aspectRatio=1.3,child=[Image:image=NetworkImage("$src", scale: 1.0)]]'
          ']',
        ),
      );
    });

    testWidgets('renders between texts', (WidgetTester tester) async {
      const html = 'Before text. <img src="$src" /> After text.';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[RichText:(:'
          'Before text. '
          '[CssSizing:$sizingConstraints,child=[Image:image=NetworkImage("$src", scale: 1.0)]]'
          '(: After text.)'
          ')]',
        ),
      );
    });

    testWidgets('renders block', (WidgetTester tester) async {
      const html = '<img src="$src" style="display: block" />';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssSizing:$sizingConstraints,child='
          '[Image:image=NetworkImage("$src", scale: 1.0)]]',
        ),
      );
    });

    testWidgets('renders block without src', (WidgetTester tester) async {
      const html = '<img style="display: block" />';
      final explained = await explain(tester, html);
      expect(explained, equals('[widget0]'));
    });
  });

  group('asset', () {
    const assetName = 'test/images/logo.png';
    const explain = helper.explain;

    testWidgets('renders asset', (WidgetTester tester) async {
      const html = '<img src="asset:$assetName" />';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssSizing:$sizingConstraints,child='
          '[Image:image=AssetImage('
          'bundle: null, '
          'name: "$assetName"'
          ')]]',
        ),
      );
    });

    testWidgets('renders asset (specified package)', (tester) async {
      const package = 'flutter_widget_from_html_core';
      const html = '<img src="asset:$assetName?package=$package" />';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssSizing:$sizingConstraints,child='
          '[Image:image=AssetImage('
          'bundle: null, '
          'name: "packages/$package/$assetName"'
          ')]]',
        ),
      );
    });

    testWidgets('renders bad asset', (WidgetTester tester) async {
      const html = '<img src="asset:" />';
      final explained = await explain(tester, html);
      expect(explained, equals('[widget0]'));
    });

    testWidgets('renders bad asset with alt text', (WidgetTester tester) async {
      const html = '<img src="asset:" alt="Foo" />';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });

    testWidgets('renders bad asset with title text', (tester) async {
      const html = '<img src="asset:" title="Foo" />';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });
  });

  group('data uri', () {
    const explain = helper.explain;

    testWidgets('renders data uri', (WidgetTester tester) async {
      const html = '<img src="${helper.kDataUri}" />';
      final explained = (await explain(tester, html))
          .replaceAll(RegExp('Uint8List#[0-9a-f]+,'), 'bytes,');
      expect(
        explained,
        equals(
          '[CssSizing:$sizingConstraints,child='
          '[Image:image=MemoryImage(bytes, scale: 1.0)]'
          ']',
        ),
      );
    });

    testWidgets('renders bad data uri', (WidgetTester tester) async {
      const html = '<img src="data:image/xxx" />';
      final explained = await explain(tester, html);
      expect(explained, equals('[widget0]'));
    });

    testWidgets('renders bad data uri with alt text', (tester) async {
      const html = '<img src="data:image/xxx" alt="Foo" />';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });

    testWidgets('renders bad data uri with title text', (tester) async {
      const html = '<img src="data:image/xxx" title="Foo" />';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });
  });

  group('file uri', () {
    const explain = helper.explain;
    final filePath = '${Directory.current.path}/test/images/logo.png';
    final fileUri = 'file://$filePath';

    testWidgets('renders file uri', (WidgetTester tester) async {
      final html = '<img src="$fileUri" />';
      final explained = (await explain(tester, html))
          .replaceAll(RegExp('Uint8List#[0-9a-f]+,'), 'bytes,');
      expect(
        explained,
        equals(
          '[CssSizing:$sizingConstraints,child='
          '[Image:image=FileImage("$filePath", scale: 1.0)]'
          ']',
        ),
      );
    });
  });

  group('baseUrl', () {
    Future<void> test(
      WidgetTester tester,
      String html,
      String fullUrl, {
      Uri? baseUrl,
    }) async {
      final explained = await helper.explain(
        tester,
        null,
        hw: HtmlWidget(
          html,
          baseUrl: baseUrl ?? Uri.parse('http://base.com/path/'),
          key: helper.hwKey,
        ),
      );
      expect(
        explained,
        equals(
          '[CssSizing:$sizingConstraints,child='
          '[Image:image=NetworkImage("$fullUrl", scale: 1.0)]'
          ']',
        ),
      );
    }

    testWidgets('renders full url', (WidgetTester tester) async {
      const fullUrl = 'http://domain.com/image.png';
      const html = '<img src="$fullUrl" />';
      await test(tester, html, fullUrl);
    });

    testWidgets('renders protocol relative url', (WidgetTester tester) async {
      const html = '<img src="//protocol.relative" />';
      const fullUrl = 'http://protocol.relative';
      await test(tester, html, fullUrl);
    });

    testWidgets('renders protocol relative url (https)', (tester) async {
      const html = '<img src="//protocol.relative/secured" />';
      const fullUrl = 'https://protocol.relative/secured';
      await test(
        tester,
        html,
        fullUrl,
        baseUrl: Uri.parse('https://base.com/secured'),
      );
    });

    testWidgets('renders root relative url', (WidgetTester tester) async {
      const html = '<img src="/root.relative" />';
      const fullUrl = 'http://base.com/root.relative';
      await test(tester, html, fullUrl);
    });

    testWidgets('renders relative url', (WidgetTester tester) async {
      const html = '<img src="relative" />';
      const fullUrl = 'http://base.com/path/relative';
      await test(tester, html, fullUrl);
    });
  });

  group('loadingBuilder', () {
    testWidgets('calls onLoadingBuilder', (WidgetTester tester) async {
      const src = 'http://domain.com/image.png';
      const html = '<img src="$src" />';
      final streamCompleter = _TestImageStreamCompleter();
      final values = <double?>[];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HtmlWidget(
              html,
              factoryBuilder: () => _LoadingBuilderFactory(streamCompleter),
              key: helper.hwKey,
              onLoadingBuilder: (_, __, loadingProgress) {
                values.add(loadingProgress);
                return widget0;
              },
            ),
          ),
        ),
      );

      expect(values, isEmpty);

      streamCompleter.addChunkEvent(10);
      await tester.pump();
      expect(values.length, 1);
      expect(values.last, isNull);

      streamCompleter.addChunkEvent(50, 100);
      await tester.pump();
      expect(values.length, 2);
      expect(values.last, .5);
    });
  });

  testWidgets('onTapImage', (WidgetTester tester) async {
    final taps = <ImageMetadata>[];
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HtmlWidget(
            '<img src="${helper.kDataUri}" width="20" height="20" />',
            onTapImage: taps.add,
          ),
        ),
      ),
    );
    await tester.tap(find.byType(Image));
    expect(taps.length, equals(1));
  });

  group('error handing', () {
    testWidgets('executes errorBuilder', (WidgetTester tester) async {
      const html = 'Foo <img src="data:image/jpg;base64,xxxx" /> bar';
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: HtmlWidget(html))),
      );
      await tester.pumpAndSettle();
      expect(find.text('❌'), findsOneWidget);
    });

    testWidgets('handles null provider', (WidgetTester tester) async {
      const src = 'http://domain.com/image.png';
      const html = 'Foo <img src="$src" alt="alt" /> bar';
      final explained = await helper.explain(
        tester,
        // html,
        null,
        hw: HtmlWidget(
          html,
          factoryBuilder: () => _NullProviderFactory(),
          key: helper.hwKey,
        ),
      );
      expect(explained, equals('[RichText:(:Foo alt bar)]'));
    });
  });
}

class _LoadingBuilderFactory extends WidgetFactory {
  final _TestImageStreamCompleter streamCompleter;

  _LoadingBuilderFactory(this.streamCompleter);

  @override
  ImageProvider<Object> imageProviderFromNetwork(String url) =>
      _TestImageProvider(streamCompleter);
}

class _TestImageProvider extends ImageProvider<Object> {
  final ImageStreamCompleter streamCompleter;

  _TestImageProvider(this.streamCompleter);

  @override
  Future<Object> obtainKey(ImageConfiguration configuration) =>
      SynchronousFuture<_TestImageProvider>(this);

  @override
  ImageStreamCompleter load(Object key, DecoderCallback decode) =>
      streamCompleter;
}

class _TestImageStreamCompleter extends ImageStreamCompleter {
  final listeners = <ImageStreamListener>{};

  _TestImageStreamCompleter();

  @override
  void addListener(ImageStreamListener listener) {
    listeners.add(listener);
  }

  @override
  void removeListener(ImageStreamListener listener) {
    listeners.remove(listener);
  }

  void addChunkEvent(int cumulativeBytesLoaded, [int expectedTotalBytes = 0]) {
    for (final listener in listeners) {
      listener.onChunk?.call(
        ImageChunkEvent(
          cumulativeBytesLoaded: cumulativeBytesLoaded,
          expectedTotalBytes: expectedTotalBytes,
        ),
      );
    }
  }
}

class _NullProviderFactory extends WidgetFactory {
  @override
  ImageProvider<Object>? imageProviderFromNetwork(String url) => null;
}
