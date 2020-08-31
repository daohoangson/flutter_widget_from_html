part of '../core_ops.dart';

const kTagRuby = 'ruby';
const kTagRp = 'rp';
const kTagRt = 'rt';

class TagRuby {
  final BuildMetadata rubyMeta;
  final WidgetFactory wf;

  BuildOp _rubyOp;
  BuildOp _rtOp;

  TagRuby(this.wf, this.rubyMeta);

  BuildOp get op {
    _rubyOp ??= BuildOp(onChild: onChild, onProcessed: onProcessed);
    return _rubyOp;
  }

  void onChild(BuildMetadata childMeta) {
    final e = childMeta.element;
    if (e.parent != rubyMeta.element) return;

    switch (e.localName) {
      case kTagRp:
        childMeta[kCssDisplay] = kCssDisplayNone;
        break;
      case kTagRt:
        _rtOp ??= BuildOp(
          onProcessed: (rtMeta, rtTree) {
            if (rtTree.isEmpty) return;
            final rtBit = _RtBit(rtTree, rtTree.tsb, rtMeta, rtTree.copyWith());
            rtTree.replaceWith(rtBit);
          },
        );

        childMeta
          ..[kCssFontSize] = '0.5em'
          ..register(_rtOp);
        break;
    }
  }

  void onProcessed(BuildMetadata _, BuildTree tree) {
    final rubyBits = <BuildBit>[];
    for (final bit in tree.bits.toList(growable: false)) {
      if (rubyBits.isEmpty && bit.tsb == null) {
        // the first bit is whitespace, just ignore it
        continue;
      }
      if (bit is! _RtBit || rubyBits.isEmpty) {
        rubyBits.add(bit);
        continue;
      }

      final rtBit = bit as _RtBit;
      final rubyTree = tree.sub();
      final placeholder =
          WidgetPlaceholder<List<BuildTree>>([rubyTree, rtBit.tree])
            ..wrapWith((context, __) {
              final tsh = rubyTree.tsb.build(context);

              final ruby = wf.buildColumnWidget(
                  rubyMeta, tsh, rubyTree.build().toList(growable: false));
              final rt = wf.buildColumnWidget(
                  rtBit.meta, tsh, rtBit.tree.build().toList(growable: false));

              return HtmlRuby(ruby ?? widget0, rt ?? widget0);
            });

      final anchorBit = rubyBits.first;
      WidgetBit.inline(anchorBit.parent, placeholder,
              alignment: PlaceholderAlignment.middle)
          .insertBefore(anchorBit);

      for (final rubyBit in rubyBits) {
        rubyTree.add(rubyBit.copyWith(parent: rubyTree));
        rubyBit.detach();
      }
      rubyBits.clear();
      rtBit.detach();
    }
  }
}

class _RtBit extends BuildBit<Null> {
  final BuildMetadata meta;
  final BuildTree tree;

  _RtBit(BuildTree parent, TextStyleBuilder tsb, this.meta, this.tree)
      : super(parent, tsb);

  @override
  void buildBit(Null _) => '';

  @override
  BuildBit copyWith({BuildTree parent, TextStyleBuilder tsb}) =>
      _RtBit(parent ?? this.parent, tsb ?? this.tsb, meta, tree);
}
