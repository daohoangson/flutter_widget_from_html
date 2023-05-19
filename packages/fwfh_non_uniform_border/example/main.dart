import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fwfh_non_uniform_border/fwfh_non_uniform_border.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'fwfh_non_uniform_border',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('NonUniformBorderFactory Demo'),
        ),
        body: Center(
          child: HtmlWidget(
            // TODO: write example
            '',
            factoryBuilder: () => MyWidgetFactory(),
          ),
        ),
      ),
    );
  }
}

class MyWidgetFactory extends WidgetFactory with NonUniformBorderFactory {}
