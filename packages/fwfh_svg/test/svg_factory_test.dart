// TODO: remove ignore for file when our minimum core version >= 1.0
// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fwfh_svg/fwfh_svg.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mocktail/mocktail.dart';

import '../../core/test/_.dart' as core;
import '_.dart';

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
<svg height="100px" width="100px">
  <circle cx="50" cy="50" r="40" stroke="black" stroke-width="3" fill="red" />
  SVG support is not enabled.
</svg>''';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals(
        '[CssSizing:height≥0.0,height=100.0,width≥0.0,width=100.0,child='
        '[SvgPicture:bytesLoader=SvgStringLoader]'
        ']',
      ),
    );
  });

  group('IMG', () {
    testWidgets('renders asset picture', (WidgetTester tester) async {
      const assetName = 'test/images/icon.svg';
      const html = '<img src="asset:$assetName" />';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssSizing:$sizingConstraints,child='
          '[SvgPicture:'
          'bytesLoader=SvgAssetLoader(assetName: test/images/icon.svg, packageName: null)'
          ']]',
        ),
      );
    });

    testWidgets('renders file picture', (WidgetTester tester) async {
      final filePath = '${Directory.current.path}/test/images/icon.svg';
      final html = '<img src="file://$filePath" />';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssSizing:$sizingConstraints,child='
          '[SvgPicture:'
          'bytesLoader=SvgFileLoader($filePath)'
          ']]',
        ),
      );
    });

    group('MemoryPicture', () {
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
            '[SvgPicture:bytesLoader=SvgBytesLoader]'
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
            '[SvgPicture:bytesLoader=SvgBytesLoader]'
            ']',
          ),
        );
      });
    });

    group('network picture', () {
      const expectedPicture = '└_RawPictureVectorGraphicWidget';

      testWidgets('renders picture', (WidgetTester tester) async {
        const src = 'http://domain.com/loading.svg';
        const html = '<img src="$src" />';
        const expectedLoading = '└CircularProgressIndicator';
        final loading = await HttpOverrides.runZoned(
          () => explain(tester, html, useExplainer: false),
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

  final goldenSkipEnvVar = Platform.environment['GOLDEN_SKIP'];
  final goldenSkip = goldenSkipEnvVar == null
      ? Platform.isLinux
          ? null
          : 'Linux only'
      : 'GOLDEN_SKIP=$goldenSkipEnvVar';

  GoldenToolkit.runWithConfiguration(
    () {
      group(
        'screenshot testing',
        () {
          setUp(() {
            WidgetFactory.debugDeterministicLoadingWidget = true;
          });
          tearDown(
            () => WidgetFactory.debugDeterministicLoadingWidget = false,
          );

          const svg = 'Foo.\n$redTriangle\nBar.';

          // https://github.com/daohoangson/flutter_widget_from_html/issues/1142
          const svg1142 = '''
