part of '../core_ops.dart';

const kTagPre = 'pre';

class TagPre {
  final WidgetFactory wf;

  TagPre(this.wf);

  BuildOp get buildOp => BuildOp(
        debugLabel: kTagPre,
        defaultStyles: _defaultStyles,
        onRenderBlock: (tree, placeholder) => placeholder.wrapWith(
          (_, child) => wf.buildHorizontalScrollView(tree, child),
        ),
        priority: Priority.tagPre,
      );

  static StylesMap _defaultStyles(dom.Element _) {
    return const {
      kCssDisplay: kCssDisplayBlock,
      kCssFontFamily: '$kTagCodeFont1, $kTagCodeFont2',
      kCssWhitespace: kCssWhitespacePre,
    };
  }
}
