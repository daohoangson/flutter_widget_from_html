part of '../ops.dart';

const kTagSvg = 'svg';

class TagSvg {
  final WidgetFactory wf;

  TagSvg(this.wf);

  BuildOp get buildOp => BuildOp(
        onBuilt: (meta, _) => [SvgPicture.string(meta.element.outerHtml)],
      );
}
