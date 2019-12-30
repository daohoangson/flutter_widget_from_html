part of '../core_widget_factory.dart';

const kTagCode = 'code';
const kTagPre = 'pre';
const kTagTt = 'tt';

class _TagCode {
  final WidgetFactory wf;

  _TagCode(this.wf);

  BuildOp get buildOp => BuildOp(
      defaultStyles: (_, __) => const [kCssFontFamily, 'monospace'],
      onPieces: (meta, pieces) =>
          meta.domElement.localName == kTagPre ? [_buildPreTag(meta)] : pieces,
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

  BuiltPiece _buildPreTag(NodeMetadata meta) => BuiltPieceSimple(
        block: TextBlock(meta.tsb)..addText(meta.domElement.text),
      );
}
