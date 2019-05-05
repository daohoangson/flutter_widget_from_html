part of '../core_widget_factory.dart';

const kTagCode = 'code';
const kTagPre = 'pre';
const kTagTt = 'tt';

class TagCode {
  final WidgetFactory wf;

  TagCode(this.wf);

  BuildOp get buildOp => BuildOp(
        defaultStyles: (_, __) => [kCssFontFamily, 'monospace'],
        onPieces: (meta, pieces) => meta.domElement.localName == kTagPre
            ? [_buildPreTag(meta)]
            : pieces,
        onWidgets: (_, widgets) => [wf.buildScrollView(wf.buildBody(widgets))],
      );

  BuiltPiece _buildPreTag(NodeMetadata meta) => BuiltPieceSimple(
        block: TextBlock(meta.textStyle)..addText(meta.domElement.text),
      );
}
