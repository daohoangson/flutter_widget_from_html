part of '../ops.dart';

class TagSvg {
  final WidgetFactory wf;

  TagSvg(this.wf);

  BuildOp get buildOp => BuildOp(
        onWidgets: (meta, _) => [SvgPicture.string(meta.domElement.outerHtml)],
      );
}
