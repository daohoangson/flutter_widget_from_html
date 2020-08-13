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

class _TagLi {
  final NodeMetadata listMeta;
  final WidgetFactory wf;

  final _itemMetas = <NodeMetadata>[];
  final _itemWidgets = <WidgetPlaceholder>[];

  _ListConfig _config;
  BuildOp _itemOp;
  BuildOp _listOp;

  _TagLi(this.wf, this.listMeta);

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

  void onChild(NodeMetadata childMeta, dom.Element e) {
    if (e.localName != _kTagLi) return;
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

class _TagLiOp extends BuildOp {
  _TagLiOp(_TagLi _)
      : super(
          defaultStyles: _.defaultStyles,
          isBlockElement: true,
          onChild: _.onChild,
        );
}
