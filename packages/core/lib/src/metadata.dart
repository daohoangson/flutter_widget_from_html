import 'package:flutter/widgets.dart';
import 'package:html/dom.dart' as dom;

final _attributeStyleRegExp = RegExp(r'([a-zA-Z\-]+)\s*:\s*([^;]*)');
final _spacingRegExp = RegExp(r'\s+');
final _styleColorRegExp = RegExp(r'^#([a-fA-F0-9]{6})$');

NodeMetadata lazySet(
  NodeMetadata meta, {
  BuildOp buildOp,
  Color color,
  bool decorationLineThrough,
  bool decorationOverline,
  bool decorationUnderline,
  String fontFamily,
  double fontSize,
  bool fontStyleItalic,
  FontWeight fontWeight,
  bool isBlockElement,
  bool isNotRenderable,
  StyleType style,
  TextAlign textAlign,
  bool textSpaceCollapse,
}) {
  meta ??= NodeMetadata();

  if (buildOp != null) meta.buildOp = buildOp;
  if (color != null) meta.color = color;
  if (decorationLineThrough != null)
    meta.decorationLineThrough = decorationLineThrough;
  if (decorationOverline != null) meta.decorationOverline = decorationOverline;
  if (decorationUnderline != null)
    meta.decorationUnderline = decorationUnderline;
  if (fontFamily != null) meta.fontFamily = fontFamily;
  if (fontSize != null) meta.fontSize = fontSize;
  if (fontStyleItalic != null) meta.fontStyleItalic = fontStyleItalic;
  if (fontWeight != null) meta.fontWeight = fontWeight;
  if (isBlockElement != null) meta._isBlockElement = isBlockElement;
  if (isNotRenderable != null) meta.isNotRenderable = isNotRenderable;
  if (style != null) meta.style = style;
  if (textAlign != null) meta.textAlign = textAlign;
  if (textSpaceCollapse != null) meta.textSpaceCollapse = textSpaceCollapse;

  return meta;
}

NodeMetadata parseElement(dom.Element e) {
  NodeMetadata meta;

  switch (e.localName) {
    case 'b':
    case 'strong':
      meta = lazySet(meta, fontWeight: FontWeight.bold);
      break;
    case 'em':
    case 'i':
      meta = lazySet(meta, fontStyleItalic: true);
      break;
    case 'u':
      meta = lazySet(meta, decorationUnderline: true);
      break;

    case 'br':
    case 'div':
    case 'li':
    case 'p':
    case 'ol':
    case 'ul':
      meta = lazySet(meta, isBlockElement: true);
      break;

    case 'h1':
      meta = lazySet(
        meta,
        isBlockElement: true,
        style: StyleType.Heading1,
      );
      break;
    case 'h2':
      meta = lazySet(
        meta,
        isBlockElement: true,
        style: StyleType.Heading2,
      );
      break;
    case 'h3':
      meta = lazySet(
        meta,
        isBlockElement: true,
        style: StyleType.Heading3,
      );
      break;
    case 'h4':
      meta = lazySet(
        meta,
        isBlockElement: true,
        style: StyleType.Heading4,
      );
      break;
    case 'h5':
      meta = lazySet(
        meta,
        isBlockElement: true,
        style: StyleType.Heading5,
      );
      break;
    case 'h6':
      meta = lazySet(
        meta,
        isBlockElement: true,
        style: StyleType.Heading6,
      );
      break;

    case 'iframe':
    case 'script':
    case 'style':
      // actually `script` and `style` are not required here
      // our parser will put those elements into document.head anyway
      meta = lazySet(meta, isNotRenderable: true);
      break;
  }

  final attribs = e.attributes;
  if (attribs.containsKey('style')) {
    final stylings = _attributeStyleRegExp.allMatches(attribs['style']);
    for (final styling in stylings) {
      final param = styling[1].trim();
      final value = styling[2].trim();

      switch (param) {
        case 'color':
          if (_styleColorRegExp.hasMatch(value)) {
            meta = lazySet(
              meta,
              color:
                  Color(int.parse('0xFF' + value.replaceAll('#', '').trim())),
            );
          }
          break;

        case 'font-family':
          meta = lazySet(meta, fontFamily: value);
          break;

        case 'font-style':
          switch (value) {
            case 'italic':
              meta = lazySet(meta, fontStyleItalic: true);
              break;
            case 'normal':
              meta = lazySet(meta, fontStyleItalic: false);
              break;
          }
          break;

        case 'font-weight':
          switch (value) {
            case 'bold':
              meta = lazySet(meta, fontWeight: FontWeight.bold);
              break;
            case '100':
              meta = lazySet(meta, fontWeight: FontWeight.w100);
              break;
            case '200':
              meta = lazySet(meta, fontWeight: FontWeight.w200);
              break;
            case '300':
              meta = lazySet(meta, fontWeight: FontWeight.w300);
              break;
            case '400':
              meta = lazySet(meta, fontWeight: FontWeight.w400);
              break;
            case '500':
              meta = lazySet(meta, fontWeight: FontWeight.w500);
              break;
            case '600':
              meta = lazySet(meta, fontWeight: FontWeight.w600);
              break;
            case '700':
              meta = lazySet(meta, fontWeight: FontWeight.w700);
              break;
            case '800':
              meta = lazySet(meta, fontWeight: FontWeight.w800);
              break;
            case '900':
              meta = lazySet(meta, fontWeight: FontWeight.w900);
              break;
          }
          break;

        case 'text-align':
          meta = lazySet(meta, isBlockElement: true);

          switch (value) {
            case 'center':
              meta = lazySet(meta, textAlign: TextAlign.center);
              break;
            case 'justify':
              meta = lazySet(meta, textAlign: TextAlign.justify);
              break;
            case 'left':
              meta = lazySet(meta, textAlign: TextAlign.left);
              break;
            case 'right':
              meta = lazySet(meta, textAlign: TextAlign.right);
              break;
          }
          break;

        case 'text-decoration':
          for (final v in value.split(_spacingRegExp)) {
            switch (v) {
              case 'line-through':
                meta = lazySet(meta, decorationLineThrough: true);
                break;
              case 'none':
                meta = lazySet(
                  meta,
                  decorationLineThrough: false,
                  decorationOverline: false,
                  decorationUnderline: false,
                );
                break;
              case 'overline':
                meta = lazySet(meta, decorationOverline: true);
                break;
              case 'underline':
                meta = lazySet(meta, decorationUnderline: true);
                break;
            }
          }
          break;
      }
    }
  }

  return meta;
}

