import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:html/dom.dart' as dom;

class SmilieScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('SmilieScreen'),
        ),
        body: HtmlWidget(
          '<p>Hello <img class="smilie smilie-1" alt=":)" src="http://domain.com/sprites.png" />!</p>' +
              '<p>How are you <img class="smilie smilie-2" alt=":P" src="http://domain.com/sprites.png" />?',
          wfBuilder: (context) => SmilieWf(context),
        ),
      );
}

const _kSmilies = {':)': '🙂'};

class SmilieWf extends WidgetFactory {
  SmilieWf(BuildContext context) : super(context);

  @override
  NodeMetadata parseElement(NodeMetadata meta, dom.Element e) {
    if (e.classes.contains('smilie') && e.attributes.containsKey('alt')) {
      final alt = e.attributes['alt'];
      // render alt text if mapping not found
      // because inline image is not supported
      final text = _kSmilies.containsKey(alt) ? _kSmilies[alt] : alt;
      return lazySet(null,
          buildOp: BuildOp(
            onPieces: (_, __) => <BuiltPiece>[BuiltPieceSimple(text: text)],
          ));
    }

    return super.parseElement(meta, e);
  }
}
