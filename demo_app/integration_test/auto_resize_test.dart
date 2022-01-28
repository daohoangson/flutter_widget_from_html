import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fwfh_chewie/fwfh_chewie.dart';
import 'package:fwfh_webview/fwfh_webview.dart';
import 'package:integration_test/integration_test.dart';

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
    WebViewTestCase(1.0, false, true),
    WebViewTestCase(2.0, false, false),
    WebViewTestCase(0.5, false, true),
    WebViewTestCase(1.0, true, true),
    WebViewTestCase(2.0, true, false),
  });

  testWidgets(
    'WebView',
    (WidgetTester tester) async {
      final testCase = webViewTestCases.currentValue;
      final test = await testCase.run(tester);

      if (testCase.shouldResize) {
        test.expectValueEquals(testCase.input);
      } else {
        test.expectValueEquals(WebViewTestCase.defaultAspectRatio);
      }
    },
    variant: webViewTestCases,
  );
}

class WebViewTestCase {
  final double input;
  final bool issue375;
  final bool shouldResize;

  // ignore: avoid_positional_boolean_parameters
  const WebViewTestCase(this.input, this.issue375, this.shouldResize);

  static const defaultAspectRatio = 16 / 9;

  Future<_AspectRatioTest> run(WidgetTester tester) async {
    const html = '''
<body style="background: gray; margin: 0">
  <div id="block" style="background: black; color: white;">&nbsp;</div>
  <script>
    var attempts = 0;
    var block = document.getElementById('block');

    function resize() {
      attempts++;

      var width = window.innerWidth;
      if (width === 0) {
        return setTimeout(resize, 10);
      }

      var height = width / {input};
      block.style.height = height + 'px';
      block.innerHTML = 'input={input}, attempts=' + attempts;
      return setTimeout(resize, 100);
    }

    resize();
  </script>
</body>
''';

    const interval = Duration(seconds: 1);
    final webView = WebView(
      Uri.dataFromString(
        html.replaceAll('{input}', input.toString()),
        mimeType: 'text/html',
      ).toString(),
      aspectRatio: defaultAspectRatio,
      autoResize: true,
      autoResizeIntervals: [interval, interval * 2, interval * 3],
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
          child: _MeasurableWidget(
            onChange: (v) => _value[this] = v,
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

/// https://blog.gskinner.com/archives/2021/01/flutter-how-to-measure-widgets.html
class _MeasurableWidget extends SingleChildRenderObjectWidget {
  final _OnSizeChange onChange;

  const _MeasurableWidget({
    @required Widget child,
    Key key,
    @required this.onChange,
  }) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _MeasureSizeRenderObject(onChange);
}

class _MeasureSizeRenderObject extends RenderProxyBox {
  final _OnSizeChange onChange;

  Size _prevSize;

  _MeasureSizeRenderObject(this.onChange);

  @override
  void performLayout() {
    super.performLayout();

    final newSize = child.size;
    if (_prevSize != newSize) {
      _prevSize = newSize;
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => onChange(newSize.width / newSize.height),
      );
    }
  }
}

typedef _OnSizeChange = void Function(double aspectRatio);
