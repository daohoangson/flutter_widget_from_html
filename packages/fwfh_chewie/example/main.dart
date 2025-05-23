import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fwfh_chewie/fwfh_chewie.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'fwfh_chewie',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('ChewieFactory Demo'),
        ),
        body: Center(
          child: HtmlWidget(
            '''
<video controls width="250">
  <source src="https://flutter-widget-from-html.github.io/pages/flower.mp4" type="video/mp4">
  <code>VIDEO</code> support is not enabled.
</video>''',
            factoryBuilder: () => MyWidgetFactory(),
          ),
        ),
      ),
    );
  }
}

class MyWidgetFactory extends WidgetFactory with ChewieFactory {}
