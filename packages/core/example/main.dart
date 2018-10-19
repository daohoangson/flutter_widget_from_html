import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Widget from HTML (core)',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Widget from HTML (core)'),
        ),
        body: Center(
          child: HtmlWidget('Hello World!'),
        ),
      ),
    );
  }
}
