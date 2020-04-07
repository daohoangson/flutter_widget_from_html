part of '../widget_factory.dart';

class _TagSvg {
  final WidgetFactory wf;

  _TagSvg(this.wf);

  BuildOp get buildOp => BuildOp(
        onWidgets: (meta, _) => [SvgPicture.string(meta.domElement.outerHtml)],
      );
}
