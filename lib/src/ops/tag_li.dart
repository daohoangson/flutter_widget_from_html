import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart'
    show BuildOp;

import '../widget_factory.dart';

const kTagListItem = 'li';
const kTagOrderedList = 'ol';
const kTagUnorderedList = 'ul';

class TagLi {
  final WidgetFactory wf;

  TagLi(this.wf);

  String get bullet => wf.config.liBullet;
  double get markerPaddingTop =>
      wf.config.liMarkerPaddingTop ?? wf.config.textPadding?.top ?? 0.0;
  double get markerWidth => wf.config.liMarkerWidth;

  BuildOp get buildOp =>
      BuildOp(onWidgets: (meta, w) => build(w, meta.buildOpElement.localName));

  Widget build(Iterable<Widget> children, String tag) {
    if (tag == kTagListItem) return wf.buildColumn(children);

    int i = 0;
    return wf.buildColumn(children
        .map((widget) => Stack(children: <Widget>[
              _buildBody(widget),
              _buildMarker(
                tag == kTagOrderedList
                    ? "${++i}."
                    : tag == kTagUnorderedList ? bullet : '',
              ),
            ]))
        .toList());
  }

  Widget _buildBody(Widget widget) => Padding(
        padding: EdgeInsets.only(left: markerWidth),
        child: widget,
      );

  Widget _buildMarker(String text) => Positioned(
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
