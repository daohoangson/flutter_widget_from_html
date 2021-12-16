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
  late final BuildOp op;
  final WidgetFactory wf;

  final _itemMetas = <BuildMetadata>[];
  late final BuildOp _itemOp;
  final _itemWidgets = <WidgetPlaceholder>[];

  _ListConfig? __config;

  TagLi(this.wf, this.listMeta) {
    op = _TagLiListOp(this);
    _itemOp = BuildOp(
      onWidgets: (itemMeta, widgets) {
        final column = wf.buildColumnPlaceholder(itemMeta, widgets) ??
            WidgetPlaceholder<BuildMetadata>(itemMeta);

        final i = _itemMetas.length;
        _itemMetas.add(itemMeta);
        _itemWidgets.add(column);
        return [column.wrapWith((c, w) => _buildItem(c, w, i))];
      },
    );
  }

  _ListConfig get _config {
    // cannot build config from constructor because
    // inline styles are not fully parsed at that time
    return __config ??= _ListConfig.fromBuildMetadata(listMeta);
  }

  Map<String, String> defaultStyles(dom.Element element) {
    final attrs = element.attributes;
    final depth = listMeta.parentOps.whereType<_TagLiListOp>().length;

    final styles = {
      'padding-inline-start': '40px',
      kCssListStyleType: element.localName == kTagOrderedList
          ? _ListConfig.listStyleTypeFromAttributeType(
                attrs[kAttributeLiType] ?? '',
              ) ??
              kCssListStyleTypeDecimal
          : depth == 0
              ? kCssListStyleTypeDisc
              : depth == 1
                  ? kCssListStyleTypeCircle
                  : kCssListStyleTypeSquare,
    };

    if (depth == 0) {
      styles[kCssMargin] = '1em 0';
    }

    return styles;
  }

  void onChild(BuildMetadata childMeta) {
    final e = childMeta.element;
    if (e.localName != kTagLi) {
      return;
    }
    if (e.parent != listMeta.element) {
      return;
    }
    childMeta.register(_itemOp);
  }

  Widget _buildItem(BuildContext context, Widget child, int i) {
    final config = _config;
    final meta = _itemMetas[i];
    final listStyleType = _ListConfig.listStyleTypeFromBuildMetadata(meta) ??
        config.listStyleType;
    final markerIndex = config.markerReversed
        ? (config.markerStart ?? _itemWidgets.length) - i
        : (config.markerStart ?? 1) + i;
    final tsh = meta.tsb.build(context);

    final marker = wf.buildListMarker(meta, tsh, listStyleType, markerIndex);
    if (marker == null) {
      return child;
    }

    return HtmlListItem(
      marker: marker,
      textDirection: tsh.textDirection,
      child: child,
    );
  }
}

@immutable
class _ListConfig {
  final String listStyleType;
  final bool markerReversed;
  final int? markerStart;

  const _ListConfig({
    required this.listStyleType,
    required this.markerReversed,
    this.markerStart,
  });

  factory _ListConfig.fromBuildMetadata(BuildMetadata meta) {
    final attrs = meta.element.attributes;

    return _ListConfig(
      listStyleType: meta[kCssListStyleType]?.term ?? kCssListStyleTypeDisc,
      markerReversed: attrs.containsKey(kAttributeOlReversed),
      markerStart: tryParseIntFromMap(attrs, kAttributeOlStart),
    );
  }

  static String? listStyleTypeFromBuildMetadata(BuildMetadata meta) {
    final listStyleType = meta[kCssListStyleType]?.term;
    if (listStyleType != null) {
      return listStyleType;
    }

    return listStyleTypeFromAttributeType(
      meta.element.attributes[kAttributeLiType] ?? '',
    );
  }

  static String? listStyleTypeFromAttributeType(String type) {
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

class _TagLiListOp extends BuildOp {
  _TagLiListOp(TagLi tagLi)
      : super(
          defaultStyles: tagLi.defaultStyles,
          onChild: tagLi.onChild,
          onWidgets: _onWidgetsPassThrough,
        );

  static Iterable<Widget> _onWidgetsPassThrough(
    BuildMetadata _,
    Iterable<Widget> widgets,
  ) =>
      widgets;
}
