import 'package:flutter/widgets.dart';
import 'package:html/dom.dart' as dom;

String getValueFromAttributes(
    Map<dynamic, String> map, String key, String prefix) {
  if (map.containsKey(key)) return map[key];
  final keyWithPrefix = prefix + key;
  if (map.containsKey(keyWithPrefix)) return map[keyWithPrefix];
  return null;
}

int parseInt(String value) {
  if (value?.isEmpty != false) return null;
  return int.parse(value);
}

NodeMetadata lazySet(
  NodeMetadata meta, {
  Color color,
  bool decorationLineThrough,
  bool decorationOverline,
  bool decorationUnderline,
  String fontFamily,
  double fontSize,
  bool fontStyleItalic,
  FontWeight fontWeight,
  String href,
  NodeImage image,
  bool isBlockElement,
  bool isNotRenderable,
  ListType listType,
  TextAlign textAlign,
}) {
  if (meta == null) meta = NodeMetadata();

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
  if (href != null) meta.href = href;
  if (image != null) meta.image = image;
  if (isBlockElement != null) meta.isBlockElement = isBlockElement;
  if (isNotRenderable != null) meta.isNotRenderable = isNotRenderable;
  if (listType != null) meta.listType = listType;
  if (textAlign != null) meta.textAlign = textAlign;

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

class Config {
  final Uri baseUrl;
  final Color colorHyperlink;
  final EdgeInsetsGeometry indentPadding;
  final ParseElementCallback parseElementCallback;
  final List<double> sizeHeadings;
  final EdgeInsetsGeometry widgetImagePadding;
  final EdgeInsetsGeometry widgetTextPadding;

  const Config({
    this.baseUrl,
    this.colorHyperlink = const Color(0xFF1965B5),
    this.indentPadding = const EdgeInsets.only(left: 20.0),
    this.parseElementCallback,
    this.sizeHeadings = const [32.0, 24.0, 20.8, 16.0, 12.8, 11.2],
    this.widgetImagePadding = const EdgeInsets.symmetric(vertical: 5.0),
    this.widgetTextPadding = const EdgeInsets.all(10.0),
  });

  String getTextPrefixForList(int value) {
    if (value == 0) {
      return '• ';
    } else {
      return "$value. ";
    }
  }
}

enum ListType { Ordered, Unordered }

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
    final src = getValueFromAttributes(map, keySrc, keyPrefix);
    if (src?.isEmpty != false) return null;
    return NodeImage(
      height: parseInt(getValueFromAttributes(map, keyHeight, keyPrefix)),
      src: src,
      width: parseInt(getValueFromAttributes(map, keyWidth, keyPrefix)),
    );
  }
}

class NodeMetadata {
  Color color;
  bool decorationLineThrough;
  bool decorationOverline;
  bool decorationUnderline;
  List<dom.Node> domNodes;
  String fontFamily;
  double fontSize;
  bool fontStyleItalic;
  FontWeight fontWeight;
  String href;
  NodeImage image;
  bool isBlockElement;
  bool isNotRenderable;
  ListType listType;
  TextAlign textAlign = TextAlign.start;
}

typedef NodeMetadata ParseElementCallback(dom.Element e, NodeMetadata meta);
