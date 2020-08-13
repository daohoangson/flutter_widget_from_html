part of '../core_widget_factory.dart';

const _kTagCode = 'code';
const _kTagCodeFont1 = 'Courier';
const _kTagCodeFont2 = 'monospace';
const _kTagPre = 'pre';
const _kTagTt = 'tt';

class _TagCode {
  final WidgetFactory wf;

  _TagCode(this.wf);

  BuildOp get buildOp => BuildOp(
        defaultStyles: (_, __) =>
            const {_kCssFontFamily: '$_kTagCodeFont1, $_kTagCodeFont2'},
        onPieces: (meta, pieces) => meta.domElement.localName == _kTagPre
            ? [_resetText(pieces.first, meta)]
            : pieces,
        onWidgets: (meta, widgets) => _listOrNull(wf
            .buildColumnPlaceholder(meta, widgets)
            ?.wrapWith(wf.buildHorizontalScrollView)),
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
