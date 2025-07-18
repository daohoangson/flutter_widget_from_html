import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

const kHtml = '''
<p>Hello <img class="smilie smilie-1" alt=":)" src="http://domain.com/sprites.png" />!</p>
<p>How are you <img class="smilie smilie-2" alt=":P" src="http://domain.com/sprites.png" />?
''';

const kSmilies = {':)': '🙂'};

class SmilieScreen extends StatelessWidget {
  const SmilieScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('SmilieScreen'),
    ),
    body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: HtmlWidget(
        kHtml,
        factoryBuilder: () => _SmiliesWidgetFactory(),
      ),
    ),
  );
}

class _SmiliesWidgetFactory extends WidgetFactory {
  final smilieOp = BuildOp(
    debugLabel: 'smilie',
    onParsed: (tree) {
      final alt = tree.element.attributes['alt'];
      return tree..addText(kSmilies[alt] ?? alt ?? '');
    },
  );

  @override
  void parse(BuildTree tree) {
    final e = tree.element;
    if (e.localName == 'img' &&
        e.classes.contains('smilie') &&
        e.attributes.containsKey('alt')) {
      tree.register(smilieOp);
      return;
    }

    return super.parse(tree);
  }
}
