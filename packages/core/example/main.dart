import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Widget from HTML (core)',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Widget from HTML (core)'),
        ),
        body: const Center(
          child: HtmlWidget('Hello World!'),
        ),
      ),
    );
  }
}
