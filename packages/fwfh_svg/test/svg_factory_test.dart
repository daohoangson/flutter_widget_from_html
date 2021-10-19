import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fwfh_svg/fwfh_svg.dart';
import 'package:mocktail/mocktail.dart';

import '_.dart' as helper;
import '../../core/test/_.dart' as core;

final svgBytes = utf8.encode('<svg viewBox="0 0 1 1"></svg>');

void main() {
  const sizingConstraints = 'height≥0.0,height=auto,width≥0.0,width=auto';

  setUpAll(() {
    registerFallbackValue(Uri());
  });

  testWidgets('renders SVG tag', (WidgetTester tester) async {
    const html = '''
<svg height="100" width="100">
  <circle cx="50" cy="50" r="40" stroke="black" stroke-width="3" fill="red" />
  SVG support is not enabled.
</svg>''';
    final explained = await helper.explain(tester, html);
    expect(
      explained.replaceAll(RegExp('String#[^,]+,'), 'String,'),
      equals(
        '[SvgPicture:pictureProvider=StringPicture(String, colorFilter: null)]',
      ),
    );
  });

  group('IMG', () {
    testWidgets('renders asset picture', (WidgetTester tester) async {
      const assetName = 'test/images/logo.svg';
      const html = '<img src="asset:$assetName" />';
      final explained = await helper.explain(tester, html);
      expect(
        explained,
        equals(
          '[CssSizing:$sizingConstraints,child='
          '[SvgPicture:'
          'pictureProvider=ExactAssetPicture(name: "$assetName", bundle: null, colorFilter: null)'
          ']]',
        ),
      );
    });

    testWidgets('renders file picture', (WidgetTester tester) async {
      final filePath = '${Directory.current.path}/test/images/logo.svg';
      final html = '<img src="file://$filePath" />';
      final explained = await helper.explain(tester, html);
      expect(
        explained,
        equals(
          '[CssSizing:$sizingConstraints,child='
          '[SvgPicture:'
          'pictureProvider=FilePicture("$filePath", colorFilter: null)'
          ']]',
        ),
      );
    });

    group('MemoryPicture', () {
      Future<String> explain(WidgetTester tester, String html) => helper
          .explain(tester, html)
          .then((e) => e.replaceAll(RegExp(r'\(Uint8List#.+\)'), '(bytes)'));

      testWidgets('renders bad data uri', (WidgetTester tester) async {
        const html = '<img src="data:image/svg+xml;xxx" />';
        final explained = await explain(tester, html);
        expect(explained, equals('[widget0]'));
      });

      testWidgets('renders base64', (WidgetTester tester) async {
        final base64 = base64Encode(svgBytes);
        final html = '<img src="data:image/svg+xml;base64,$base64" />';
        final explained = await explain(tester, html);
        expect(
          explained,
          equals(
            '[CssSizing:$sizingConstraints,child='
            '[SvgPicture:pictureProvider=MemoryPicture(bytes)]'
            ']',
          ),
        );
      });

      testWidgets('renders utf8', (WidgetTester tester) async {
        const utf8 = '&lt;svg viewBox=&quot;0 0 1 1&quot;&gt;&lt;/svg&gt;';
        const html = '<img src="data:image/svg+xml;utf8,$utf8" />';
        final explained = await explain(tester, html);
        expect(
          explained,
          equals(
            '[CssSizing:$sizingConstraints,child='
            '[SvgPicture:pictureProvider=MemoryPicture(bytes)]'
            ']',
          ),
        );
      });
    });

    group('network picture', () {
      const expectedPicture = '└RawPicture';

      testWidgets('renders picture', (WidgetTester tester) async {
        const src = 'http://domain.com/loading.svg';
        const html = '<img src="$src" />';
        const expectedLoading = '└CircularProgressIndicator';
        final loading = await HttpOverrides.runZoned(
          () => helper.explain(tester, html, useExplainer: false),
          createHttpClient: (_) => _createMockSvgImageHttpClient(),
        );
        expect(loading, contains('└SvgPicture'));
        expect(loading, contains(expectedLoading));
        expect(loading, isNot(contains(expectedPicture)));

        await tester.pumpAndSettle();

        final picture = await core.explainWithoutPumping(useExplainer: false);
        expect(picture, isNot(contains(expectedLoading)));
        expect(picture, contains(expectedPicture));
      });

      testWidgets('renders LimitedBox on loading', (WidgetTester tester) async {
        const src = 'http://domain.com/LimitedBox.svg';
        const html = '<img src="$src" />';
        const expectedLimitedBox = '└LimitedBox()';
        final loading = await HttpOverrides.runZoned(
          () => core.explain(
            tester,
            null,
            hw: HtmlWidget(
              html,
              factoryBuilder: () => _NullLoadingFactory(),
              key: core.hwKey,
            ),
            useExplainer: false,
          ),
          createHttpClient: (_) => _createMockSvgImageHttpClient(),
        );
        expect(loading, contains('└SvgPicture'));
        expect(loading, contains(expectedLimitedBox));
        expect(loading, isNot(contains(expectedPicture)));

        await tester.pumpAndSettle();

        final picture = await core.explainWithoutPumping(useExplainer: false);
        expect(picture, isNot(contains(expectedLimitedBox)));
        expect(picture, contains(expectedPicture));
      });

      testWidgets('renders SizedBox on loading', (WidgetTester tester) async {
        const src = 'http://domain.com/SizedBox.svg';
        const html = '<img src="$src" width="100" height="50" />';
        const expectedSizedBox = '└SizedBox(width: 100.0, height: 50.0)';
        final loading = await HttpOverrides.runZoned(
          () => core.explain(
            tester,
            null,
            hw: HtmlWidget(
              html,
              factoryBuilder: () => _NullLoadingFactory(),
              key: core.hwKey,
            ),
            useExplainer: false,
          ),
          createHttpClient: (_) => _createMockSvgImageHttpClient(),
        );
        expect(loading, contains('└SvgPicture'));
        expect(loading, contains(expectedSizedBox));
        expect(loading, isNot(contains(expectedPicture)));

        await tester.pumpAndSettle();

        final picture = await core.explainWithoutPumping(useExplainer: false);
        expect(picture, isNot(contains(expectedSizedBox)));
        expect(picture, contains(expectedPicture));
      });
    });
  });
}

