part of '../core_wf.dart';

const kTagCode = 'code';
const kTagPre = 'pre';

class TagCode {
  final WidgetFactory wf;

  TagCode(this.wf);

  BuildOp get buildOp => BuildOp(
        collectMetadata: (meta) => meta.fontFamily ??= 'monospace',
        onPieces: (meta, pieces) => meta.buildOpElement.localName == kTagPre
            ? _buildTextSpansForPre(meta, pieces.first)
            : pieces,
        onWidgets: (_, widgets) => wf.buildScrollView(widgets),
      );

  Iterable<BuiltPiece> _buildTextSpansForPre(
          NodeMetadata meta, BuiltPiece first) =>
      [
        BuiltPieceSimple(
          textSpan: TextSpan(
            style: first.textStyle,
            text: meta.buildOpElement.text,
          ),
        )
      ];
}
