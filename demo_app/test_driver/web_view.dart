import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '_2.dart';

void main() {
  enableFlutterDriverExtension();
  runApp(TestApp());
}

const html = """
<body style="background: gray; margin: 0">
  <div id="block" style="background: black; color: white;">&nbsp;</div>
  <script>
    var attempts = 0;
    var block = document.getElementById('block');

    function resize() {
      attempts++;
      var width = window.innerWidth;
      if (width === 0) return setTimeout(resize, 10);

      var height = width / {input};
      block.style.height = height + 'px';
      block.innerHTML = 'input={input}, attempts=' + attempts;
    }

    resize();
  </script>
</body>
""";

class TestApp extends StatelessWidget {
  final input = ValueNotifier('');
  final issue375 = ValueNotifier(false);

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: SafeArea(
          child: Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildButtons(),
                _buildButtons(issue375: true),
                Expanded(child: _buildAspectRatioTester()),
              ],
            ),
          ),
        ),
      );

  Widget _buildButton(String value, {bool issue375 = false}) => RaisedButton(
        child: Text(value + (issue375 ? ' issue375' : '')),
        key: ValueKey('input-$value' + (issue375 ? '-issue375' : '')),
        onPressed: () {
          input.value = value;
          this.issue375.value = issue375;
        },
      );

  Widget _buildButtons({bool issue375 = false}) => Row(
        children: <Widget>[
          Expanded(child: _buildButton('1.0', issue375: issue375)),
          Expanded(child: _buildButton('2.0', issue375: issue375)),
          Expanded(child: _buildButton('3.0', issue375: issue375)),
        ],
      );

  Widget _buildAspectRatioTester() => AnimatedBuilder(
        animation: Listenable.merge([input, issue375]),
        builder: (_, __) => input.value.isNotEmpty
            ? AspectRatioTester(
                child: WebView(
                  Uri.dataFromString(
                    html.replaceAll('{input}', input.value),
                    mimeType: 'text/html',
                  ).toString(),
                  aspectRatio: 16 / 9,
                  autoResize: true,
                  unsupportedWorkaroundForIssue375: issue375.value,
                ),
                key: UniqueKey(),
              )
            : widget0,
      );
}