<svg xmlns="http://www.w3.org/2000/svg" width="153px" height="48px" viewbox="0 -1971.3 8504.1 2679.3" xmlns:xlink="http://www.w3.org/1999/xlink" aria-hidden="true" style="">
  <defs>
    <path id="MJX-8-TEX-N-33" d="M127 463Q100 463 85 480T69 524Q69 579 117 622T233 665Q268 665 277 664Q351 652 390 611T430 522Q430 470 396 421T302 350L299 348Q299 347 308 345T337 336T375 315Q457 262 457 175Q457 96 395 37T238 -22Q158 -22 100 21T42 130Q42 158 60 175T105 193Q133 193 151 175T169 130Q169 119 166 110T159 94T148 82T136 74T126 70T118 67L114 66Q165 21 238 21Q293 21 321 74Q338 107 338 175V195Q338 290 274 322Q259 328 213 329L171 330L168 332Q166 335 166 348Q166 366 174 366Q202 366 232 371Q266 376 294 413T322 525V533Q322 590 287 612Q265 626 240 626Q208 626 181 615T143 592T132 580H135Q138 579 143 578T153 573T165 566T175 555T183 540T186 520Q186 498 172 481T127 463Z"></path>
    <path id="MJX-8-TEX-N-34" d="M462 0Q444 3 333 3Q217 3 199 0H190V46H221Q241 46 248 46T265 48T279 53T286 61Q287 63 287 115V165H28V211L179 442Q332 674 334 675Q336 677 355 677H373L379 671V211H471V165H379V114Q379 73 379 66T385 54Q393 47 442 46H471V0H462ZM293 211V545L74 212L183 211H293Z"></path>
    <path id="MJX-8-TEX-N-221A" d="M95 178Q89 178 81 186T72 200T103 230T169 280T207 309Q209 311 212 311H213Q219 311 227 294T281 177Q300 134 312 108L397 -77Q398 -77 501 136T707 565T814 786Q820 800 834 800Q841 800 846 794T853 782V776L620 293L385 -193Q381 -200 366 -200Q357 -200 354 -197Q352 -195 256 15L160 225L144 214Q129 202 113 190T95 178Z"></path>
    <path id="MJX-8-TEX-N-32" d="M109 429Q82 429 66 447T50 491Q50 562 103 614T235 666Q326 666 387 610T449 465Q449 422 429 383T381 315T301 241Q265 210 201 149L142 93L218 92Q375 92 385 97Q392 99 409 186V189H449V186Q448 183 436 95T421 3V0H50V19V31Q50 38 56 46T86 81Q115 113 136 137Q145 147 170 174T204 211T233 244T261 278T284 308T305 340T320 369T333 401T340 431T343 464Q343 527 309 573T212 619Q179 619 154 602T119 569T109 550Q109 549 114 549Q132 549 151 535T170 489Q170 464 154 447T109 429Z"></path>
    <path id="MJX-8-TEX-N-2B" d="M56 237T56 250T70 270H369V420L370 570Q380 583 389 583Q402 583 409 568V270H707Q722 262 722 250T707 230H409V-68Q401 -82 391 -82H389H387Q375 -82 369 -68V230H70Q56 237 56 250Z"></path>
    <path id="MJX-8-TEX-N-35" d="M164 157Q164 133 148 117T109 101H102Q148 22 224 22Q294 22 326 82Q345 115 345 210Q345 313 318 349Q292 382 260 382H254Q176 382 136 314Q132 307 129 306T114 304Q97 304 95 310Q93 314 93 485V614Q93 664 98 664Q100 666 102 666Q103 666 123 658T178 642T253 634Q324 634 389 662Q397 666 402 666Q410 666 410 648V635Q328 538 205 538Q174 538 149 544L139 546V374Q158 388 169 396T205 412T256 420Q337 420 393 355T449 201Q449 109 385 44T229 -22Q148 -22 99 32T50 154Q50 178 61 192T84 210T107 214Q132 214 148 197T164 157Z"></path>
    <path id="MJX-8-TEX-N-3D" d="M56 347Q56 360 70 367H707Q722 359 722 347Q722 336 708 328L390 327H72Q56 332 56 347ZM56 153Q56 168 72 173H708Q722 163 722 153Q722 140 707 133H70Q56 140 56 153Z"></path>
    <path id="MJX-8-TEX-I-1D465" d="M52 289Q59 331 106 386T222 442Q257 442 286 424T329 379Q371 442 430 442Q467 442 494 420T522 361Q522 332 508 314T481 292T458 288Q439 288 427 299T415 328Q415 374 465 391Q454 404 425 404Q412 404 406 402Q368 386 350 336Q290 115 290 78Q290 50 306 38T341 26Q378 26 414 59T463 140Q466 150 469 151T485 153H489Q504 153 504 145Q504 144 502 134Q486 77 440 33T333 -11Q263 -11 227 52Q186 -10 133 -10H127Q78 -10 57 16T35 71Q35 103 54 123T99 143Q142 143 142 101Q142 81 130 66T107 46T94 41L91 40Q91 39 97 36T113 29T132 26Q168 26 194 71Q203 87 217 139T245 247T261 313Q266 340 266 352Q266 380 251 392T217 404Q177 404 142 372T93 290Q91 281 88 280T72 278H58Q52 284 52 289Z"></path>
  </defs>
  <g stroke="currentColor" fill="currentColor" stroke-width="0" transform="scale(1,-1)">
    <g data-mml-node="math">
      <g data-mml-node="mfrac">
        <g data-mml-node="mrow" transform="translate(220,805)">
          <g data-mml-node="mfrac">
            <g data-mml-node="mn" transform="translate(220,394) scale(0.707)">
              <use data-c="33" xlink:href="#MJX-8-TEX-N-33"></use>
            </g>
            <g data-mml-node="mn" transform="translate(220,-345) scale(0.707)">
              <use data-c="34" xlink:href="#MJX-8-TEX-N-34"></use>
            </g>
            <rect width="553.6" height="60" x="120" y="220"></rect>
          </g>
          <g data-mml-node="msqrt" transform="translate(793.6,0)">
            <g transform="translate(853,0)">
              <g data-mml-node="mn">
                <use data-c="34" xlink:href="#MJX-8-TEX-N-34"></use>
              </g>
            </g>
            <g data-mml-node="mo" transform="translate(0,106)">
              <use data-c="221A" xlink:href="#MJX-8-TEX-N-221A"></use>
            </g>
            <rect width="500" height="60" x="853" y="846"></rect>
          </g>
          <g data-mml-node="msup" transform="translate(2146.6,0)">
            <g data-mml-node="mroot">
              <g>
                <g data-mml-node="mn" transform="translate(853,0)">
                  <use data-c="32" xlink:href="#MJX-8-TEX-N-32"></use>
                </g>
              </g>
              <g data-mml-node="mn" transform="translate(261.8,461.5) scale(0.5)">
                <use data-c="33" xlink:href="#MJX-8-TEX-N-33"></use>
              </g>
              <g data-mml-node="mo" transform="translate(0,100.5)">
                <use data-c="221A" xlink:href="#MJX-8-TEX-N-221A"></use>
              </g>
              <rect width="500" height="60" x="853" y="840.5"></rect>
            </g>
            <g data-mml-node="mn" transform="translate(1386,687.6) scale(0.707)">
              <use data-c="34" xlink:href="#MJX-8-TEX-N-34"></use>
            </g>
          </g>
          <g data-mml-node="mo" transform="translate(4158.3,0)">
            <use data-c="2B" xlink:href="#MJX-8-TEX-N-2B"></use>
          </g>
          <g data-mml-node="mn" transform="translate(5158.6,0)">
            <use data-c="35" xlink:href="#MJX-8-TEX-N-35"></use>
          </g>
        </g>
        <g data-mml-node="mn" transform="translate(2799.3,-686)">
          <use data-c="33" xlink:href="#MJX-8-TEX-N-33"></use>
        </g>
        <rect width="5858.6" height="60" x="120" y="220"></rect>
      </g>
      <g data-mml-node="mo" transform="translate(6376.3,0)">
        <use data-c="3D" xlink:href="#MJX-8-TEX-N-3D"></use>
      </g>
      <g data-mml-node="mn" transform="translate(7432.1,0)">
        <use data-c="34" xlink:href="#MJX-8-TEX-N-34"></use>
      </g>
      <g data-mml-node="mi" transform="translate(7932.1,0)">
        <use data-c="1D465" xlink:href="#MJX-8-TEX-I-1D465"></use>
      </g>
    </g>
  </g>
