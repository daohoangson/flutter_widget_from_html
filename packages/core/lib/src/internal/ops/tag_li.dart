part of '../core_ops.dart';

const kTagLi = 'li';
const kTagOrderedList = 'ol';
const kTagUnorderedList = 'ul';
const kAttributeLiType = 'type';
const kAttributeLiTypeAlphaLower = 'a';
const kAttributeLiTypeAlphaUpper = 'A';
const kAttributeLiTypeDecimal = '1';
const kAttributeLiTypeRomanLower = 'i';
const kAttributeLiTypeRomanUpper = 'I';
const kAttributeOlReversed = 'reversed';
const kAttributeOlStart = 'start';
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

class TagLi {
  final BuildMetadata listMeta;
  final WidgetFactory wf;

  final _itemMetas = <BuildMetadata>[];
  final _itemWidgets = <WidgetPlaceholder>[];

  _ListConfig _config;
  BuildOp _itemOp;
  BuildOp _listOp;

  TagLi(this.wf, this.listMeta);

  _ListConfig get config {
    // cannot build config from constructor because
    // inline styles are not fully parsed at that time
    _config ??= _ListConfig.fromBuildMetadata(listMeta);
    return _config;
  }

  BuildOp get op {
    _listOp ??= _TagLiListOp(this);
    return _listOp;
  }

  Map<String, String> defaultStyles(dom.Element element) {
    final attrs = element.attributes;
    final depth = listMeta.parentOps?.whereType<_TagLiListOp>()?.length ?? 0;

    final styles = {
      'padding-inline-start': '40px',
      kCssListStyleType: element.localName == kTagOrderedList
          ? _ListConfig.listStyleTypeFromAttributeType(
                  attrs[kAttributeLiType]) ??
              kCssListStyleTypeDecimal
          : depth == 0
              ? kCssListStyleTypeDisc
              : depth == 1
                  ? kCssListStyleTypeCircle
                  : kCssListStyleTypeSquare,
    };

    if (depth == 0) styles[kCssMargin] = '1em 0';

    return styles;
  }

  void onChild(BuildMetadata childMeta) {
    final e = childMeta.element;
    if (e.localName != kTagLi) return;
    if (e.parent != listMeta.element) return;

    _itemOp ??= BuildOp(
      onWidgets: (itemMeta, widgets) {
        final column = wf.buildColumnPlaceholder(itemMeta, widgets) ??
            WidgetPlaceholder<BuildMetadata>(itemMeta);

        final i = _itemMetas.length;
        _itemMetas.add(itemMeta);
        _itemWidgets.add(column);
        return [column.wrapWith((c, w) => _buildItem(c, w, i))];
      },
    );

    childMeta.register(_itemOp);
  }

  Widget _buildItem(BuildContext context, Widget child, int i) {
    final meta = _itemMetas[i];
    final listStyleType = _ListConfig.listStyleTypeFromBuildMetadata(meta) ??
        config.listStyleType;
    final markerIndex = config.markerReversed == true
        ? (config.markerStart ?? _itemWidgets.length) - i
        : (config.markerStart ?? 1) + i;
    final tsh = meta.tsb().build(context);

    final markerText = wf.getListStyleMarker(listStyleType, markerIndex);
    final marker = _buildMarker(tsh, listStyleType, markerText);

    return _ListItem(
      child: child,
      marker: marker,
      textDirection: tsh.textDirection,
    );
  }

  Widget _buildMarker(TextStyleHtml tsh, String type, String text) {
    final style = tsh.styleWithHeight;
    return text?.isNotEmpty == true
        ? RichText(
            maxLines: 1,
            overflow: TextOverflow.clip,
            softWrap: false,
            text: TextSpan(style: style, text: text),
            textDirection: tsh.textDirection,
          )
        : type == kCssListStyleTypeCircle
            ? _ListMarkerCircle(style)
            : type == kCssListStyleTypeSquare
                ? _ListMarkerSquare(style)
                : _ListMarkerDisc(style);
  }
}

@immutable
class _ListConfig {
  final String listStyleType;
  final bool markerReversed;
  final int markerStart;

  _ListConfig({
    this.listStyleType,
    this.markerReversed,
    this.markerStart,
  });

