part of '../core_ops.dart';

const kTagCode = 'code';
const kTagCodeFont1 = 'Courier';
const kTagCodeFont2 = 'monospace';
const kTagPre = 'pre';
const kTagTt = 'tt';

class TagCode {
  final WidgetFactory wf;

  TagCode(this.wf);

  BuildOp get buildOp => BuildOp(
        defaultStyles: (_) =>
            const {kCssFontFamily: '$kTagCodeFont1, $kTagCodeFont2'},
        onPieces: (meta, pieces) => meta.domElement.localName == kTagPre
            ? [_resetText(pieces.first, meta)]
            : pieces,
        onWidgets: (meta, widgets) => listOrNull(wf
            .buildColumnPlaceholder(meta, widgets)
            ?.wrapWith((child) => wf.buildHorizontalScrollView(meta, child))),
      );

  BuiltPiece _resetText(BuiltPiece piece, NodeMetadata meta) {
    final text = piece.text;
    for (final bit in List<TextBit>.unmodifiable(text.bits)) {
      bit.detach();
    }
    text.addText(meta.domElement.text);

    return piece;
  }
}
