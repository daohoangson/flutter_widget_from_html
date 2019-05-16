part of '../core_widget_factory.dart';

const kTagOrderedList = 'ol';
const kTagUnorderedList = 'ul';
const kCssListStyleType = 'list-style-type';
const kCssListStyleTypeCircle = 'circle';
const kCssListStyleTypeDecimal = 'decimal';
const kCssListStyleTypeDisc = 'disc';
const kCssListStyleTypeSquare = 'square';

const _kCssPaddingLeft = 'padding-left';

class _TagLi {
  final WidgetFactory wf;

  BuildOp _buildOp;
  BuildOp _liOp;

  _TagLi(this.wf);

  BuildOp get buildOp {
    _buildOp ??= BuildOp(
      defaultStyles: (meta, e) {
        final p = meta.parents?.where((op) => op == _buildOp)?.length ?? 0;

        final styles = [
          _kCssPaddingLeft,
          '2.5em',
          kCssListStyleType,
          e.localName == kTagOrderedList
              ? kCssListStyleTypeDecimal
              : p == 0
                  ? kCssListStyleTypeDisc
                  : p == 1 ? kCssListStyleTypeCircle : kCssListStyleTypeSquare,
        ];

        if (p == 0) styles.addAll([kCssMargin, '1em 0']);

        return styles;
      },
      onChild: (meta, e) =>
          e.localName == 'li' ? lazySet(meta, buildOp: liOp) : meta,
      onWidgets: (meta, widgets) => _buildList(meta, widgets),
    );
    return _buildOp;
  }

  BuildOp get liOp {
    _liOp ??= BuildOp(
      onWidgets: (_, widgets) => [_buildItem(widgets)],
    );
    return _liOp;
  }

  Widget _buildItem(Iterable<Widget> widgets) => wf.buildColumn(widgets);

  Iterable<Widget> _buildList(NodeMetadata meta, Iterable<Widget> children) {
    String listStyleType = kCssListStyleTypeDisc;
    double paddingLeft;
    meta.styles((key, value) {
      switch (key) {
        case kCssListStyleType:
          listStyleType = value;
          break;
        case _kCssPaddingLeft:
          final parsed = lengthParseValue(value)?.getValue(meta.textStyle);
          paddingLeft = parsed ?? paddingLeft;
      }
    });

    int i = 0;
    return children.map(
      (widget) => Stack(
            children: <Widget>[
              _buildBody(widget, paddingLeft),
              _buildMarker(
                wf.getListStyleMarker(listStyleType, ++i),
                meta.textStyle,
                paddingLeft,
              ),
            ],
          ),
    );
  }

  Widget _buildBody(Widget widget, double paddingLeft) => Padding(
        padding: EdgeInsets.only(left: paddingLeft),
        child: widget,
      );

  Widget _buildMarker(String text, TextStyle style, double paddingLeft) =>
      Positioned(
        left: 0.0,
        top: 0.0,
        width: paddingLeft * .75,
        child: RichText(
          maxLines: 1,
          overflow: TextOverflow.clip,
          text: TextSpan(style: style, text: text),
          textAlign: TextAlign.right,
        ),
      );
}
