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
      onWidgets: (_, widgets) {
        final body = wf.buildColumnWidget(widgets.toList(growable: false));
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
    List.unmodifiable(text.bits).forEach((bit) => bit.detach());
    text.addText(meta.domElement.text);

    return piece;
  }
}
