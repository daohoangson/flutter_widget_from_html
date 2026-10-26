import 'package:fintel_fwfh_cached_network_image/fwfh_cached_network_image.dart';
import 'package:fintel_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
            '<img src="https://raw.githubusercontent.com/daohoangson/flutter_widget_from_html/0000998/demo_app/logos/icon.png" />',
            factoryBuilder: () => MyWidgetFactory(),
          ),
        ),
      ),
    );
  }
}

class MyWidgetFactory extends WidgetFactory with CachedNetworkImageFactory {}
