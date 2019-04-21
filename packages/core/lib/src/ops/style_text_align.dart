import 'package:flutter/widgets.dart';

import '../metadata.dart';
import '../core_wf.dart';

class StyleTextAlign {
  final Alignment alignment;
  final TextAlign textAlign;
  final WidgetFactory wf;

  StyleTextAlign(this.alignment, this.textAlign, this.wf);

  List<BuiltPiece> onPieces(NodeMetadata meta, List<BuiltPiece> pieces) {
    final List<BuiltPiece> newPieces = List();
    for (final piece in pieces) {
      if (piece.hasWidgets) {
        newPieces.add(BuiltPieceSimple(widgets: [
          Align(
            alignment: alignment,
            child: wf.buildColumn(piece.widgets),
          ),
        ]));
      } else {
        piece.textAlign = textAlign;
        newPieces.add(piece);
      }
    }

    return newPieces;
  }

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
