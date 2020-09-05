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
    // domElement is not set at that time
    _config ??= _ListConfig.fromBuildMetadata(listMeta);
    return _config;
  }

  BuildOp get op {
    _listOp ??= _TagLiOp(this);
    return _listOp;
  }

  Map<String, String> defaultStyles(dom.Element element) {
    final attrs = element.attributes;
    final p = listMeta.parentOps?.whereType<_TagLiOp>()?.length ?? 0;

    final styles = {
      'padding-inline-start': '40px',
      kCssListStyleType: element.localName == kTagOrderedList
          ? _ListConfig.listStyleTypeFromAttributeType(
                  attrs[kAttributeLiType]) ??
              kCssListStyleTypeDecimal
          : p == 0
              ? kCssListStyleTypeDisc
              : p == 1 ? kCssListStyleTypeCircle : kCssListStyleTypeSquare,
    };

    if (p == 0) styles[kCssMargin] = '1em 0';

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
    final markerSpan = _buildMarkerSpan(tsh, listStyleType, markerText);

    return wf.buildStack(
      meta,
      tsh,
      <Widget>[child, _buildMarker(tsh, markerSpan)],
    );
  }

  Widget _buildMarker(TextStyleHtml tsh, InlineSpan text) {
    final isLtr = tsh.textDirection == TextDirection.ltr;
    final isRtl = !isLtr;
    final style = tsh.styleWithHeight;
    final width = style.fontSize * 4;
    final margin = width + 5;
    return Positioned(
      left: isLtr ? -margin : null,
      right: isRtl ? -margin : null,
      top: 0.0,
      child: SizedBox(
        child: RichText(
          overflow: TextOverflow.clip,
          softWrap: false,
          text: text,
          textAlign: isLtr ? TextAlign.right : TextAlign.left,
          textDirection: tsh.textDirection,
        ),
        width: width,
      ),
    );
  }

  InlineSpan _buildMarkerSpan(TextStyleHtml tsh, String type, String text) {
    final style = tsh.styleWithHeight;
    if (text?.isNotEmpty == true) return TextSpan(style: style, text: text);

    // draw `circle`, `disc` and `square` manually
    // because there are no Unicode equivalent
    return WidgetSpan(
        child: type == kCssListStyleTypeCircle
            ? _ListMarkerCircle(style)
            : type == kCssListStyleTypeSquare
                ? _ListMarkerSquare(style)
                : _ListMarkerDisc(style));
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

class _ListMarkerCircle extends StatelessWidget {
  final TextStyle style;

  const _ListMarkerCircle(this.style, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      _ListMarkerPainter.buildCustomPaint(style, _ListMarkerType.circle);
}

class _ListMarkerDisc extends StatelessWidget {
  final TextStyle style;

  const _ListMarkerDisc(this.style, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      _ListMarkerPainter.buildCustomPaint(style, _ListMarkerType.disc);
}

class _ListMarkerSquare extends StatelessWidget {
  final TextStyle style;

  const _ListMarkerSquare(this.style, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      _ListMarkerPainter.buildCustomPaint(style, _ListMarkerType.square);
}

class _ListMarkerPainter extends CustomPainter {
  final TextStyle style;
  final _ListMarkerType type;

  _ListMarkerPainter(this.style, this.type);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 8 / 13);
    final radius = style.fontSize * .2;

    switch (type) {
      case _ListMarkerType.circle:
        canvas.drawCircle(
          center,
          radius * .9,
          Paint()
            ..color = style.color
            ..strokeWidth = 1
            ..style = PaintingStyle.stroke,
        );
        break;
      case _ListMarkerType.disc:
        canvas.drawCircle(
          center,
          radius,
          Paint()..color = style.color,
        );
        break;
      case _ListMarkerType.square:
        canvas.drawRect(
          Rect.fromCircle(center: center, radius: radius * .8),
          Paint()..color = style.color,
        );
        break;
    }
  }

  @override
  bool shouldRepaint(_ListMarkerPainter old) => old.type != type;

  static Widget buildCustomPaint(TextStyle style, _ListMarkerType type) =>
      CustomPaint(
        painter: _ListMarkerPainter(style, type),
        size: Size(style.fontSize, style.fontSize),
      );
}

enum _ListMarkerType {
  circle,
  disc,
  square,
}

class _TagLiOp extends BuildOp {
  _TagLiOp(TagLi tagLi)
      : super(
          defaultStyles: tagLi.defaultStyles,
          isBlockElement: true,
          onChild: tagLi.onChild,
        );
}