  factory _ListConfig.fromBuildMetadata(BuildMetadata meta) {
    final attrs = meta.element.attributes;

    return _ListConfig(
      listStyleType: meta[kCssListStyleType] ?? kCssListStyleTypeDisc,
      markerReversed: attrs.containsKey(kAttributeOlReversed),
      markerStart: tryParseIntFromMap(attrs, kAttributeOlStart),
    );
  }

  static String listStyleTypeFromBuildMetadata(BuildMetadata meta) {
    final listStyleType = meta[kCssListStyleType];
    if (listStyleType != null) return listStyleType;

    return listStyleTypeFromAttributeType(
        meta.element.attributes[kAttributeLiType]);
  }

  static String listStyleTypeFromAttributeType(String type) {
    switch (type) {
      case kAttributeLiTypeAlphaLower:
        return kCssListStyleTypeAlphaLower;
      case kAttributeLiTypeAlphaUpper:
        return kCssListStyleTypeAlphaUpper;
      case kAttributeLiTypeDecimal:
        return kCssListStyleTypeDecimal;
      case kAttributeLiTypeRomanLower:
        return kCssListStyleTypeRomanLower;
      case kAttributeLiTypeRomanUpper:
        return kCssListStyleTypeRomanUpper;
    }

    return null;
  }
}

class _ListItem extends MultiChildRenderObjectWidget {
  static const kGap = 5.0;

  final TextDirection textDirection;

  _ListItem({
    Widget child,
    Key key,
    Widget marker,
    this.textDirection,
  }) : super(children: [child, marker], key: key);

  @override
  RenderObject createRenderObject(BuildContext _) =>
      _ListItemRenderObject(textDirection: textDirection);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        DiagnosticsProperty<TextDirection>('textDirection', textDirection));
  }

  @override
  void updateRenderObject(BuildContext _, _ListItemRenderObject renderObject) {
    renderObject.textDirection = textDirection;
  }
}

class _ListItemData extends ContainerBoxParentData<RenderBox> {}

class _ListItemRenderObject extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _ListItemData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _ListItemData> {
  _ListItemRenderObject({
    TextDirection textDirection,
  }) : _textDirection = textDirection;

  TextDirection get textDirection => _textDirection;
  TextDirection _textDirection;
  set textDirection(TextDirection value) {
    if (_textDirection == value) return;
    _textDirection = value;
    markNeedsLayout();
  }

  @override
  double computeDistanceToActualBaseline(TextBaseline baseline) =>
      defaultComputeDistanceToFirstActualBaseline(baseline);

  @override
  double computeMaxIntrinsicHeight(double width) =>
      firstChild.computeMaxIntrinsicHeight(width);

  @override
  double computeMaxIntrinsicWidth(double height) =>
      firstChild.computeMaxIntrinsicWidth(height);

  @override
  double computeMinIntrinsicHeight(double width) =>
      firstChild.computeMinIntrinsicHeight(width);

  @override
  double computeMinIntrinsicWidth(double height) =>
      firstChild.getMinIntrinsicWidth(height);

  @override
  bool hitTestChildren(BoxHitTestResult result, {Offset position}) =>
      defaultHitTestChildren(result, position: position);

  @override
  void paint(PaintingContext context, Offset offset) =>
      defaultPaint(context, offset);

  @override
  void performLayout() {
    final child = firstChild;
    final childConstraints = constraints;
    final childData = child.parentData as _ListItemData;
    child.layout(childConstraints, parentUsesSize: true);
    final childSize = child.size;

    final marker = childData.nextSibling;
    final markerConstraints = childConstraints.loosen();
    final markerData = marker.parentData as _ListItemData;
    marker.layout(markerConstraints, parentUsesSize: true);
    final markerSize = marker.size;

    size = Size(
      childSize.width,
      childSize.height > 0 ? childSize.height : markerSize.height,
    );

    final baseline = TextBaseline.alphabetic;
    final markerDistance =
        marker.getDistanceToBaseline(baseline, onlyReal: true) ??
            markerSize.height;
    final childDistance =
        child.getDistanceToBaseline(baseline, onlyReal: true) ?? markerDistance;

    markerData.offset = Offset(
      textDirection == TextDirection.ltr
          ? -markerSize.width - _ListItem.kGap
          : childSize.width + _ListItem.kGap,
      childDistance - markerDistance,
    );
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _ListItemData) {
      child.parentData = _ListItemData();
    }
  }
}

