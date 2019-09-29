part of '../core_widget_factory.dart';

const kTagOrderedList = 'ol';
const kTagUnorderedList = 'ul';
const kCssListStyleType = 'list-style-type';
const kCssListStyleTypeAlphaLower = 'lower-alpha';
const kCssListStyleTypeAlphaUpper = 'upper-alpha';
const kCssListStyleTypeAlphaLatinLower = 'lower-latin';
const kCssListStyleTypeAlphaLatinUpper = 'upper-latin';
const kCssListStyleTypeCircle = 'circle';
const kCssListStyleTypeDecimal = 'decimal';
const kCssListStyleTypeDisc = 'disc';
const kCssListStyleTypeRomanLower = 'lower-roman';
const kCssListStyleTypeRomanUpper = 'upper-roman';
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
              ? (e.attributes.containsKey('type')
                      ? _LiInput.listStyleTypeFromAttributeType(
                          e.attributes['type'])
                      : null) ??
                  kCssListStyleTypeDecimal
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
      onWidgets: (meta, widgets) =>
          widgets.length == 1 && widgets.first is _LiPlaceholder
              ? widgets
              : [_placeholder(widgets, meta)],
    );
    return _liOp;
  }

  Iterable<Widget> _build(BuildContext c, Iterable<Widget> ws, _LiInput i) {
    final style = i.meta.textStyle(c);
    final paddingLeftPx = i.paddingLeft.getValue(style);
    final padding = EdgeInsets.only(left: paddingLeftPx);
    final markerText = wf.getListStyleMarker(i.listStyleType, i.markerIndex);

    return [
      Stack(children: <Widget>[
        wf.buildPadding(wf.buildColumn(ws), padding),
        _buildMarker(c, style, markerText, paddingLeftPx),
      ]),
    ];
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
    for (final child in children) {
      if (!(child is _LiPlaceholder)) continue;
      final item = child as _LiPlaceholder;
      item.input.depth++;

      if (item.input.depth > 1) {
        item.wrapWith((context, widgets, __) {
          final style = meta.textStyle(context);
          final paddingLeftPx = paddingLeft.getValue(style);
          final padding = EdgeInsets.only(left: paddingLeftPx);

          return widgets.map((widget) => wf.buildPadding(widget, padding));
        });
        continue;
      }

      item.input.markerIndex = ++i;
      item.input.listStyleType ??= listStyleType;
      item.input.paddingLeft ??= paddingLeft;
    }

    return children;
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

  _LiPlaceholder _placeholder(Iterable<Widget> children, NodeMetadata meta) {
    final a = meta.domElement.attributes;
    String listStyleType = a.containsKey('type')
        ? _LiInput.listStyleTypeFromAttributeType(a['type'])
        : null;
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

    return _LiPlaceholder(
      this,
      children,
      _LiInput()
        ..listStyleType = listStyleType
        ..meta = meta
        ..paddingLeft = paddingLeft
        ..wf = wf,
    );
  }
}

class _LiPlaceholder extends WidgetPlaceholder<_LiInput> {
  final _LiInput input;

  _LiPlaceholder(
    _TagLi self,
    Iterable<Widget> children,
    this.input,
  ) : super(
          builder: self._build,
          children: children,
          input: input,
          wf: input.wf,
        );
}

class _LiInput {
  int depth = 0;
  String listStyleType;
  int markerIndex;
  NodeMetadata meta;
  CssLength paddingLeft;
  WidgetFactory wf;

  static String listStyleTypeFromAttributeType(String type) {
    switch (type) {
      case 'a':
        return kCssListStyleTypeAlphaLower;
      case 'A':
        return kCssListStyleTypeAlphaUpper;
      case 'i':
        return kCssListStyleTypeRomanLower;
      case 'I':
        return kCssListStyleTypeRomanUpper;
      case '1':
        return kCssListStyleTypeDecimal;
    }

    return null;
  }
}
