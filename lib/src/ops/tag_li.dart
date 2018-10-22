import 'package:flutter/material.dart';

import '../widget_factory.dart';

class TagLi {
  final WidgetFactory wf;
  final List<Key> itemKeys = List();

  TagLi(this.wf);

  double get paddingLeft => 30.0;
  EdgeInsets get paddingText => wf.config.textPadding;
  String get bullet => '•';

  Widget build(List<Widget> children, String tag) {
    if (tag == 'li') {
      final item = wf.buildColumn(children);
      itemKeys.add(item.key);
      return item;
    }

    int i = 0;
    final List<Stack> stacks = List(children.length);
    for (final widget in children) {
      stacks[i] = Stack(
        children: <Widget>[
          buildBody(widget),
          buildMarker(tag == 'ol' ? "${i + 1}." : bullet),
        ],
      );

      i++;
    }

    return wf.buildColumn(stacks);
  }

  Widget buildBody(Widget widget) => Padding(
        padding: EdgeInsets.only(left: paddingLeft),
        child: widget,
      );

  Widget buildMarker(String text) {
    final marker = LayoutBuilder(
      builder: (context, bc) => Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.clip,
            style: DefaultTextStyle.of(context).style.copyWith(
                  color: Theme.of(context).disabledColor,
                ),
            textAlign: TextAlign.right,
          ),
    );

    return Positioned(
      left: 0.0,
      top: 0.0,
      width: paddingLeft,
      child: paddingText?.top != null
          ? Padding(
              padding: EdgeInsets.only(top: paddingText.top),
              child: marker,
            )
          : marker,
    );
  }
}
