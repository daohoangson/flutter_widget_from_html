import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart'
    show BuildOp;

import '../widget_factory.dart';

const kTagListItem = 'li';
const kTagOrderedList = 'ol';
const kTagUnorderedList = 'ul';

class TagLi {
  final WidgetFactory wf;

  BuildOp _buildOp;

  TagLi(this.wf);

  String get bullet => '•';
  double get markerPaddingTop => wf.config.textPadding?.top ?? 0.0;
  double get markerWidth => 30.0;

  BuildOp get buildOp {
    _buildOp ??= BuildOp(
      onWidgets: (meta, w) => build(w, meta.buildOpElement.localName),
    );
    return _buildOp;
  }

  Widget build(List<Widget> children, String tag) {
    if (tag == kTagListItem) return wf.buildColumn(children);

    int i = 0;
    final List<Stack> stacks = List(children.length);
    for (final widget in children) {
      stacks[i] = Stack(
        children: <Widget>[
          buildBody(widget),
          buildMarker(tag == kTagOrderedList
              ? "${i + 1}."
              : tag == kTagUnorderedList ? bullet : ''),
        ],
      );

      i++;
    }

    return wf.buildColumn(stacks);
  }

  Widget buildBody(Widget widget) => Padding(
        padding: EdgeInsets.only(left: markerWidth),
        child: widget,
      );

  Widget buildMarker(String text) => Positioned(
        left: 0.0,
        top: 0.0,
        width: markerWidth,
        child: wf.buildPadding(
          Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.clip,
            style: DefaultTextStyle.of(wf.context).style.copyWith(
                  color: Theme.of(wf.context).disabledColor,
                ),
            textAlign: TextAlign.right,
          ),
          EdgeInsets.only(top: markerPaddingTop),
        ),
      );
}
