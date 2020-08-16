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
  final NodeMetadata listMeta;
  final WidgetFactory wf;

  final _itemMetas = <NodeMetadata>[];
  final _itemWidgets = <WidgetPlaceholder>[];

  _ListConfig _config;
  BuildOp _itemOp;
  BuildOp _listOp;

  TagLi(this.wf, this.listMeta);

  _ListConfig get config {
    // cannot build config from constructor because
    // domElement is not set at that time
    _config ??= _ListConfig.fromNodeMetadata(listMeta);
    return _config;
  }

  BuildOp get op {
    _listOp ??= _TagLiOp(this);
    return _listOp;
  }

  Map<String, String> defaultStyles(NodeMetadata _, dom.Element e) {
    final p = listMeta.parentOps?.whereType<_TagLiOp>()?.length ?? 0;

    final styles = {
      'padding-inline-start': '2.5em',
      kCssListStyleType: e.localName == kTagOrderedList
          ? (e.attributes.containsKey(kAttributeLiType)
                  ? _ListConfig.listStyleTypeFromAttributeType(
                      e.attributes[kAttributeLiType])
                  : null) ??
              kCssListStyleTypeDecimal
          : p == 0
              ? kCssListStyleTypeDisc
              : p == 1 ? kCssListStyleTypeCircle : kCssListStyleTypeSquare,
    };

    if (p == 0) styles[kCssMargin] = '1em 0';

    return styles;
  }

  void onChild(NodeMetadata childMeta, dom.Element e) {
    if (e.localName != kTagLi) return;
    if (e.parent != listMeta.domElement) return;

    _itemOp ??= BuildOp(
      onWidgets: (meta, widgets) {
        final column = wf.buildColumnPlaceholder(meta, widgets) ??
            WidgetPlaceholder<NodeMetadata>(
              child: widget0,
              generator: meta,
            );

        final i = _itemMetas.length;
        _itemMetas.add(meta);
        _itemWidgets.add(column);
        return [column.wrapWith((child) => _buildItem(child, i))];
      },
    );

    childMeta.register(_itemOp);
  }

  Widget _buildItem(Widget child, int i) {
    final meta = _itemMetas[i];
    final listStyleType =
        _ListConfig.listStyleTypeFromNodeMetadata(meta) ?? config.listStyleType;
    final markerIndex = config.markerReversed == true
        ? (config.markerStart ?? _itemWidgets.length) - i
        : (config.markerStart ?? 1) + i;
    final markerText = wf.getListStyleMarker(listStyleType, markerIndex);

    return wf.buildStack(
      meta,
      <Widget>[
        child,
        _buildMarker(meta.tsb().build(), markerText),
      ],
    );
  }

  Widget _buildMarker(TextStyleHtml tsh, String text) {
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
          text: TextSpan(style: style, text: text),
          textAlign: isLtr ? TextAlign.right : TextAlign.left,
          textDirection: tsh.textDirection,
        ),
        width: width,
      ),
    );
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

  factory _ListConfig.fromNodeMetadata(NodeMetadata meta) {
    final attrs = meta.domElement.attributes;

    return _ListConfig(
      listStyleType: meta[kCssListStyleType] ?? kCssListStyleTypeDisc,
      markerReversed: attrs.containsKey(kAttributeOlReversed),
      markerStart: attrs.containsKey(kAttributeOlStart)
          ? int.tryParse(attrs[kAttributeOlStart])
          : null,
    );
  }

  static String listStyleTypeFromNodeMetadata(NodeMetadata meta) {
    final listStyleType = meta[kCssListStyleType];
    if (listStyleType != null) return listStyleType;

    final attrs = meta.domElement.attributes;
    return attrs.containsKey(kAttributeLiType)
        ? listStyleTypeFromAttributeType(attrs[kAttributeLiType])
        : null;
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

class _TagLiOp extends BuildOp {
  _TagLiOp(TagLi tagLi)
      : super(
          defaultStyles: tagLi.defaultStyles,
          isBlockElement: true,
          onChild: tagLi.onChild,
        );
}
