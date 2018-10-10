import 'package:flutter/widgets.dart';
import 'package:html/dom.dart' as dom;

import '../config.dart';

final _attributeStyleRegExp = RegExp(r'([a-zA-Z\-]+)\s*:\s*([^;]*)');
final _styleColorRegExp = RegExp(r'^#([a-fA-F0-9]{6})$');
final _spacingRegExp = RegExp(r'\s+');

ParsedNodeStyle parseNodeStyle(Config config, dom.Element e) {
  Color color;
  TextDecoration decoration;
  double fontSize;
  FontStyle fontStyle;
  FontWeight fontWeight;
  String url;
  bool isBlockElement;
  TextAlign textAlign;

  switch (e.localName) {
    case 'a':
      decoration = TextDecoration.underline;
      color = config.colorHyperlink;
      url = e.attributes['href'];
      break;

    case 'br':
    case 'div':
    case 'p':
      isBlockElement = true;
      break;

    case 'h1':
      fontSize = config.sizeHeadings[0];
      isBlockElement = true;
      break;
    case 'h2':
      fontSize = config.sizeHeadings[1];
      isBlockElement = true;
      break;
    case 'h3':
      fontSize = config.sizeHeadings[2];
      isBlockElement = true;
      break;
    case 'h4':
      fontSize = config.sizeHeadings[3];
      isBlockElement = true;
      break;
    case 'h5':
      fontSize = config.sizeHeadings[4];
      isBlockElement = true;
      break;
    case 'h6':
      fontSize = config.sizeHeadings[5];
      isBlockElement = true;
      break;

    case 'b':
    case 'strong':
      fontWeight = FontWeight.bold;
      break;

    case 'i':
    case 'em':
      fontStyle = FontStyle.italic;
      break;

    case 'u':
      decoration = TextDecoration.underline;
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
            color =
                new Color(int.parse('0xFF' + value.replaceAll('#', '').trim()));
          }
          break;

        case 'font-weight':
          switch (value) {
            case 'bold':
              fontWeight = FontWeight.bold;
              break;
            case '100':
              fontWeight = FontWeight.w100;
              break;
            case '200':
              fontWeight = FontWeight.w200;
              break;
            case '300':
              fontWeight = FontWeight.w300;
              break;
            case '400':
              fontWeight = FontWeight.w400;
              break;
            case '500':
              fontWeight = FontWeight.w500;
              break;
            case '600':
              fontWeight = FontWeight.w600;
              break;
            case '700':
              fontWeight = FontWeight.w700;
              break;
            case '800':
              fontWeight = FontWeight.w800;
              break;
            case '900':
              fontWeight = FontWeight.w900;
              break;
          }
          break;

        case 'font-style':
          switch (value) {
            case 'italic':
              fontStyle = FontStyle.italic;
              break;
            case 'normal':
              fontStyle = FontStyle.normal;
              break;
          }
          break;

        case 'text-align':
          isBlockElement = true;

          switch (value) {
            case 'center':
              textAlign = TextAlign.center;
              break;
            case 'justify':
              textAlign = TextAlign.justify;
              break;
            case 'left':
              textAlign = TextAlign.left;
              break;
            case 'right':
              textAlign = TextAlign.right;
              break;
          }
          break;

        case 'text-decoration':
          decoration =
              TextDecoration.combine(value.split(_spacingRegExp).map((v) {
            switch (v) {
              case 'line-through':
                return TextDecoration.lineThrough;
              case 'overline':
                return TextDecoration.overline;
              case 'underline':
                return TextDecoration.underline;
            }

            return null;
          }).toList());
          break;
      }
    }
  }

  if (color == null &&
      decoration == null &&
      fontSize == null &&
      fontStyle == null &&
      fontWeight == null &&
      url == null &&
      isBlockElement == null &&
      textAlign == null) {
    return null;
  }

  return ParsedNodeStyle(
    color: color,
    decoration: decoration,
    fontSize: fontSize,
    fontStyle: fontStyle,
    fontWeight: fontWeight,
    url: url,
    isBlockElement: isBlockElement,
    textAlign: textAlign,
  );
}

TextStyle buildTextStyle(ParsedNode pn, TextStyle parent) {
  if (pn is! ParsedNodeStyle) {
    return parent;
  }

  final pns = pn as ParsedNodeStyle;
  final decoration = parent.decoration == null
      ? pns.decoration
      : (pns.decoration == null
          ? parent.decoration
          : TextDecoration.combine([parent.decoration, pns.decoration]));

  return parent.copyWith(
    color: pns.color,
    decoration: decoration,
    fontSize: pns.fontSize,
    fontStyle: pns.fontStyle,
    fontWeight: pns.fontWeight,
  );
}
