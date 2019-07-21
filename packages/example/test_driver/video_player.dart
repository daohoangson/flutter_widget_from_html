import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '_.dart';

void main() {
  enableFlutterDriverExtension();
  runApp(TestApp());
}

class TestApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TestAppState();
}

class _TestAppState extends State<TestApp> {
  String input = '';

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: SafeArea(
          child: Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildButtons(),
                Expanded(child: _buildAspectRatioTester()),
              ],
            ),
          ),
        ),
      );

  Widget _buildButton(String value) => RaisedButton(
        child: Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        key: ValueKey("$value"),
        onPressed: () => setState(() => input = value),
      );

  Widget _buildButtons() => Row(
        children: <Widget>[
          Expanded(
            child: _buildButton(''),
          ),
          Expanded(
            child: _buildButton(
              'https://www.w3schools.com/html/mov_bbb.mp4',
            ),
          ),
        ],
      );

  Widget _buildAspectRatioTester() => input.length > 0
      ? AspectRatioTester(
          child: VideoPlayer(
            input,
            aspectRatio: 1,
            autoResize: true,
          ),
          key: ValueKey(input),
          resultKey: ValueKey('output'),
        )
      : widget0;
}
