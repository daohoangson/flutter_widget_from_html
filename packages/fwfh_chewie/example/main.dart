import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fwfh_chewie/fwfh_chewie.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
<video controls width="320" height="176">
  <source src="https://www.w3schools.com/html/mov_bbb.mp4" type="video/mp4">
  <source src="https://www.w3schools.com/html/mov_bbb.ogg" type="video/ogg">
  Your browser does not support HTML5 video.
</video>''',
            factoryBuilder: () => MyWidgetFactory(),
          ),
        ),
      ),
    );
  }
}

class MyWidgetFactory extends WidgetFactory with ChewieFactory {}
