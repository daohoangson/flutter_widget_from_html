import 'package:flutter/widgets.dart';
import 'package:html/dom.dart' as dom;

final _attributeStyleRegExp = RegExp(r'([a-zA-Z\-]+)\s*:\s*([^;]*)');
final _styleColorRegExp = RegExp(r'^#([a-fA-F0-9]{6})$');
final _spacingRegExp = RegExp(r'\s+');

NodeMetadata lazySet(
  NodeMetadata meta, {
  Color color,
  bool decorationLineThrough,
  bool decorationOverline,
  bool decorationUnderline,
  DisplayType display,
  String fontFamily,
  double fontSize,
  bool fontStyleItalic,
  FontWeight fontWeight,
  String href,
  NodeImage image,
  bool isNotRenderable,
  ListType listType,
  StyleType style,
  TextAlign textAlign,
  bool textSpaceCollapse,
}) {
  if (meta == null) meta = NodeMetadata();

  if (color != null) meta.color = color;
  if (decorationLineThrough != null)
    meta.decorationLineThrough = decorationLineThrough;
  if (decorationOverline != null) meta.decorationOverline = decorationOverline;
  if (decorationUnderline != null)
    meta.decorationUnderline = decorationUnderline;
  if (display != null) meta.display = display;
  if (fontFamily != null) meta.fontFamily = fontFamily;
  if (fontSize != null) meta.fontSize = fontSize;
  if (fontStyleItalic != null) meta.fontStyleItalic = fontStyleItalic;
  if (fontWeight != null) meta.fontWeight = fontWeight;
  if (href != null) meta.href = href;
  if (image != null) meta.image = image;
  if (isNotRenderable != null) meta.isNotRenderable = isNotRenderable;
  if (listType != null) meta.listType = listType;
  if (style != null) meta.style = style;
  if (textAlign != null) meta.textAlign = textAlign;
  if (textSpaceCollapse != null) meta.textSpaceCollapse = textSpaceCollapse;

  return meta;
}

NodeMetadata lazyAddNode(NodeMetadata meta,
    {dom.Node node, List<dom.Node> nodes, String text}) {
  if (meta == null) meta = NodeMetadata();
  if (meta.domNodes == null) meta.domNodes = List();

  if (node != null) {
    meta.domNodes.add(node);
  } else if (nodes != null) {
    meta.domNodes.addAll(nodes);
  } else {
    meta.domNodes.add(dom.Text(text));
  }

  return meta;
}

NodeMetadata parseElement(dom.Element e) {
  NodeMetadata meta;

  switch (e.localName) {
    case 'a':
      meta = lazySet(
        meta,
        decorationUnderline: true,
        href: e.attributes['href'],
      );
      break;

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
    case 'p':
      meta = lazySet(meta, display: DisplayType.Block);
      break;

    case 'code':
      meta = lazySet(
        meta,
        display: DisplayType.BlockScrollable,
        fontFamily: 'monospace',
      );
      break;
    case 'pre':
      meta = lazySet(
        meta,
        display: DisplayType.BlockScrollable,
        fontFamily: 'monospace',
        textSpaceCollapse: false,
      );
      break;

    case 'h1':
      meta = lazySet(
        meta,
        display: DisplayType.Block,
        style: StyleType.Heading1,
      );
      break;
    case 'h2':
      meta = lazySet(
        meta,
        display: DisplayType.Block,
        style: StyleType.Heading2,
      );
      break;
    case 'h3':
      meta = lazySet(
        meta,
        display: DisplayType.Block,
        style: StyleType.Heading3,
      );
      break;
    case 'h4':
      meta = lazySet(
        meta,
        style: StyleType.Heading4,
        display: DisplayType.Block,
      );
      break;
    case 'h5':
      meta = lazySet(
        meta,
        display: DisplayType.Block,
        style: StyleType.Heading5,
      );
      break;
    case 'h6':
      meta = lazySet(
        meta,
        style: StyleType.Heading6,
        display: DisplayType.Block,
      );
      break;

    case 'iframe':
    case 'script':
    case 'style':
      // actually `script` and `style` are not required here
      // our parser will put those elements into document.head anyway
      meta = lazySet(meta, isNotRenderable: true);
      break;

    case 'img':
      meta = lazySet(
        meta,
        display: DisplayType.Block,
        image: NodeImage.fromAttributes(e.attributes),
      );
      break;

    case 'li':
      meta = lazySet(
        meta,
        display: DisplayType.Block,
        listType: ListType.Item,
      );
      break;
    case 'ol':
      meta = lazySet(
        meta,
        display: DisplayType.Block,
        listType: ListType.Ordered,
      );
      break;
    case 'ul':
      meta = lazySet(
        meta,
        display: DisplayType.Block,
        listType: ListType.Unordered,
      );
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
          meta = lazySet(meta, display: DisplayType.Block);

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

enum ListType { Item, Ordered, Unordered }

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

enum DisplayType {
  Block,
  BlockScrollable,
  Inline,
}

class NodeMetadata {
  Color color;
  bool decorationLineThrough;
  bool decorationOverline;
  bool decorationUnderline;
  DisplayType display;
  List<dom.Node> domNodes;
  String fontFamily;
  double fontSize;
  bool fontStyleItalic;
  FontWeight fontWeight;
  String href;
  NodeImage image;
  bool isNotRenderable;
  ListType listType;
  StyleType style;
  TextAlign textAlign = TextAlign.start;
  bool textSpaceCollapse;

  bool get hasStyling =>
      color != null ||
      fontFamily != null ||
      fontSize != null ||
      fontWeight != null ||
      hasDecoration ||
      hasFontStyle ||
      href != null ||
      style != null ||
      textSpaceCollapse != null;

  bool get hasDecoration =>
      decorationLineThrough != null ||
      decorationOverline != null ||
      decorationUnderline != null;

  bool get hasFontStyle => fontStyleItalic != null;

  bool get isBlockElement =>
      display == DisplayType.Block || display == DisplayType.BlockScrollable;
}

typedef NodeMetadata ParseElementCallback(dom.Element e, NodeMetadata meta);

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
