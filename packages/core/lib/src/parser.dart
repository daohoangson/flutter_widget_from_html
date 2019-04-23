import 'package:flutter/widgets.dart';
import 'package:html/dom.dart' as dom;

import 'metadata.dart';

part 'parser/attr_style.dart';
part 'parser/border.dart';
part 'parser/color.dart';
part 'parser/text.dart';
part 'parser/unit.dart';

final _spacingRegExp = RegExp(r'\s+');

NodeMetadata parseElement(NodeMetadata meta, dom.Element e) {
  switch (e.localName) {
    case 'a':
      meta = lazySet(meta, decorationUnderline: true);
      break;

    case 'abbr':
    case 'acronym':
      meta = lazySet(
        meta,
        decorationStyle: TextDecorationStyle.dotted,
        decorationUnderline: true,
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

  return meta;
}

NodeMetadata parseElementStyle(NodeMetadata meta, String key, String value) {
  switch (key) {
    case 'border-bottom':
      final borderBottom = borderParse(value);
      if (borderBottom != null) {
        meta = lazySet(
          meta,
          decorationUnderline: true,
          decorationStyleFromCssBorderStyle: borderBottom.style,
        );
      } else {
        meta = lazySet(meta, decorationUnderline: false);
      }
      break;
    case 'border-top':
      final borderTop = borderParse(value);
      if (borderTop != null) {
        meta = lazySet(
          meta,
          decorationOverline: true,
          decorationStyleFromCssBorderStyle: borderTop.style,
        );
      } else {
        meta = lazySet(meta, decorationOverline: false);
      }
      break;

    case 'color':
      final color = colorParseValue(value);
      if (color != null) meta = lazySet(meta, color: color);
      break;

    case 'font-family':
      meta = lazySet(meta, fontFamily: value);
      break;

    case 'font-size':
      meta = lazySet(meta, fontSize: unitParseValue(value));
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

  return meta;
}
