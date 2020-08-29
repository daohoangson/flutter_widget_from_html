part of '../core_ops.dart';

const kTagCode = 'code';
const kTagCodeFont1 = 'Courier';
const kTagCodeFont2 = 'monospace';
const kTagKbd = 'kbd';
const kTagPre = 'pre';
const kTagSamp = 'samp';
const kTagTt = 'tt';

class TagCode {
  final WidgetFactory wf;

  TagCode(this.wf);

  BuildOp get preOp => BuildOp(
        defaultStyles: (_) =>
            const {kCssFontFamily: '$kTagCodeFont1, $kTagCodeFont2'},
        onProcessed: (meta, tree) =>
            tree.replaceWith(TextBit(tree, meta.element.text, tsb: tree.tsb)),
        onBuilt: (meta, widgets) => listOrNull(wf
            .buildColumnPlaceholder(meta, widgets)
            ?.wrapWith((_, w) => wf.buildHorizontalScrollView(meta, w))),
      );
}
