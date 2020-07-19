import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Widget from HTML',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Widget from HTML'),
        ),
        body: Center(
          child: HtmlWidget('Hello World!'),
        ),
      ),
    );
  }
}
