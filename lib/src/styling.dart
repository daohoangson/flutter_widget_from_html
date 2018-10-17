import 'package:flutter/widgets.dart';
import 'package:html/dom.dart' as dom;

import '../config.dart';

final _attributeStyleRegExp = RegExp(r'([a-zA-Z\-]+)\s*:\s*([^;]*)');
final _styleColorRegExp = RegExp(r'^#([a-fA-F0-9]{6})$');
final _spacingRegExp = RegExp(r'\s+');

NodeMetadata collectMetadata(Config config, dom.Element e) {
  NodeMetadata meta;

  switch (e.localName) {
    case 'a':
      meta = lazySet(
        meta,
        decorationUnderline: true,
        color: config.colorHyperlink,
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
      meta = lazySet(meta, isBlockElement: true);
      break;

    case 'h1':
      meta = lazySet(
        meta,
        fontSize: config.sizeHeadings[0],
        isBlockElement: true,
      );
      break;
    case 'h2':
      meta = lazySet(
        meta,
        fontSize: config.sizeHeadings[1],
        isBlockElement: true,
      );
      break;
    case 'h3':
      meta = lazySet(
        meta,
        fontSize: config.sizeHeadings[2],
        isBlockElement: true,
      );
      break;
    case 'h4':
      meta = lazySet(
        meta,
        fontSize: config.sizeHeadings[3],
        isBlockElement: true,
      );
      break;
    case 'h5':
      meta = lazySet(
        meta,
        fontSize: config.sizeHeadings[4],
        isBlockElement: true,
      );
      break;
    case 'h6':
      meta = lazySet(
        meta,
        fontSize: config.sizeHeadings[5],
        isBlockElement: true,
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
        image: NodeImage.fromAttributes(e.attributes),
        isBlockElement: true,
      );
      break;

    case 'li':
      meta = lazySet(meta, isBlockElement: true);
      break;
    case 'ol':
      meta = lazySet(
        meta,
        isBlockElement: true,
        listType: ListType.Ordered,
      );
      break;
    case 'ul':
      meta = lazySet(
        meta,
        isBlockElement: true,
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

FontStyle buildFontSize(NodeMetadata meta) => meta.fontStyleItalic != null
    ? (meta.fontStyleItalic ? FontStyle.italic : FontStyle.normal)
    : null;

TextDecoration buildTextDecoration(NodeMetadata meta, TextStyle parent) {
  if (meta.decorationLineThrough == null &&
      meta.decorationOverline == null &&
      meta.decorationUnderline == null) {
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
      meta.decorationLineThrough == null &&
      meta.decorationOverline == null &&
      meta.decorationUnderline == null &&
      meta.fontSize == null &&
      meta.fontStyleItalic == null &&
      meta.fontWeight == null) {
    return false;
  }

  return true;
}