class _ListMarkerCircle extends _ListMarker {
  const _ListMarkerCircle(TextStyle textStyle, {Key key})
      : super(
          key: key,
          markerType: _ListMarkerType.circle,
          textStyle: textStyle,
        );
}

class _ListMarkerDisc extends _ListMarker {
  const _ListMarkerDisc(TextStyle textStyle, {Key key})
      : super(
          key: key,
          markerType: _ListMarkerType.disc,
          textStyle: textStyle,
        );
}

class _ListMarkerSquare extends _ListMarker {
  const _ListMarkerSquare(TextStyle textStyle, {Key key})
      : super(
          key: key,
          markerType: _ListMarkerType.square,
          textStyle: textStyle,
        );
}

class _ListMarker extends SingleChildRenderObjectWidget {
  final _ListMarkerType markerType;
  final TextStyle textStyle;

  const _ListMarker({Key key, this.markerType, this.textStyle})
      : super(key: key);

  @override
  RenderObject createRenderObject(BuildContext _) => _ListMarkerRenderObject()
    ..markerType = markerType
    ..textStyle = textStyle;

  @override
  void updateRenderObject(
      BuildContext _, _ListMarkerRenderObject renderObject) {
    renderObject
      ..markerType = markerType
      ..textStyle = textStyle;
  }
}

class _ListMarkerRenderObject extends RenderBox {
  _ListMarkerType _markerType;
  set markerType(_ListMarkerType v) {
    if (v == _markerType) return;
    _markerType = v;
    markNeedsLayout();
  }

  TextPainter __textPainter;
  TextPainter get _textPainter {
    __textPainter ??= TextPainter(
      text: TextSpan(style: _textStyle, text: '1.'),
      textDirection: TextDirection.ltr,
    )..layout();
    return __textPainter;
  }

  TextStyle _textStyle;
  set textStyle(TextStyle v) {
    if (v == _textStyle) return;
    __textPainter = null;
    _textStyle = v;
    markNeedsLayout();
  }

  @override
  double computeDistanceToActualBaseline(TextBaseline baseline) =>
      _textPainter.computeDistanceToActualBaseline(baseline);

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;

    var lineMetrics = <LineMetrics>[];
    try {
      lineMetrics = _textPainter.computeLineMetrics();
      // ignore: empty_catches
    } on UnimplementedError {}
    final m = lineMetrics.isNotEmpty ? lineMetrics.first : null;
    final center = offset +
        Offset(
          size.width / 2,
          (m?.descent?.isFinite == true && m?.unscaledAscent?.isFinite == true)
              ? size.height -
                  m.descent -
                  m.unscaledAscent +
                  m.unscaledAscent * .7
              : size.height / 2,
        );
    final radius = _textStyle.fontSize * .2;

    switch (_markerType) {
      case _ListMarkerType.circle:
        canvas.drawCircle(
          center,
          radius * .9,
          Paint()
            ..color = _textStyle.color
            ..strokeWidth = 1
            ..style = PaintingStyle.stroke,
        );
        break;
      case _ListMarkerType.disc:
        canvas.drawCircle(
          center,
          radius,
          Paint()..color = _textStyle.color,
        );
        break;
      case _ListMarkerType.square:
        canvas.drawRect(
          Rect.fromCircle(center: center, radius: radius * .8),
          Paint()..color = _textStyle.color,
        );
        break;
    }
  }

  @override
  void performLayout() {
    size = _textPainter.size;
  }
}

enum _ListMarkerType {
  circle,
  disc,
  square,
}

class _TagLiListOp extends BuildOp {
  _TagLiListOp(TagLi tagLi)
      : super(
          defaultStyles: tagLi.defaultStyles,
          onChild: tagLi.onChild,
          onWidgets: _onWidgetsPassThrough,
        );

  static Iterable<Widget> _onWidgetsPassThrough(
          BuildMetadata _, Iterable<Widget> widgets) =>
      widgets;
}
