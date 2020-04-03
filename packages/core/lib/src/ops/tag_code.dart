part of '../core_widget_factory.dart';

const kTagCode = 'code';
const kTagPre = 'pre';
const kTagTt = 'tt';

class _TagCode {
  final WidgetFactory wf;

  _TagCode(this.wf);

  BuildOp get buildOp => BuildOp(
      defaultStyles: (_, __) => const [_kCssFontFamily, 'monospace'],
      onPieces: (meta, pieces) => meta.domElement.localName == kTagPre
          ? [_resetText(pieces.first, meta)]
          : pieces,
      onWidgets: (_, widgets) {
        final body = wf.buildBody(widgets);
        if (body == null) return widgets;

        return [
          SingleChildScrollView(
            child: body,
            scrollDirection: Axis.horizontal,
          )
        ];
      });

  BuiltPiece _resetText(BuiltPiece piece, NodeMetadata meta) {
    final text = piece.text;
    text.children.clear();
    text.addText(meta.domElement.text);

    return piece;
  }
}
