import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fwfh_svg/fwfh_svg.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'fwfh_svg',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('SvgFactory Demo'),
        ),
        body: Center(
          child: HtmlWidget(
            '<img src="https://raw.githubusercontent.com/dnfield/flutter_svg/master/example/assets/flutter_logo.svg" />',
            factoryBuilder: () => MyWidgetFactory(),
          ),
        ),
      ),
    );
  }
}

class MyWidgetFactory extends WidgetFactory with SvgFactory {}
