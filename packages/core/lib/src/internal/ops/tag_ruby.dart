part of '../core_ops.dart';

const kTagRuby = 'ruby';
const kTagRp = 'rp';
const kTagRt = 'rt';

class TagRuby {
  late final BuildOp op;
  final BuildMetadata rubyMeta;
  final WidgetFactory wf;

  late final BuildOp _rtOp;

  TagRuby(this.wf, this.rubyMeta) {
    op = BuildOp(onChild: onChild, onTree: onTree);
    _rtOp = BuildOp(
      onTree: (rtMeta, rtTree) {
        if (rtTree.isEmpty) {
          return;
        }
        rtTree.isRtBit = true;
      },
    );
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
        childMeta
          ..[kCssFontSize] = '0.5em'
          ..register(_rtOp);
        break;
    }
  }

  void onTree(BuildMetadata _, BuildTree tree) {
    final rubyBits = <BuildBit>[];

    for (final bit in tree.directChildren.toList(growable: false)) {
      if (!bit.isRtBit || rubyBits.isEmpty) {
        if (rubyBits.isEmpty && bit is WhitespaceBit) {
          // ruby contents should not start with a whitespace
          bit.copyWith(parent: tree.parent).insertBefore(tree);
          bit.detach();
        } else {
          rubyBits.add(bit);
        }
        continue;
      }

      final rtBit = bit;
      final rtTree = rtBit as BuildTree;
      final rubyTree = tree.sub();
      final placeholder = WidgetPlaceholder(
        builder: (context, __) {
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

      WidgetBit.inline(
        tree.parent!,
        placeholder,
        alignment: PlaceholderAlignment.baseline,
      ).insertBefore(tree);

      for (final rubyBit in rubyBits) {
        rubyTree.add(rubyBit.copyWith(parent: rubyTree));
        rubyBit.detach();
      }
      rubyBits.clear();
      rtBit.detach();
    }
  }
}

extension _RtBit on BuildBit {
  static final _rtBits = Expando<bool>();

  bool get isRtBit => _rtBits[this] == true;
  set isRtBit(bool v) => _rtBits[this] = v;
}
