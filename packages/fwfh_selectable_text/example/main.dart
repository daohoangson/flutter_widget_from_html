import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fwfh_selectable_text/fwfh_selectable_text.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'fwfh_selectable_text',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('SelectableTextFactory Demo'),
        ),
        body: Center(
          child: HtmlWidget(
            'Hello, <strong style="color: red">World</strong>!',
            factoryBuilder: () => MyWidgetFactory(),
          ),
        ),
      ),
    );
  }
}

class MyWidgetFactory extends WidgetFactory with SelectableTextFactory {}
