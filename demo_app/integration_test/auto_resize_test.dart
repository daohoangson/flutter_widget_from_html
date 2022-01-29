import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fwfh_chewie/fwfh_chewie.dart';
import 'package:fwfh_webview/fwfh_webview.dart';
import 'package:integration_test/integration_test.dart';
import 'package:measurer/measurer.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('VideoPlayer', (WidgetTester tester) async {
    final test = _AspectRatioTest(
      child: VideoPlayer(
        'https://interactive-examples.mdn.mozilla.net/media/cc0-videos/flower.mp4',
        aspectRatio: 1,
        loadingBuilder: (_a, _b, _c) =>
            const Center(child: CircularProgressIndicator()),
      ),
    );

    runApp(test);
    await tester.pumpAndSettle();

    test.expectValueEquals(16 / 9);
  });

  final webViewTestCases = ValueVariant(const {
    WebViewTestCase(0.5, false),
    WebViewTestCase(1.0, false),
    WebViewTestCase(2.0, false),
    WebViewTestCase(1.0, true),
  });

  testWidgets(
    'WebView',
    (WidgetTester tester) async {
      final testCase = webViewTestCases.currentValue;
      final test = await testCase.run(tester);
      test.expectValueEquals(testCase.input);
    },
    variant: webViewTestCases,
  );
}

class WebViewTestCase {
  final double input;
  final bool issue375;

  // ignore: avoid_positional_boolean_parameters
  const WebViewTestCase(this.input, this.issue375);

  Future<_AspectRatioTest> run(WidgetTester tester) async {
    final html = '''
<!doctype html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
</head>

<body style="background: gray; margin: 0">
  <div id="block" style="background: black; color: white;">&nbsp;</div>
  <script>
    let attempts = 0;
    const block = document.getElementById('block');

    function resize() {
      attempts++;

      const width = window.innerWidth;
      if (width === 0) {
        DEBUG.postMessage(`($this attempt=\${attempts}) width === 0`);
        return setTimeout(resize, 10);
      }

      const height = width / $input;
      block.style.height = height + 'px';
      block.innerHTML = 'input={input}, attempts=' + attempts;

      const size = `\${width}x\${height}`;
      const scroll = `\${document.body.scrollWidth}x\${document.body.scrollHeight}`;
      DEBUG.postMessage(`($this attempt=\${attempts}) size=\${size} scroll=\${scroll}`);
      return setTimeout(resize, 100);
    }

    resize();
  </script>
</body>
''';

    const interval = Duration(seconds: 1);
    final webView = WebView(
      Uri.dataFromString(html, mimeType: 'text/html').toString(),
      aspectRatio: 16 / 9,
      autoResize: true,
      autoResizeIntervals: [interval, interval * 2, interval * 3],
      debuggingEnabled: true,
      jsCallbacks: {
        'DEBUG': (message) => debugPrint(message),
      },
      unsupportedWorkaroundForIssue375: issue375,
    );
    final test = _AspectRatioTest(child: webView);

    runApp(test);

    for (var i = 0; i < 5; i++) {
      await tester.pump();
      await tester.runAsync(() => Future.delayed(interval));
    }

    await tester.pump();
    await tester.pumpWidget(const SizedBox.shrink());

    return test;
  }

  @override
  String toString() {
    return 'input=$input issue375=$issue375';
  }
}

class _AspectRatioTest extends StatelessWidget {
  static final _value = Expando<double>();

  final Widget child;

  const _AspectRatioTest({@required this.child, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Measurer(
            onMeasure: (v, _) => _value[this] = v.width / v.height,
            child: child,
          ),
        ),
      ),
    );
  }

  void expectValueEquals(double expected) {
    const fractionDigits = 2;
    expect(
      _value[this]?.toStringAsFixed(fractionDigits),
      equals(expected.toStringAsFixed(fractionDigits)),
    );
  }
}
