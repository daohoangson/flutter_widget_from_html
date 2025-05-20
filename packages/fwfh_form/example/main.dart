import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fwfh_form/fwfh_form.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'fwfh_form',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('FormFactory Demo'),
        ),
        body: Center(
          child: HtmlWidget(
            '<form><input placeholder="Your name"><button type="submit">Submit</button></form>',
            factoryBuilder: () => MyWidgetFactory(),
          ),
        ),
      ),
    );
  }
}

class MyWidgetFactory extends WidgetFactory with FormFactory {}
