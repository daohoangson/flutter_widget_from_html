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
  final BuildTree listTree;
  final WidgetFactory wf;

  final _itemTrees = <BuildTree>[];
  late final BuildOp _itemOp;
  final _itemWidgets = <WidgetPlaceholder>[];

  _ListConfig? __config;

  TagLi(this.wf, this.listTree) {
    _itemOp = BuildOp(
      onWidgets: (itemTree, widgets) {
        final column = wf.buildColumnPlaceholder(itemTree, widgets) ??
            WidgetPlaceholder(localName: kTagLi);

        final i = _itemTrees.length;
        _itemTrees.add(itemTree);
        _itemWidgets.add(column);
        return [column.wrapWith((c, w) => _buildItem(c, w, i))];
      },
    );
  }

  BuildOp get buildOp => BuildOp(
        defaultStyles: (element) {
          final attrs = element.attributes;
          final depth = listTree.depth;

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
        },
        onChild: (_, subTree) {
          final element = subTree.element;

          switch (element.localName) {
            case kTagOrderedList:
            case kTagUnorderedList:
              subTree.depth++;
              break;
            case kTagLi:
              if (element.parent == listTree.element) {
                subTree.register(_itemOp);
              }
              break;
          }
        },
        onWidgets: (_, widgets) => widgets,
      );

  _ListConfig get _config {
    // cannot build config from constructor because
    // inline styles are not fully parsed at that time
    return __config ??= _ListConfig.fromTree(listTree);
  }

  Widget _buildItem(BuildContext context, Widget child, int i) {
    final config = _config;
    final itemTree = _itemTrees[i];
    final listStyleType = _ListConfig.listStyleTypeFromBuildTree(itemTree) ??
        config.listStyleType;
    final markerIndex = config.markerReversed
        ? (config.markerStart ?? _itemWidgets.length) - i
        : (config.markerStart ?? 1) + i;
    final style = itemTree.styleBuilder.build(context);

    final marker =
        wf.buildListMarker(itemTree, style, listStyleType, markerIndex);
    if (marker == null) {
      return child;
    }

    return HtmlListItem(
      marker: marker,
      textDirection: style.textDirection,
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

  factory _ListConfig.fromTree(BuildTree tree) {
    final attrs = tree.element.attributes;

    return _ListConfig(
      listStyleType: tree[kCssListStyleType]?.term ?? kCssListStyleTypeDisc,
      markerReversed: attrs.containsKey(kAttributeOlReversed),
      markerStart: tryParseIntFromMap(attrs, kAttributeOlStart),
    );
  }

  static String? listStyleTypeFromBuildTree(BuildTree tree) {
    final listStyleType = tree[kCssListStyleType]?.term;
    if (listStyleType != null) {
      return listStyleType;
    }

    return listStyleTypeFromAttributeType(
      tree.element.attributes[kAttributeLiType] ?? '',
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

extension _ListTree on BuildTree {
  static final _depths = Expando<int>();

  int get depth => _depths[this] ?? 0;

  set depth(int value) => _depths[this] = value;
}
