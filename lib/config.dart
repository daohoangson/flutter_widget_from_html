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

bool shouldParseElement(Config config, dom.Element e) =>
    (config?.parseElementCallback == null ||
        config.parseElementCallback(e) == true);

typedef bool ParseElementCallback(dom.Element e);

class Config {
  final Uri baseUrl;
  final Color colorHyperlink;
  final EdgeInsetsGeometry indentPadding;
  final ParseElementCallback parseElementCallback;
  final List<double> sizeHeadings;
  final EdgeInsetsGeometry textWidgetPadding;

  const Config({
    this.baseUrl,
    this.colorHyperlink = const Color(0xFF1965B5),
    this.indentPadding = const EdgeInsets.only(left: 20.0),
    this.parseElementCallback,
    this.sizeHeadings = const [32.0, 24.0, 20.8, 16.0, 12.8, 11.2],
    this.textWidgetPadding = const EdgeInsets.all(5.0),
  });

  String getTextPrefixForList(int value) {
    if (value == 0) {
      return '•  ';
    } else {
      return "$value. ";
    }
  }
}

enum ListType { Ordered, Unordered }

class NodeMetadata {
  final Color color;
  final bool decorationLineThrough;
  final bool decorationOverline;
  final bool decorationUnderline;
  final double fontSize;
  final bool fontStyleItalic;
  final FontWeight fontWeight;
  final String href;
  final NodeImage image;
  final ListType listType;

  final bool _isBlockElement;
  final TextAlign _textAlign;

  NodeMetadata({
    this.color,
    this.decorationLineThrough,
    this.decorationOverline,
    this.decorationUnderline,
    this.fontSize,
    this.fontStyleItalic,
    this.fontWeight,
    this.href,
    this.image,
    bool isBlockElement,
    this.listType,
    TextAlign textAlign,
  })  : assert(href == null || href.isNotEmpty),
        assert(image == null || image.src?.isNotEmpty == true),
        _isBlockElement = isBlockElement,
        _textAlign = textAlign;

  bool get hasDecoration =>
      decorationLineThrough != null ||
      decorationOverline != null ||
      decorationUnderline != null;
  bool get hasFontStyle => fontStyleItalic != null;
  bool get isBlockElement => _isBlockElement == true;
  TextAlign get textAlign => _textAlign ?? TextAlign.start;
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
    final src = getValueFromAttributes(map, keySrc, keyPrefix);
    if (src?.isEmpty != false) return null;
    return NodeImage(
      height: parseInt(getValueFromAttributes(map, keyHeight, keyPrefix)),
      src: src,
      width: parseInt(getValueFromAttributes(map, keyWidth, keyPrefix)),
    );
  }
}
