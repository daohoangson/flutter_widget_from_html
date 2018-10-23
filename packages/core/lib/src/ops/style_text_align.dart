import 'package:flutter/widgets.dart';

import '../metadata.dart';
import '../widget_factory.dart';

class StyleTextAlign {
  final Alignment alignment;
  final TextAlign textAlign;
  final WidgetFactory wf;

  StyleTextAlign(this.alignment, this.textAlign, this.wf);

  Widget buildAlign(List<Widget> children) => Align(
        alignment: alignment,
        child: wf.buildColumn(children),
      );

  Widget buildTextWidgetWithTextAlign(text) =>
      wf.buildTextWidget(text, textAlign: textAlign);

  List<BuiltPiece> onPieces(List<BuiltPiece> pieces) {
    List<Widget> newWidgets = List();
    for (final piece in pieces) {
      if (piece.hasTextSpan) {
        newWidgets.add(buildTextWidgetWithTextAlign(piece.textSpan));
      } else if (piece.hasText) {
        newWidgets.add(buildTextWidgetWithTextAlign(piece.text));
      } else if (piece.hasWidgets) {
        newWidgets.add(buildAlign(piece.widgets));
      }
    }

    List<BuiltPiece> newPieces = List();
    newPieces.add(BuiltPieceSimple(widgets: newWidgets));
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
