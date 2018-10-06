import 'package:flutter/widgets.dart';

class Config {
  final Uri baseUrl;
  final Color colorHyperlink;
  final List<double> sizeHeadings;

  const Config({
    this.baseUrl,
    this.colorHyperlink = const Color(0xFF1965B5),
    this.sizeHeadings = const [32.0, 24.0, 20.8, 16.0, 12.8, 11.2],
  });
}

abstract class ParsedNode {
  var processor;

  bool get isBlockElement => false;
  TextAlign get textAlign => null;
}

class ParsedNodeImage extends ParsedNode {
  final String src;

  ParsedNodeImage({@required this.src});

  @override
  bool get isBlockElement => true;

  static ParsedNodeImage fromAttributes(Map<dynamic, String> attribs,
      {String key = 'src'}) {
    if (!attribs.containsKey(key)) return null;
    return ParsedNodeImage(src: attribs[key]);
  }
}

class ParsedNodeStyle extends ParsedNode {
  final Color color;
  final TextDecoration decoration;
  final double fontSize;
  final FontStyle fontStyle;
  final FontWeight fontWeight;
  final bool _isBlockElement;
  final TextAlign _textAlign;

  ParsedNodeStyle({
    this.color,
    this.decoration,
    this.fontSize,
    this.fontStyle,
    this.fontWeight,
    bool isBlockElement,
    TextAlign textAlign,
  })  : _isBlockElement = isBlockElement,
        _textAlign = textAlign;

  @override
  bool get isBlockElement => _isBlockElement == true;

  @override
  TextAlign get textAlign => _textAlign;
}

class ParsedNodeText extends ParsedNode {
  final String text;

  ParsedNodeText({this.text});

  @override
  set processor(v) {}
}

class ParsedNodeUrl extends ParsedNode {
  final String href;

  ParsedNodeUrl({@required this.href});
}
