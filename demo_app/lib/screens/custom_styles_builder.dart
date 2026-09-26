import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:material_ui/material_ui.dart';

const kHtml = 'Hello <span class="name">World</span>!';

class CustomStylesBuilderScreen extends StatelessWidget {
  const CustomStylesBuilderScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('CustomStylesBuilderScreen'),
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