class _MockHttpClient extends Mock implements HttpClient {
  @override
  // ignore: avoid_setters_without_getters
  set autoUncompress(bool _autoUncompress) {}
}

class _MockHttpClientRequest extends Mock implements HttpClientRequest {}

class _MockHttpClientResponse extends Mock implements HttpClientResponse {}

class _MockHttpHeaders extends Mock implements HttpHeaders {}

HttpClient _createMockSvgImageHttpClient() {
  final client = _MockHttpClient();
  final request = _MockHttpClientRequest();
  final response = _MockHttpClientResponse();
  final headers = _MockHttpHeaders();

  when(() => client.getUrl(any())).thenAnswer((_) async => request);
  when(() => request.headers).thenReturn(headers);
  when(() => request.close()).thenAnswer((_) async => response);
  when(() => response.compressionState)
      .thenReturn(HttpClientResponseCompressionState.notCompressed);
  when(() => response.contentLength).thenReturn(svgBytes.length);
  when(() => response.statusCode).thenReturn(HttpStatus.ok);
  when(
    () => response.listen(
      any(),
      onError: any(named: 'onError'),
      onDone: any(named: 'onDone'),
      cancelOnError: any(named: 'cancelOnError'),
    ),
  ).thenAnswer((invocation) {
    final onData =
        invocation.positionalArguments[0] as void Function(List<int>);
    final onDone =
        invocation.namedArguments[const Symbol("onDone")] as Function?;
    return Stream.fromIterable(<List<int>>[svgBytes]).listen((data) async {
      await Future.delayed(const Duration(milliseconds: 10));
      onData(data);
      onDone?.call();
    });
  });

  return client;
}

class _NullLoadingFactory extends WidgetFactory with SvgFactory {
  @override
  Widget? onLoadingBuilder(
    BuildContext context,
    BuildMetadata meta, [
    double? loadingProgress,
    dynamic data,
  ]) =>
      null;
}
