part of '../core_wf.dart';

const kTagListItem = 'li';
const kTagOrderedList = 'ol';
const kTagUnorderedList = 'ul';
const kCssListStyleType = 'list-style-type';
const kCssListStyleTypeDecimal = 'decimal';
const kCssListStyleTypeDisc = 'disc';

const _kCssPaddingLeft = 'padding-left';
const _kCssPaddingLeftDefault = 40.0;

class TagLi {
  final key = ValueKey('TagLi');
  final WidgetFactory wf;

  TagLi(this.wf);

  BuildOp get buildOp => BuildOp(
        getInlineStyles: (meta, e) {
          if (e.localName == kTagListItem) return null;

          var isWithinAnotherList = false;
          meta.keys((k) => k == key ? isWithinAnotherList = true : null);

          return [
            'margin',
            isWithinAnotherList ? '0' : '1em 0',
            _kCssPaddingLeft,
            '${_kCssPaddingLeftDefault}px',
            kCssListStyleType,
            e.localName == kTagOrderedList
                ? kCssListStyleTypeDecimal
                : kCssListStyleTypeDisc,
          ];
        },
        collectMetadata: (meta) => meta.buildOpElement.localName == kTagListItem
            ? null
            : lazySet(meta, key: key),
        onWidgets: (meta, widgets) =>
            meta.buildOpElement.localName == kTagListItem
                ? _buildItem(widgets)
                : _buildList(meta, widgets),
      );

  Widget _buildItem(Iterable<Widget> widgets) => wf.buildColumn(widgets);

  Widget _buildList(NodeMetadata meta, Iterable<Widget> children) {
    String listStyleType = kCssListStyleTypeDisc;
    double paddingLeft = _kCssPaddingLeftDefault;
    meta.styles((key, value) {
      switch (key) {
        case kCssListStyleType:
          listStyleType = value;
          break;
        case _kCssPaddingLeft:
          final parsed = parser.lengthParseValue(value);
          paddingLeft = parsed?.getValue(meta.buildOpTextStyle) ??
              _kCssPaddingLeftDefault;
      }
    });

    int i = 0;
    return wf.buildColumn(children
        .map((widget) => Stack(children: <Widget>[
              _buildBody(widget, paddingLeft),
              _buildMarker(
                wf.getListStyleMarker(listStyleType, ++i),
                paddingLeft,
              ),
            ]))
        .toList());
  }

  Widget _buildBody(Widget widget, double paddingLeft) => Padding(
        padding: EdgeInsets.only(left: paddingLeft),
        child: widget,
      );

  Widget _buildMarker(String text, double paddingLeft) => Positioned(
        left: 0.0,
        top: 0.0,
        width: paddingLeft * .8,
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.clip,
          textAlign: TextAlign.right,
        ),
      );
}
