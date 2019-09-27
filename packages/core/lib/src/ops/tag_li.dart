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
      onWidgets: (_, widgets) => [wf.buildColumn(widgets)],
    );
    return _liOp;
  }

  Iterable<Widget> _buildList(NodeMetadata meta, Iterable<Widget> children) {
    String listStyleType = kCssListStyleTypeDisc;
    CssLength paddingLeft;
    meta.styles((key, value) {
      switch (key) {
        case kCssListStyleType:
          listStyleType = value;
          break;
        case _kCssPaddingLeft:
          final parsed = parseCssLength(value);
          if (parsed != null) paddingLeft = parsed;
      }
    });

    int i = 0;
    return children.map(
      (widget) {
        if (widget is _TagLiPlaceholder) {
          return widget
            ..wrapWith((context, widgets, __) {
              final style = meta.textStyle(context);
              final paddingLeftPx = paddingLeft.getValue(style);
              final padding = EdgeInsets.only(left: paddingLeftPx);

              return widgets.map((widget) => wf.buildPadding(widget, padding));
            });
        }

        final markerText = wf.getListStyleMarker(listStyleType, ++i);

        return _TagLiPlaceholder(
          builder: (context, _, __) {
            final style = meta.textStyle(context);
            final paddingLeftPx = paddingLeft.getValue(style);

            return [
              Stack(children: <Widget>[
                wf.buildPadding(widget, EdgeInsets.only(left: paddingLeftPx)),
                _buildMarker(context, style, markerText, paddingLeftPx),
              ]),
            ];
          },
          wf: wf,
        );
      },
    );
  }

  Widget _buildMarker(BuildContext c, TextStyle s, String t, double l) =>
      Positioned(
        left: 0.0,
        top: 0.0,
        width: l * .75,
        child: RichText(
          maxLines: 1,
          overflow: TextOverflow.clip,
          text: TextSpan(style: s, text: t),
          textAlign: TextAlign.right,
          textScaleFactor: MediaQuery.of(c).textScaleFactor,
        ),
      );
}

class _TagLiPlaceholder extends WidgetPlaceholder {
  _TagLiPlaceholder({
    WidgetPlaceholderBuilder builder,
    WidgetFactory wf,
  }) : super(builder: builder, wf: wf);
}
