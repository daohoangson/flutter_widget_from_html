import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

void main() {
  enableFlutterDriverExtension();
  runApp(TestApp());
}

const html = """
<body style="background: gray; margin: 0">
  <div id="block" style="background: black; color: white;">&nbsp;</div>
  <script>
    var block = document.getElementById('block');
    var width = window.innerWidth;
    var height = width / {input};
    block.innerHTML = '{input}';
    block.style.height = height + 'px';
  </script>
</body>
""";

class TestApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TestAppState();
}

class _TestAppState extends State<TestApp> {
  String input = '';
  double output = 0;

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: SafeArea(
          child: Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildButtons(),
                Expanded(child: _buildListView()),
              ],
            ),
          ),
        ),
      );

  Widget _buildButton(String value) => RaisedButton(
        child: Text(value),
        key: ValueKey("input-$value"),
        onPressed: () => setState(() => input = value),
      );

  Widget _buildButtons() => Row(
        children: <Widget>[
          Expanded(child: _buildButton('1.0')),
          Expanded(child: _buildButton('2.0')),
          Expanded(child: _buildButton('3.0')),
        ],
      );

  Widget _buildListView() => ListView(
        children: <Widget>[
          Text(output.toStringAsFixed(2), key: ValueKey('output')),
          input.length > 0
              ? WebView(
                  Uri.dataFromString(
                    html.replaceAll('{input}', input),
                    mimeType: 'text/html',
                  ).toString(),
                  aspectRatio: 16 / 9,
                  getDimensions: true,
                  getDimensionsDone: (v, _c, _h, _w) =>
                      setState(() => output = v),
                  getDimensionsDurations: [null],
                  key: Key(input),
                )
              : Container(),
        ],
      );
}
