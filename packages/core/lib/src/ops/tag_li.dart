part of '../core_widget_factory.dart';

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
        defaultStyles: (meta, e) {
          if (e.localName == kTagListItem) return null;

          var isWithinAnotherList = false;
          meta.keys((k) => k == key ? isWithinAnotherList = true : null);

          return [
            kCssMargin,
            isWithinAnotherList ? '0' : '1em 0',
            _kCssPaddingLeft,
            '${_kCssPaddingLeftDefault}px',
            kCssListStyleType,
            e.localName == kTagOrderedList
                ? kCssListStyleTypeDecimal
                : kCssListStyleTypeDisc,
          ];
        },
        onMetadata: (meta) => meta.domElement.localName == kTagListItem
            ? null
            : lazySet(meta, key: key),
        onWidgets: (meta, widgets) => meta.domElement.localName == kTagListItem
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
          final parsed = lengthParseValue(value);
          paddingLeft =
              parsed?.getValue(meta.textStyle) ?? _kCssPaddingLeftDefault;
      }
    });

    int i = 0;
    return wf.buildColumn(children
        .map((widget) => Stack(children: <Widget>[
              _buildBody(widget, paddingLeft),
              _buildMarker(
                wf.getListStyleMarker(listStyleType, ++i),
                meta.textStyle,
                paddingLeft,
              ),
            ]))
        .toList());
  }

  Widget _buildBody(Widget widget, double paddingLeft) => Padding(
        padding: EdgeInsets.only(left: paddingLeft),
        child: widget,
      );

  Widget _buildMarker(String text, TextStyle style, double paddingLeft) =>
      Positioned(
        left: 0.0,
        top: 0.0,
        width: paddingLeft * .8,
        child: RichText(
          maxLines: 1,
          overflow: TextOverflow.clip,
          text: TextSpan(style: style, text: text),
          textAlign: TextAlign.right,
        ),
      );
}
