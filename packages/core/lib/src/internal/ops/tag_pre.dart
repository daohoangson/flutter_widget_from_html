part of '../core_ops.dart';

const kTagPre = 'pre';

class TagPre {
  final WidgetFactory wf;

  TagPre(this.wf);

  BuildOp get buildOp => BuildOp(
        defaultStyles: (element) => {
          kCssDisplay: kCssDisplayBlock,
          kCssFontFamily: '$kTagCodeFont1, $kTagCodeFont2',
          kCssWhitespace: kCssWhitespacePre,
        },
        onWidgets: (tree, widgets) => listOrNull(
          wf
              .buildColumnPlaceholder(tree, widgets)
              ?.wrapWith((_, w) => wf.buildHorizontalScrollView(tree, w)),
        ),
      );
}
