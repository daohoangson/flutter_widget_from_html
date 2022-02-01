import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fwfh_svg/fwfh_svg.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mocktail/mocktail.dart';

import '../../core/test/_.dart' as core;
import '_.dart' as helper;

const redTriangle = '''
<svg xmlns="http://www.w3.org/2000/svg" version="1.1" viewBox="0 0 50 50" width="100" height="100">
  <path fill="#FF0000" d="M0 100 0 0 100 0"/>
</svg>''';
final redTriangleBytes = utf8.encode(redTriangle);

Future<void> main() async {
  await loadAppFonts();

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
          'pictureProvider=ExactAssetPicture(name: "$assetName", '
          'bundle: null, colorFilter: null)'
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
        final base64 = base64Encode(redTriangleBytes);
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

  final goldenSkip = Platform.isLinux ? null : 'Linux only';
  GoldenToolkit.runWithConfiguration(
    () {
      group(
        'screenshot testing',
        () {
          setUp(() {
            WidgetFactory.debugDeterministicLoadingWidget = true;
            PictureProvider.cache.clear();
          });
          tearDown(
            () => WidgetFactory.debugDeterministicLoadingWidget = false,
          );

          const svg = 'Foo.\n$redTriangle\nBar.';
          const asset = '''
Foo.
<img src="asset:test/images/red_triangle.svg" style="display: block" />
Bar.''';
          final file = '''
Foo.
<img src="file://${Directory.current.path}/test/images/red_triangle.svg" style="display: block" />
Bar.''';
          final memory = '''
Foo.
<img src="data:image/svg+xml;base64,${base64Encode(redTriangleBytes)}" style="display: block" />
Bar.''';
          const network = '''
Foo.
<img src="http://domain.com/red_triangle.svg" style="display: block" />
Bar.''';

          final testCases = <String, String>{
            'SVG': svg,
            'SVG.allow_drawing_outside': svg,
            'asset': asset,
            'asset.allow_drawing_outside': asset,
            'file': file,
            'file.allow_drawing_outside': file,
            'memory': memory,
            'memory.allow_drawing_outside': memory,
            'network': network,
            'network.allow_drawing_outside': network,
          };

          for (final testCase in testCases.entries) {
            testGoldens(
              testCase.key,
              (tester) async {
                await HttpOverrides.runZoned(
                  () => tester.runAsync(
                    () => tester.pumpWidgetBuilder(
                      _Golden(
                        testCase.value.trim(),
                        allowDrawingOutsideViewBox:
                            testCase.key.contains('allow_drawing_outside'),
                      ),
                      wrapper: materialAppWrapper(theme: ThemeData.light()),
                      surfaceSize: const Size(400, 400),
                    ),
                  ),
                  createHttpClient: (_) => _createMockSvgImageHttpClient(),
                );

                if (testCase.key.startsWith(RegExp('(file|network)'))) {
                  await tester.runAsync(
                    () => Future.delayed(const Duration(milliseconds: 100)),
                  );
                }

                await screenMatchesGolden(tester, testCase.key);
              },
              skip: goldenSkip != null,
            );
          }
        },
        skip: goldenSkip,
      );
    },
    config: GoldenToolkitConfiguration(
      fileNameFactory: (name) => '${core.kGoldenFilePrefix}/svg/$name.png',
    ),
  );
}

class _Golden extends StatelessWidget {
  final bool allowDrawingOutsideViewBox;

  final String contents;

  const _Golden(
    this.contents, {
    required this.allowDrawingOutsideViewBox,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext _) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                contents.replaceAll(
                  RegExp('file://.+/fwfh_svg/'),
                  'file://.../fwfh_svg/',
                ),
              ),
              const Divider(),
              HtmlWidget(
                contents,
                factoryBuilder: allowDrawingOutsideViewBox
                    ? () => _GoldenAllowFactory()
                    : () => _GoldenDisallowFactory(),
              ),
            ],
          ),
        ),
      );
}

class _GoldenAllowFactory extends WidgetFactory with SvgFactory {
  @override
  bool get svgAllowDrawingOutsideViewBox => true;
}

class _GoldenDisallowFactory extends WidgetFactory with SvgFactory {
  @override
  bool get svgAllowDrawingOutsideViewBox => false;
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
  when(() => response.contentLength).thenReturn(redTriangleBytes.length);
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
        invocation.namedArguments[const Symbol('onDone')] as Function?;
    return Stream.fromIterable(<List<int>>[redTriangleBytes])
        .listen((data) async {
      await Future.delayed(const Duration(milliseconds: 10));
      onData(data);
      // ignore: avoid_dynamic_calls
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
