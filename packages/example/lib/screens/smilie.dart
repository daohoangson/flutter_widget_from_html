import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

const kHtml = """
<p>Hello <img class="smilie smilie-1" alt=":)" src="http://domain.com/sprites.png" />!</p>
<p>How are you <img class="smilie smilie-2" alt=":P" src="http://domain.com/sprites.png" />?
""";

const kSmilies = {':)': '🙂'};

class SmilieScreen extends StatelessWidget {
  final smilieOp = BuildOp(
    onPieces: (meta, pieces) {
      final alt = meta.domElement.attributes['alt'];
      final text = kSmilies.containsKey(alt) ? kSmilies[alt] : alt;
      return pieces..first?.block?.addText(text);
    },
  );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('SmilieScreen'),
        ),
        body: HtmlWidget(
          kHtml,
          builderCallback: (meta, e) => e.classes.contains('smilie')
              ? lazySet(null, buildOp: smilieOp)
              : meta,
        ),
      );
}
