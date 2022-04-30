import 'package:demo_app/screens/hello_world.dart' as enhanced;
import 'package:demo_app/widgets/popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

class HelloWorldCoreScreen extends StatelessWidget {
  const HelloWorldCoreScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('HelloWorldCoreScreen'),
          actions: const [
            PopupMenu(
              scrollToTop: true,
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: HtmlWidget(
              enhanced.kHtml,
              key: context.key,
            ),
          ),
        ),
      );
}
