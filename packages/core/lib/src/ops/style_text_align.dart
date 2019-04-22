import 'package:flutter/widgets.dart';

import '../core_wf.dart';
import '../metadata.dart';
import '../parser.dart';

const kCssTextAlign = 'text-align';
const kCssTextAlignCenter = 'center';
const kCssTextAlignJustify = 'justify';
const kCssTextAlignLeft = 'left';
const kCssTextAlignRight = 'right';

Alignment _getAlignment(String textAlign) {
  switch (textAlign) {
    case kCssTextAlignCenter:
      return Alignment.topCenter;
    case kCssTextAlignJustify:
      return Alignment.topLeft;
    case kCssTextAlignLeft:
      return Alignment.topLeft;
    case kCssTextAlignRight:
      return Alignment.topRight;
  }

  return null;
}

TextAlign _getTextAlign(String textAlign) {
  switch (textAlign) {
    case kCssTextAlignCenter:
      return TextAlign.center;
    case kCssTextAlignJustify:
      return TextAlign.justify;
    case kCssTextAlignLeft:
      return TextAlign.left;
    case kCssTextAlignRight:
      return TextAlign.right;
  }

  return null;
}

class StyleTextAlign {
  final WidgetFactory wf;

  BuildOp _buildOp;

  StyleTextAlign(this.wf);

  BuildOp get buildOp {
    _buildOp ??= BuildOp(
      onPieces: (meta, pieces) {
        String textAlign;
        attrStyleLoop(
          meta.buildOpElement,
          (k, v) => k == kCssTextAlign ? textAlign = v : null,
        );
        if (textAlign == null) return pieces;

        final widgets = <Widget>[];
        for (final piece in pieces) {
          widgets.add(
            piece.hasWidgets
                ? wf.buildAlign(
                    wf.buildColumn(piece.widgets),
                    _getAlignment(textAlign),
                  )
                : wf.buildTextWidget(
                    piece.hasTextSpan ? piece.textSpan : piece.text,
                    textAlign: _getTextAlign(textAlign),
                  ),
          );
        }

        return <BuiltPiece>[BuiltPieceSimple(widgets: widgets)];
      },
    );

    return _buildOp;
  }
}
