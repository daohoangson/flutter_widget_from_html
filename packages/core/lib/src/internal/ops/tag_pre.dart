part of '../core_ops.dart';

const kTagPre = 'pre';

class TagPre {
  final WidgetFactory wf;

  TagPre(this.wf);

  BuildOp get buildOp => BuildOp(
        debugLabel: kTagPre,
        defaultStyles: (_) => {
          kCssDisplay: kCssDisplayBlock,
          kCssFontFamily: '$kTagCodeFont1, $kTagCodeFont2',
          kCssWhitespace: kCssWhitespacePre,
        },
        onRenderBlock: (tree, placeholder) => placeholder.wrapWith(
          (_, child) => wf.buildHorizontalScrollView(tree, child),
        ),
        priority: Prioritiy.tagPre,
      );
}
