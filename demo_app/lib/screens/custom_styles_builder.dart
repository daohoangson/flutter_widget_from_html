import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

const kHtml = 'Hello <span class="name">World</span>!';

class CustomStylesBuilderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('CustomStylesBuilderScreen'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: HtmlWidget(
            kHtml,
            customStylesBuilder: (e) =>
                e.classes.contains('name') ? {'color': 'red'} : null,
          ),
        ),
      );
}
