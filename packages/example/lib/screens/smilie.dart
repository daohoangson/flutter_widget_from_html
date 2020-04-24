import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

const kHtml = """
<p>Hello <img class="smilie smilie-1" alt=":)" src="http://domain.com/sprites.png" />!</p>
<p>How are you <img class="smilie smilie-2" alt=":P" src="http://domain.com/sprites.png" />?
""";

const kSmilies = {':)': '🙂'};

class SmilieScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('SmilieScreen'),
        ),
        body: HtmlWidget(
          kHtml,
          factoryBuilder: (config) => _SmiliesWidgetFactory(config),
        ),
      );
}

class _SmiliesWidgetFactory extends WidgetFactory {
  final smilieOp = BuildOp(
    onPieces: (meta, pieces) {
      final alt = meta.domElement.attributes['alt'];
      final text = kSmilies.containsKey(alt) ? kSmilies[alt] : alt;
      return pieces..first?.text?.addText(text);
    },
  );

  _SmiliesWidgetFactory(HtmlConfig config) : super(config);

  @override
  NodeMetadata parseTag(
    NodeMetadata meta,
    String tag,
    Map<dynamic, String> attributes,
  ) {
    if (tag == 'img' &&
        attributes.containsKey('alt') &&
        attributes.containsKey('class') &&
        attributes['class'].contains('smilie')) {
      return lazySet(null, buildOp: smilieOp);
    }

    return super.parseTag(meta, tag, attributes);
  }
}
