part of '../core_widget_factory.dart';

const _kTagLi = 'li';
const _kTagOrderedList = 'ol';
const _kTagUnorderedList = 'ul';
const _kAttributeLiType = 'type';
const _kAttributeLiTypeAlphaLower = 'a';
const _kAttributeLiTypeAlphaUpper = 'A';
const _kAttributeLiTypeDecimal = '1';
const _kAttributeLiTypeRomanLower = 'i';
const _kAttributeLiTypeRomanUpper = 'I';
const _kAttributeOlReversed = 'reversed';
const _kAttributeOlStart = 'start';
const _kCssListStyleType = 'list-style-type';
const _kCssListStyleTypeAlphaLower = 'lower-alpha';
const _kCssListStyleTypeAlphaUpper = 'upper-alpha';
const _kCssListStyleTypeAlphaLatinLower = 'lower-latin';
const _kCssListStyleTypeAlphaLatinUpper = 'upper-latin';
const _kCssListStyleTypeCircle = 'circle';
const _kCssListStyleTypeDecimal = 'decimal';
const _kCssListStyleTypeDisc = 'disc';
const _kCssListStyleTypeRomanLower = 'lower-roman';
const _kCssListStyleTypeRomanUpper = 'upper-roman';
const _kCssListStyleTypeSquare = 'square';

class _TagLi extends BuildOp {
  final NodeMetadata listMeta;
  final WidgetFactory wf;

  final _itemMetas = <NodeMetadata>[];
  final _itemWidgets = <WidgetPlaceholder>[];

  _ListConfig _config;
  BuildOp _itemOp;

  _TagLi(this.wf, this.listMeta) : super(isBlockElement: true);

  @override
  bool get hasOnChild => true;

  _ListConfig get config {
    _config ??= _ListConfig.fromNodeMetadata(listMeta);
    return _config;
  }

  @override
  Map<String, String> defaultStyles(NodeMetadata _, dom.Element e) {
    final p = listMeta.parents?.whereType<_TagLi>()?.length ?? 0;

    final styles = {
      'padding-inline-start': '2.5em',
      _kCssListStyleType: e.localName == _kTagOrderedList
          ? (e.attributes.containsKey(_kAttributeLiType)
                  ? _ListConfig.listStyleTypeFromAttributeType(
                      e.attributes[_kAttributeLiType])
                  : null) ??
              _kCssListStyleTypeDecimal
          : p == 0
              ? _kCssListStyleTypeDisc
              : p == 1 ? _kCssListStyleTypeCircle : _kCssListStyleTypeSquare,
    };

    if (p == 0) styles[_kCssMargin] = '1em 0';

    return styles;
  }

  @override
  void onChild(NodeMetadata childMeta, dom.Element e) {
    if (e.localName != _kTagLi) return;
    if (e.parent != listMeta.domElement) return;

    _itemOp ??= BuildOp(
      onWidgets: (meta, widgets) {
        final column = wf.buildColumn(widgets) ?? placeholder0;

        final i = _itemMetas.length;
        _itemMetas.add(meta);
        _itemWidgets.add(column);
        return [column.wrapWith(_buildItem, i)];
      },
    );

    childMeta.op = _itemOp;
  }

  Widget _buildItem(BuildContext context, Widget child, int i) {
    final meta = _itemMetas[i];
    final tsh = meta.tsb().build(context);
    final listStyleType =
        _ListConfig.listStyleTypeFromNodeMetadata(meta) ?? config.listStyleType;
    final markerIndex = config.markerReversed == true
        ? (config.markerStart ?? _itemWidgets.length) - i
        : (config.markerStart ?? 1) + i;
    final markerText = wf.getListStyleMarker(listStyleType, markerIndex);

    return Stack(
      children: <Widget>[
        child,
        _buildMarker(context, tsh.styleWithHeight, markerText),
      ],
      overflow: Overflow.visible,
    );
  }

  Widget _buildMarker(BuildContext context, TextStyle style, String text) {
    final isLtr = Directionality.of(context) == TextDirection.ltr;
    final isRtl = !isLtr;
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
          textScaleFactor: MediaQuery.of(context).textScaleFactor,
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
    var listStyleType = _kCssListStyleTypeDisc;
    bool markerReversed;
    int markerStart;

    for (final style in meta?.styleEntries) {
      switch (style.key) {
        case _kCssListStyleType:
          listStyleType = style.value;
          break;
      }
    }

    final a = meta.domElement.attributes;
    if (a.containsKey(_kAttributeOlReversed)) markerReversed = true;
    if (a.containsKey(_kAttributeOlStart)) {
      markerStart = int.tryParse(a[_kAttributeOlStart]);
    }

    return _ListConfig(
      listStyleType: listStyleType,
      markerReversed: markerReversed,
      markerStart: markerStart,
    );
  }

  static String listStyleTypeFromNodeMetadata(NodeMetadata meta) {
    final a = meta.domElement.attributes;
    var listStyleType = a.containsKey(_kAttributeLiType)
        ? listStyleTypeFromAttributeType(a[_kAttributeLiType])
        : null;
    for (final style in meta.styleEntries) {
      switch (style.key) {
        case _kCssListStyleType:
          listStyleType = style.value;
          break;
      }
    }

    return listStyleType;
  }

  static String listStyleTypeFromAttributeType(String type) {
    switch (type) {
      case _kAttributeLiTypeAlphaLower:
        return _kCssListStyleTypeAlphaLower;
      case _kAttributeLiTypeAlphaUpper:
        return _kCssListStyleTypeAlphaUpper;
      case _kAttributeLiTypeDecimal:
        return _kCssListStyleTypeDecimal;
      case _kAttributeLiTypeRomanLower:
        return _kCssListStyleTypeRomanLower;
      case _kAttributeLiTypeRomanUpper:
        return _kCssListStyleTypeRomanUpper;
    }

    return null;
  }
}