</svg>''';

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
            'SVG.scaled': svg1142,
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
  });

  @override
  Widget build(BuildContext _) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: HtmlWidget(
            contents,
            factoryBuilder: allowDrawingOutsideViewBox
                ? () => _GoldenAllowFactory()
                : () => _GoldenDisallowFactory(),
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
  set autoUncompress(bool _) {}
}

class _MockHttpClientRequest extends Mock implements HttpClientRequest {
  @override
  Future addStream(Stream<List<int>> stream) async {
    // intentionally left empty
  }
}

class _MockHttpClientResponse extends Mock implements HttpClientResponse {
  @override
  bool get isRedirect => false;

  @override
  bool get persistentConnection => false;

  @override
  String get reasonPhrase => '';

  @override
  List<RedirectInfo> get redirects => const [];
}

class _MockHttpHeaders extends Mock implements HttpHeaders {}

HttpClient _createMockSvgImageHttpClient() {
  final client = _MockHttpClient();
  final request = _MockHttpClientRequest();
  final response = _MockHttpClientResponse();
  final headers = _MockHttpHeaders();

  // TODO: remove when our minimum flutter_svg version >=2.0.10
  when(() => client.getUrl(any())).thenAnswer((_) async => request);
  when(
    () => response.listen(
      any(),
      onError: any(named: 'onError'),
      onDone: any(named: 'onDone'),
      cancelOnError: any(named: 'cancelOnError'),
    ),
  ).thenAnswer((invocation) {
    final onData =
        invocation.positionalArguments[0] as void Function(List<int> data);
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

  when(() => client.openUrl(any(), any())).thenAnswer((_) async => request);
  when(() => request.headers).thenReturn(headers);
  when(() => request.close()).thenAnswer((_) async => response);
  when(() => response.compressionState)
      .thenReturn(HttpClientResponseCompressionState.notCompressed);
  when(() => response.contentLength).thenReturn(redTriangleBytes.length);
  when(() => response.headers).thenReturn(headers);
  when(() => response.statusCode).thenReturn(HttpStatus.ok);
  when(() => response.handleError(any(), test: any(named: 'test')))
      .thenAnswer((_) => Stream.fromIterable(<List<int>>[redTriangleBytes]));

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
