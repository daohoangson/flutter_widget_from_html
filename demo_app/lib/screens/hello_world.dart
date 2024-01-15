import 'package:demo_app/widgets/popup_menu.dart';
import 'package:demo_app/widgets/selection_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

// <p style="text-transform: uppercase;">Heading 1</p>
// <h2 style="text-transform: uppercase;">Heading 2</h2>
// <b style="text-transform: uppercase;">Heading 3</b>
// <br>
const kHtml = '''
<abbr style="text-transform: uppercase;">Heading 4</abbr>
''';

// const kHtml = '''
// <p style="text-transform: uppercase;">Heading 1</p>
// ''';

class HelloWorldScreen extends StatelessWidget {
  const HelloWorldScreen({super.key});

  @override
  Widget build(BuildContext context) => SelectionAreaScaffold(
        appBar: AppBar(
          title: const Text('HelloWorldScreen'),
          actions: const [
            PopupMenu(
              scrollToTop: true,
              toggleIsSelectable: true,
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: HtmlWidget(kHtml, key: context.key),
          ),
        ),
      );
}
