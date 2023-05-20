part of '../core_ops.dart';

const kTagRuby = 'ruby';
const kTagRp = 'rp';
const kTagRt = 'rt';

class TagRuby {
  final WidgetFactory wf;

  TagRuby(this.wf);

  BuildOp get buildOp => BuildOp(
        debugLabel: kTagRuby,
        onChild: (tree, subTree) {
          final e = subTree.element;
          if (e.parent != tree.element) {
            return;
          }

          switch (e.localName) {
            case kTagRp:
              subTree[kCssDisplay] = kCssDisplayNone;
              break;
            case kTagRt:
              subTree[kCssFontSize] = '0.5em';
              break;
          }
        },
        onTree: (tree) {
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

            list.add(
              WidgetBit.inline(
                tree,
                HtmlRuby(
                  rt: rtTree.build(),
                  ruby: rubyTree.build(),
                ),
                alignment: PlaceholderAlignment.baseline,
              ),
            );
          }

          // preserve orphan bits if any
          list.addAll(rubyBits);

          tree.replaceWith(null);
          for (final bit in list) {
            tree.append(bit);
          }
        },
      );
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

    return thiz.element.localName == kTagRt;
  }
}
