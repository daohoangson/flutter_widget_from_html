import 'package:flutter/widgets.dart';

import '../metadata.dart';
import '../core_wf.dart';

class StyleTextAlign {
  final Alignment alignment;
  final TextAlign textAlign;
  final WidgetFactory wf;

  StyleTextAlign(this.alignment, this.textAlign, this.wf);

  Iterable<BuiltPiece> onPieces(NodeMetadata _, Iterable<BuiltPiece> pieces) =>
      pieces.map(
        (piece) => piece.hasWidgets
            ? BuiltPieceSimple(
                widgets: [
                  Align(
                    alignment: alignment,
                    child: wf.buildColumn(piece.widgets),
                  ),
                ],
              )
            : (piece..textAlign = textAlign),
      );

  static StyleTextAlign fromString(String textAlign, WidgetFactory wf) {
    switch (textAlign) {
      case 'center':
        return StyleTextAlign(Alignment.topCenter, TextAlign.center, wf);
      case 'justify':
        return StyleTextAlign(Alignment.topLeft, TextAlign.justify, wf);
      case 'left':
        return StyleTextAlign(Alignment.topLeft, TextAlign.left, wf);
      case 'right':
        return StyleTextAlign(Alignment.topRight, TextAlign.right, wf);
    }

    return null;
  }
}