class BuildOp {
  final bool hasStyling;
  final bool _isBlockElement;
  final BuildOpOnPieces onPieces;
  final BuildOpOnProcess onProcess;
  final BuildOpOnWidgets onWidgets;

  BuildOp({
    this.hasStyling,
    bool isBlockElement,
    this.onPieces,
    this.onProcess,
    this.onWidgets,
  }) : this._isBlockElement = isBlockElement;

  bool get isBlockElement =>
      _isBlockElement != null ? _isBlockElement : onWidgets != null;
}

typedef List<BuiltPiece> BuildOpOnPieces(List<BuiltPiece> pieces);
typedef void BuildOpOnProcess(BuildOpOnProcessAddSpan addSpan,
    BuildOpOnProcessAddWidgets addWidgets, BuildOpOnProcessWrite write);
typedef void BuildOpOnProcessAddSpan(TextSpan span);
typedef void BuildOpOnProcessAddWidgets(List<Widget> widgets);
typedef void BuildOpOnProcessWrite(String text);
typedef List<Widget> BuildOpOnWidgets(List<Widget> widgets);

abstract class BuiltPiece {
  bool get hasText;
  bool get hasTextSpan;
  bool get hasWidgets;

  TextStyle get style;
  String get text;
  TextSpan get textSpan;
  TextSpan get textSpanTrimmedLeft;
  List<Widget> get widgets;
}

class BuiltPieceSimple extends BuiltPiece {
  final TextStyle style;
  final String text;
  final TextSpan textSpan;
  final List<Widget> widgets;

  BuiltPieceSimple({this.style, this.text, this.textSpan, this.widgets});

  bool get hasText => text != null;
  bool get hasTextSpan => textSpan != null;
  bool get hasWidgets => widgets != null;
  TextSpan get textSpanTrimmedLeft => textSpan;
}

class NodeImage {
  final int height;
  final String src;
  final int width;

  NodeImage({this.height, @required this.src, this.width});

  static NodeImage fromAttributes(
    Map<dynamic, String> map, {
    String keyHeight = 'height',
    String keyPrefix = 'data-',
    String keySrc = 'src',
    String keyWidth = 'width',
  }) {
    final src = _getValueFromAttributes(map, keySrc, keyPrefix);
    if (src?.isEmpty != false) return null;
    return NodeImage(
      height: _parseInt(_getValueFromAttributes(map, keyHeight, keyPrefix)),
      src: src,
      width: _parseInt(_getValueFromAttributes(map, keyWidth, keyPrefix)),
    );
  }
}

class NodeMetadata {
  BuildOp buildOp;
  Color color;
  bool decorationLineThrough;
  bool decorationOverline;
  bool decorationUnderline;
  String fontFamily;
  double fontSize;
  bool fontStyleItalic;
  FontWeight fontWeight;
  bool _isBlockElement;
  bool isNotRenderable;
  StyleType style;
  TextAlign textAlign = TextAlign.start;
  bool textSpaceCollapse;

  bool get hasStyling =>
      buildOp?.hasStyling == true ||
      color != null ||
      fontFamily != null ||
      fontSize != null ||
      fontWeight != null ||
      hasDecoration ||
      hasFontStyle ||
      style != null ||
      textSpaceCollapse != null;

  bool get hasDecoration =>
      decorationLineThrough != null ||
      decorationOverline != null ||
      decorationUnderline != null;

  bool get hasFontStyle => fontStyleItalic != null;

  bool get isBlockElement =>
      _isBlockElement == true || buildOp?.isBlockElement == true;
}

enum StyleType {
  Heading1,
  Heading2,
  Heading3,
  Heading4,
  Heading5,
  Heading6,
}

String _getValueFromAttributes(
    Map<dynamic, String> map, String key, String prefix) {
  if (map.containsKey(key)) return map[key];

  final keyWithPrefix = prefix + key;
  if (map.containsKey(keyWithPrefix)) return map[keyWithPrefix];

  return null;
}

int _parseInt(String value) =>
    value?.isNotEmpty == true ? int.parse(value) : null;
