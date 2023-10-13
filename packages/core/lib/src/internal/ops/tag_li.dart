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
const kCssListStyleTypeNone = 'none';
const kCssListStyleTypeRomanLower = 'lower-roman';
const kCssListStyleTypeRomanUpper = 'upper-roman';
const kCssListStyleTypeSquare = 'square';

class TagLi {
  final WidgetFactory wf;

  TagLi(this.wf);

  BuildOp get buildOp => BuildOp(
        debugLabel: kTagUnorderedList,
        defaultStyles: _defaultStyles,
        onVisitChild: (listTree, subTree) {
          final element = subTree.element;

          switch (element.localName) {
            case kTagOrderedList:
            case kTagUnorderedList:
              element.elementDepth = subTree.increaseListDepth();
              break;
            case kTagLi:
              if (element.parent == listTree.element) {
                subTree.register(
                  BuildOp(
                    debugLabel: kTagLi,
                    onRenderBlock: (itemTree, placeholder) {
                      final i = listTree.increaseListItems() - 1;

                      return placeholder.wrapWith(
                        (ctx, w) => _buildItem(ctx, listTree, itemTree, w, i),
                      );
                    },
                    priority: Priority.tagLiItem,
                  ),
                );
              }
              break;
          }
        },
        priority: Priority.tagLiList,
      );

  Widget _buildItem(
    BuildContext context,
    BuildTree listTree,
    BuildTree itemTree,
    Widget child,
    int i,
  ) {
    final tree = itemTree.sub()
      ..maxLines = 1
      ..styleBuilder.enqueue(TextStyleOps.whitespace, CssWhitespace.nowrap);
    final listData = listTree.listData;
    final listStyleType = itemTree.itemStyleType ?? listTree.listStyleType;
    final index = listData.markerReversed
        ? (listData.markerStart ?? listData.items) - i
        : (listData.markerStart ?? 1) + i;
    final style = tree.styleBuilder.build(context);
    final marker = wf.buildListMarker(tree, style, listStyleType, index);
    if (marker == null) {
      return child;
    }

    return HtmlListItem(
      marker: marker,
      textDirection: style.textDirection,
      child: child,
    );
  }

  static StylesMap _defaultStyles(dom.Element element) {
    final attrs = element.attributes;
    final depth = element.elementDepth;
    final listStyleType = element.localName == kTagOrderedList
        ? (_listStyleTypeFromAttributeType(attrs[kAttributeLiType] ?? '') ??
            kCssListStyleTypeDecimal)
        : depth == 0
            ? kCssListStyleTypeDisc
            : depth == 1
                ? kCssListStyleTypeCircle
                : kCssListStyleTypeSquare;
    return {
      kCssDisplay: kCssDisplayBlock,
      kCssListStyleType: listStyleType,
      '$kCssPadding$kSuffixInlineStart': '40px',
      if (depth == 0) kCssMargin: '1em 0',
    };
  }
}

String? _listStyleTypeFromAttributeType(String type) {
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

extension on BuildTree {
  String? get itemStyleType =>
      getStyle(kCssListStyleType)?.term ??
      _listStyleTypeFromAttributeType(
        element.attributes[kAttributeLiType] ?? '',
      );
}

extension on BuildTree {
  _TagLiListData get listData {
    final existing = value<_TagLiListData>();
    if (existing != null) {
      return existing;
    }

    final attrs = element.attributes;
    final newData = _TagLiListData(
      markerReversed: attrs.containsKey(kAttributeOlReversed),
      markerStart: tryParseIntFromMap(attrs, kAttributeOlStart),
    );
    value(newData);
    return newData;
  }

  String get listStyleType =>
      getStyle(kCssListStyleType)?.term ?? kCssListStyleTypeDisc;

  int increaseListDepth() {
    final newData = listData.copyWith(dataDepth: listData.dataDepth + 1);
    value(newData);
    return newData.dataDepth;
  }

  int increaseListItems() {
    final newData = listData.copyWith(items: listData.items + 1);
    value(newData);
    return newData.items;
  }
}

extension on dom.Element {
  static final _depths = Expando<int>();
  int get elementDepth => _depths[this] ?? 0;
  set elementDepth(int value) => _depths[this] = value;
}

@immutable
class _TagLiListData {
  final bool markerReversed;
  final int? markerStart;

  final int dataDepth;
  final int items;

  const _TagLiListData({
    required this.markerReversed,
    this.markerStart,
    this.dataDepth = 0,
    this.items = 0,
  });

  _TagLiListData copyWith({
    int? dataDepth,
    int? items,
  }) {
    return _TagLiListData(
      markerReversed: markerReversed,
      markerStart: markerStart,
      dataDepth: dataDepth ?? this.dataDepth,
      items: items ?? this.items,
    );
  }
}
