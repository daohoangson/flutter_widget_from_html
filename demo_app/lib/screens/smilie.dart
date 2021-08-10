import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

const kHtml = '''
<p>Hello <img class="smilie smilie-1" alt=":)" src="http://domain.com/sprites.png" />!</p>
<p>How are you <img class="smilie smilie-2" alt=":P" src="http://domain.com/sprites.png" />?
''';

const kSmilies = {':)': '🙂'};

class SmilieScreen extends StatelessWidget {
  const SmilieScreen({Key key}) : super(key: key);

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
    onTree: (meta, tree) {
      final alt = meta.element.attributes['alt'];
      tree.addText(kSmilies[alt] ?? alt);
    },
  );

  @override
  void parse(BuildMetadata meta) {
    final e = meta.element;
    if (e.localName == 'img' &&
        e.classes.contains('smilie') &&
        e.attributes.containsKey('alt')) {
      meta.register(smilieOp);
      return;
    }

    return super.parse(meta);
  }
}
