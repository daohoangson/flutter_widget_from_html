part of '../core_widget_factory.dart';

const kTagOrderedList = 'ol';
const kTagUnorderedList = 'ul';
const kCssListStyleType = 'list-style-type';
const kCssListStyleTypeCircle = 'circle';
const kCssListStyleTypeDecimal = 'decimal';
const kCssListStyleTypeDisc = 'disc';

const _kCssPaddingLeft = 'padding-left';
const _kCssPaddingLeftDefault = 40.0;

class TagLi {
  final WidgetFactory wf;

  BuildOp _buildOp;
  BuildOp _liOp;

  TagLi(this.wf);

  BuildOp get buildOp {
    _buildOp ??= BuildOp(
      defaultStyles: (meta, e) {
        var parents = 0;
        meta.parents((op) => op == _buildOp ? parents++ : null);

        final styles = [
          _kCssPaddingLeft,
          '${_kCssPaddingLeftDefault}px',
          kCssListStyleType,
          e.localName == kTagOrderedList
              ? kCssListStyleTypeDecimal
              : parents == 0 ? kCssListStyleTypeDisc : kCssListStyleTypeCircle,
        ];

        if (parents == 0) styles.addAll([kCssMargin, '1em 0']);

        return styles;
      },
      onChild: (meta) => meta.domElement.localName == 'li'
          ? lazySet(meta, buildOp: liOp)
          : null,
      onWidgets: (meta, widgets) => _buildList(meta, widgets),
    );
    return _buildOp;
  }

  BuildOp get liOp {
    _liOp ??= BuildOp(
      onWidgets: (_, widgets) => _buildItem(widgets),
    );
    return _liOp;
  }

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
