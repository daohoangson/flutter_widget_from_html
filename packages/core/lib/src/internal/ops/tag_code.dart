part of '../core_ops.dart';

const kTagCode = 'code';
const kTagCodeFont1 = 'Courier';
const kTagCodeFont2 = 'monospace';
const kTagKbd = 'kbd';
const kTagPre = 'pre';
const kTagSamp = 'samp';
const kTagTt = 'tt';

class TagCode {
  final WidgetFactory wf;

  TagCode(this.wf);

  BuildOp get preOp => BuildOp(
        defaultStyles: (_) =>
            const {kCssFontFamily: '$kTagCodeFont1, $kTagCodeFont2'},
        onPieces: (meta, pieces) => [_resetText(pieces.first, meta)],
        onWidgets: (meta, widgets) => listOrNull(wf
            .buildColumnPlaceholder(meta, widgets)
            ?.wrapWith((_, w) => wf.buildHorizontalScrollView(meta, w))),
      );

  BuiltPiece _resetText(BuiltPiece piece, BuildMetadata meta) {
    final text = piece.text;
    for (final bit in List<TextBit>.unmodifiable(text.bits)) {
      bit.detach();
    }
    text.addText(meta.element.text);

    return piece;
  }
}
