import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fwfh_url_launcher/fwfh_url_launcher.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'fwfh_url_launcher',
      home: Scaffold(
        appBar: AppBar(
          title: Text('UrlLauncherFactory Demo'),
        ),
        body: Center(
          child: HtmlWidget(
            '<a href="https://flutter.dev">Launch URL</a>',
            factoryBuilder: () => MyWidgetFactory(),
          ),
        ),
      ),
    );
  }
}

class MyWidgetFactory extends WidgetFactory with UrlLauncherFactory {}
