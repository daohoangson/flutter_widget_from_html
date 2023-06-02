import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fwfh_cached_network_image/fwfh_cached_network_image.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'fwfh_cached_network_image',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('CachedNetworkImageFactory Demo'),
        ),
        body: Center(
          child: HtmlWidget(
            '<img src="https://github.com/daohoangson/flutter_widget_from_html/raw/master/demo_app/logos/android.png" />',
            factoryBuilder: () => MyWidgetFactory(),
          ),
        ),
      ),
    );
  }
}

class MyWidgetFactory extends WidgetFactory with CachedNetworkImageFactory {}
