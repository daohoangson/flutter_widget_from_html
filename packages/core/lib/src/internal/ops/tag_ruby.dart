part of '../core_ops.dart';

const kTagRuby = 'ruby';
const kTagRp = 'rp';
const kTagRt = 'rt';

class TagRuby {
  late final BuildOp op;
  final BuildMetadata rubyMeta;
  final WidgetFactory wf;

  TagRuby(this.wf, this.rubyMeta) {
    op = BuildOp(onChild: onChild, onTree: onTree);
  }

  void onChild(BuildMetadata childMeta) {
    final e = childMeta.element;
    if (e.parent != rubyMeta.element) {
      return;
    }

    switch (e.localName) {
      case kTagRp:
        childMeta[kCssDisplay] = kCssDisplayNone;
        break;
      case kTagRt:
        childMeta[kCssFontSize] = '0.5em';
        break;
    }
  }

  void onTree(BuildMetadata _, BuildTree tree) {
    final rubyBits = <BuildBit>[];
    final list = <BuildBit>[];

    for (final bit in tree.children) {
      if (!bit.isRtTree || rubyBits.isEmpty) {
        if (rubyBits.isEmpty && bit is WhitespaceBit) {
          // ruby contents should not start with a whitespace
          list.add(bit);
        } else {
          rubyBits.add(bit);
        }
        continue;
      }

      final rubyTree = tree.sub();
      for (final rubyBit in rubyBits) {
        rubyTree.append(rubyBit);
      }
      rubyBits.clear();

      final rtTree = bit as BuildTree;
      final placeholder = WidgetPlaceholder(
        builder: (context, _) {
          final tsh = rubyTree.tsb.build(context);

          final ruby = wf.buildColumnWidget(
            context,
            rubyTree.build().toList(growable: false),
            dir: tsh.getDependency(),
          );
          final rt = wf.buildColumnWidget(
            context,
            rtTree.build().toList(growable: false),
            dir: tsh.getDependency(),
          );

          return HtmlRuby(ruby, rt);
        },
        localName: kTagRuby,
      );

      const baseline = PlaceholderAlignment.baseline;
      list.add(WidgetBit.inline(tree, placeholder, alignment: baseline));
    }

    // preserve orphan bits if any
    list.addAll(rubyBits);

    tree.replaceWith(null);
    for (final bit in list) {
      tree.append(bit);
    }
  }
}

extension _RtTree on BuildBit {
  bool get isRtTree {
    final thiz = this;

    if (thiz is! BuildTree) {
      return false;
    }

    if (thiz.isEmpty) {
      return false;
    }

    if (thiz is BuildMetadata) {
      final meta = thiz as BuildMetadata;
      return meta.element.localName == kTagRt;
    } else {
      return false;
    }
  }
}
