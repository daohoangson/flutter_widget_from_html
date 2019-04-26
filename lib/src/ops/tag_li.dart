part of '../widget_factory.dart';

const kTagListItem = 'li';
const kTagOrderedList = 'ol';
const kTagUnorderedList = 'ul';

class TagLi {
  final WidgetFactory wf;

  TagLi(this.wf);

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
                    : tag == kTagUnorderedList ? wf.config.listBullet : '',
              ),
            ]))
        .toList());
  }

  Widget _buildBody(Widget widget) => Padding(
        padding: EdgeInsets.only(left: wf.config.listMarkerWidth),
        child: widget,
      );

  Widget _buildMarker(String text) => Positioned(
        left: 0.0,
        top: 0.0,
        width: wf.config.listMarkerWidth,
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
          EdgeInsets.only(
            top: wf.config.listMarkerPaddingTop ??
                wf.config.textPadding?.top ??
                0.0,
          ),
        ),
      );
}
