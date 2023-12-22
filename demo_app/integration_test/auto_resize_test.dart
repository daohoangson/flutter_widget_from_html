import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fwfh_chewie/fwfh_chewie.dart';
import 'package:fwfh_webview/fwfh_webview.dart';
import 'package:measurer/measurer.dart';
import 'package:patrol/patrol.dart';

void main() {
  patrolTest('VideoPlayer', ($) async {
    final test = _AspectRatioTest(
      child: VideoPlayer(
        'https://interactive-examples.mdn.mozilla.net/media/cc0-videos/flower.mp4',
        aspectRatio: 1,
        loadingBuilder: (_, __, ___) =>
            const Center(child: CircularProgressIndicator()),
      ),
    );

    await $.pumpWidgetAndSettle(test);

    test.expectValueEquals(16 / 9);
  });

  final webViewTestCases = ValueVariant(const {
    WebViewTestCase(0.5, false),
    WebViewTestCase(1.0, false),
    WebViewTestCase(2.0, false),
    WebViewTestCase(1.0, true),
  });

  patrolTest(
    'WebView',
    ($) async {
      final testCase = webViewTestCases.currentValue!;
      final test = await testCase.run($);

      for (var i = 0;; i++) {
        await $.pump();
        await $.tester
            .runAsync(() => Future.delayed(const Duration(seconds: 3)));
        await $.pump();

        try {
          test.expectValueEquals(testCase.input);
          break;
        } catch (e) {
          if (i >= 5) {
            // too many failures
            rethrow;
          }
        }
      }

      await $.pump();
      await $.pumpWidget(const SizedBox.shrink());
    },
    variant: webViewTestCases,
  );
}

class WebViewTestCase {
  final double input;
  final bool issue375;

  // ignore: avoid_positional_boolean_parameters
  const WebViewTestCase(this.input, this.issue375);

  Future<_AspectRatioTest> run(PatrolIntegrationTester $) async {
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
        return setTimeout(resize, 10);
      }

      const height = width / $input;
      block.style.height = height + 'px';
      block.innerHTML = 'input={input}, attempts=' + attempts;
      return setTimeout(resize, 100);
    }

    resize();
  </script>
</body>
''';

    final webView = WebView(
      Uri.dataFromString(html, mimeType: 'text/html').toString(),
      aspectRatio: 16 / 9,
      autoResize: true,
      autoResizeIntervals: const [
        Duration(seconds: 1),
        Duration(seconds: 2),
        Duration(seconds: 3),
        Duration(seconds: 5),
        Duration(seconds: 8),
      ],
      debuggingEnabled: true,
    );
    final test = _AspectRatioTest(child: webView);

    await $.pumpWidget(test);

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

  const _AspectRatioTest({required this.child});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Measurer(
            onMeasure: (size, _) {
              debugPrint('onMeasure: size=$size');
              _value[this] = size.width / size.height;
            },
            child: child,
          ),
        ),
      ),
    );
  }

  void expectValueEquals(double expected) {
    const fractionDigits = 2;
    final powerOfTen = pow(10, fractionDigits);
    final actual = _value[this] ?? .0;
    expect(
      (actual * powerOfTen).floorToDouble() / powerOfTen,
      (expected * powerOfTen).floorToDouble() / powerOfTen,
      reason: 'actual $actual != expected $expected',
    );
  }
}
