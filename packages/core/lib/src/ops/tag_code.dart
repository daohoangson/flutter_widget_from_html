import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart'
    show BuildOp;

import '../core_wf.dart';
import '../metadata.dart';

const kTagCode = 'code';
const kTagPre = 'pre';

class TagCode {
  final WidgetFactory wf;

  TagCode(this.wf);

  BuildOp get buildOp => BuildOp(
        collectMetadata: (meta) => meta.fontFamily ??= 'monospace',
        onPieces: (meta, pieces) => meta.buildOpElement.localName == kTagPre
            ? _buildTextSpansForPre(pieces)
            : pieces,
        onWidgets: (_, widgets) => wf.buildScrollView(widgets),
      );

  Iterable<BuiltPiece> _buildTextSpansForPre(Iterable<BuiltPiece> pieces) =>
      pieces.map((piece) {
        if (!piece.hasText) return BuiltPieceSimple(text: '');

        return BuiltPieceSimple(
          textSpan: wf.buildTextSpan(
            piece.text,
            style: piece.textStyle,
            textSpaceCollapse: false,
          ),
        );
      });
}
