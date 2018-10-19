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
  NodeMetadata collectMetadata(dom.Element e) {
    var meta = super.collectMetadata(e);

    if (e.classes.contains('smilie')) {
      meta = lazySet(meta, display: DisplayType.Inline);

      final alt = e.attributes['alt'];
      if (_kSmilies.containsKey(alt)) {
        meta = lazyAddNode(meta, text: _kSmilies[alt]);
      } else {
        // render alt text if mapping not found
        // because inline image is not supported
        meta = lazyAddNode(meta, text: alt);
      }
    }

    return meta;
  }
}
