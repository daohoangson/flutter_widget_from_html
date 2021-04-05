import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fwfh_webview/fwfh_webview.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'fwfh_webview',
      home: Scaffold(
        appBar: AppBar(
          title: Text('WebViewFactory Demo'),
        ),
        body: Center(
          child: HtmlWidget(
            '<iframe src="https://www.youtube.com/embed/jNQXAC9IVRw"></iframe>',
            factoryBuilder: () => MyWidgetFactory(),
          ),
        ),
      ),
    );
  }
}

class MyWidgetFactory extends WidgetFactory with WebViewFactory {}
