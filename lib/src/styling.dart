import 'package:flutter/widgets.dart';
import 'package:html/dom.dart' as dom;

import '../config.dart';

final _attributeStyleRegExp = RegExp(r'([a-zA-Z\-]+)\s*:\s*([^;]*)');
final _styleColorRegExp = RegExp(r'^#([a-fA-F0-9]{6})$');
final _spacingRegExp = RegExp(r'\s+');

NodeMetadata collectMetadata(Config config, dom.Element e) {
  Color color;
  bool decorationLineThrough;
  bool decorationOverline;
  bool decorationUnderline;
  double fontSize;
  bool fontStyleItalic;
  FontWeight fontWeight;
  String href;
  NodeImage image;
  bool isBlockElement;
  TextAlign textAlign;

  switch (e.localName) {
    case 'a':
      decorationUnderline = true;
      color = config.colorHyperlink;
      href = e.attributes['href'];
      break;

    case 'img':
      image = NodeImage.fromAttributes(e.attributes);
      isBlockElement = true;
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
      fontStyleItalic = true;
      break;

    case 'u':
      decorationUnderline = true;
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
              fontStyleItalic = true;
              break;
            case 'normal':
              fontStyleItalic = false;
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
          for (final v in value.split(_spacingRegExp)) {
            switch (v) {
              case 'line-through':
                decorationLineThrough = true;
                break;
              case 'none':
                decorationLineThrough = false;
                decorationOverline = false;
                decorationUnderline = false;
                break;
              case 'overline':
                decorationOverline = true;
                break;
              case 'underline':
                decorationUnderline = true;
                break;
            }
          }
          break;
      }
    }
  }

  if (color == null &&
      decorationLineThrough == null &&
      decorationOverline == null &&
      decorationUnderline == null &&
      fontSize == null &&
      fontStyleItalic == null &&
      fontWeight == null &&
      href == null &&
      image == null &&
      isBlockElement == null &&
      textAlign == null) {
    return null;
  }

  return NodeMetadata(
    color: color,
    decorationLineThrough: decorationLineThrough,
    decorationOverline: decorationOverline,
    decorationUnderline: decorationUnderline,
    fontSize: fontSize,
    fontStyleItalic: fontStyleItalic,
    fontWeight: fontWeight,
    href: href,
    image: image,
    isBlockElement: isBlockElement,
    textAlign: textAlign,
  );
}

FontStyle buildFontSize(NodeMetadata meta) {
  if (!meta.hasFontStyle) {
    return null;
  }

  return meta.fontStyleItalic ? FontStyle.italic : FontStyle.normal;
}

TextDecoration buildTextDecoration(NodeMetadata meta, TextStyle parent) {
  if (!meta.hasDecoration) {
    return null;
  }

  final pd = parent.decoration;
  final pdLineThough = pd?.contains(TextDecoration.lineThrough) == true;
  final pdOverline = pd?.contains(TextDecoration.overline) == true;
  final pdUnderline = pd?.contains(TextDecoration.underline) == true;

  final List<TextDecoration> list = List();
  if (meta.decorationLineThrough == true ||
      (pdLineThough && meta.decorationLineThrough != false)) {
    list.add(TextDecoration.lineThrough);
  }
  if (meta.decorationOverline == true ||
      (pdOverline && meta.decorationOverline != false)) {
    list.add(TextDecoration.overline);
  }
  if (meta.decorationUnderline == true ||
      (pdUnderline && meta.decorationUnderline != false)) {
    list.add(TextDecoration.underline);
  }

  return TextDecoration.combine(list);
}

TextStyle buildTextStyle(NodeMetadata meta, TextStyle parent) =>
    metaHasStyling(meta)
        ? parent.copyWith(
            color: meta.color,
            decoration: buildTextDecoration(meta, parent),
            fontSize: meta.fontSize,
            fontStyle: buildFontSize(meta),
            fontWeight: meta.fontWeight,
          )
        : null;

bool metaHasStyling(NodeMetadata meta) {
  if (meta == null) return false;
  if (meta.color == null &&
      !meta.hasDecoration &&
      meta.fontSize == null &&
      !meta.hasFontStyle &&
      meta.fontWeight == null) {
    return false;
  }

  return true;
}
