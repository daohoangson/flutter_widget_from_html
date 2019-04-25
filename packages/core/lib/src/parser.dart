import 'package:flutter/widgets.dart';
import 'package:html/dom.dart' as dom;

import 'data_classes.dart';

part 'parser/border.dart';
part 'parser/color.dart';
part 'parser/css.dart';

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

    case 'address':
      meta = lazySet(meta, isBlockElement: true, fontStyleItalic: true);
      break;

    case 'article':
    case 'aside':
    case 'div':
    case 'figcaption':
    case 'footer':
    case 'header':
    case 'li':
    case 'main':
    case 'nav':
    case 'ol':
    case 'section':
    case 'ul':
      meta = lazySet(meta, isBlockElement: true);
      break;
    case 'blockquote':
    case 'figure':
      meta = lazySet(meta, inlineStyles: ['margin', '1em 40px']);
      break;
    case 'p':
      meta = lazySet(meta, inlineStyles: ['margin', '1em 0']);
      break;

    case 'b':
    case 'strong':
      meta = lazySet(meta, fontWeight: FontWeight.bold);
      break;
    case 'cite':
    case 'dfn':
    case 'em':
    case 'i':
    case 'var':
      meta = lazySet(meta, fontStyleItalic: true);
      break;
    case 'del':
    case 's':
    case 'strike':
      meta = lazySet(meta, decorationLineThrough: true);
      break;
    case 'ins':
    case 'u':
      meta = lazySet(meta, decorationUnderline: true);
      break;

    case 'big':
      meta = lazySet(meta, fontSize: 'larger');
      break;
    case 'small':
      meta = lazySet(meta, fontSize: 'smaller');
      break;

    case 'center':
      meta = lazySet(meta, inlineStyles: ['text-align', 'center']);
      break;

    case 'dd':
      meta = lazySet(meta, inlineStyles: ['margin', '0 0 1em 40px']);
      break;
    case 'dl':
      meta = lazySet(meta, isBlockElement: true);
      break;
    case 'dt':
      meta = lazySet(meta, isBlockElement: true, fontWeight: FontWeight.bold);
      break;

    case 'h1':
      meta = lazySet(
        meta,
        fontSize: '2em',
        fontWeight: FontWeight.bold,
        inlineStyles: ['margin', '0.67em 0'],
      );
      break;
    case 'h2':
      meta = lazySet(
        meta,
        fontSize: '1.5em',
        fontWeight: FontWeight.bold,
        inlineStyles: ['margin', '0.83em 0'],
      );
      break;
    case 'h3':
      meta = lazySet(
        meta,
        fontSize: '1.17em',
        fontWeight: FontWeight.bold,
        inlineStyles: ['margin', '1em 0'],
      );
      break;
    case 'h4':
      meta = lazySet(
        meta,
        fontWeight: FontWeight.bold,
        inlineStyles: ['margin', '1.33em 0'],
      );
      break;
    case 'h5':
      meta = lazySet(
        meta,
        fontSize: '0.83em',
        fontWeight: FontWeight.bold,
        inlineStyles: ['margin', '1.67em 0'],
      );
      break;
    case 'h6':
      meta = lazySet(
        meta,
        fontSize: '0.67em',
        fontWeight: FontWeight.bold,
        inlineStyles: ['margin', '2.33em 0'],
      );
      break;

    case 'iframe':
    case 'script':
    case 'style':
      // actually `script` and `style` are not required here
      // our parser will put those elements into document.head anyway
      meta = lazySet(meta, isNotRenderable: true);
      break;

    case 'kbd':
    case 'samp':
      meta = lazySet(meta, fontFamily: 'monospace');
      break;

    case 'mark':
      meta = lazySet(
        meta,
        inlineStyles: ['background-color', '#ff0', 'color', '#000'],
      );
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
      meta = lazySet(meta, fontSize: value);
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
