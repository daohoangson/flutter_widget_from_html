import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart'
    show BuildOp;

import '../core_wf.dart';
import '../metadata.dart';

const kTagCode = 'code';
const kTagPre = 'pre';

class TagCode {
  final WidgetFactory wf;

  BuildOp _buildOp;

  TagCode(this.wf);

  BuildOp get buildOp {
    _buildOp ??= BuildOp(
      collectMetadata: (meta) => meta.fontFamily ??= 'monospace',
      onPieces: (meta, pieces) {
        if (meta.buildOpElement.localName != kTagPre) return pieces;

        // special processing for PRE tag:
        // build text spans with `textSpaceCollapse=false`
        final output = <BuiltPiece>[];
        for (final piece in pieces) {
          if (!piece.hasText) continue;
          output.add(BuiltPieceSimple(
            textSpan: wf.buildTextSpan(
              piece.text,
              style: piece.textStyle,
              textSpaceCollapse: false,
            ),
          ));
        }

        return output;
      },
      onWidgets: (_, widgets) => wf.buildScrollView(widgets),
    );

    return _buildOp;
  }
}
