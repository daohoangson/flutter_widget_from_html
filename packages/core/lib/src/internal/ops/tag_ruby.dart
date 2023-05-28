part of '../core_ops.dart';

const kTagRuby = 'ruby';
const kTagRp = 'rp';
const kTagRt = 'rt';

class TagRuby {
  BuildOp get buildOp => BuildOp(
        debugLabel: kTagRuby,
        onChild: (tree, subTree) {
          final e = subTree.element;
          if (e.parent != tree.element) {
            return;
          }

          switch (e.localName) {
            case kTagRp:
              subTree.register(
                const BuildOp(
                  debugLabel: kTagRp,
                  defaultStyles: _cssDisplayNone,
                  priority: Early.tagRp,
                ),
              );
              break;
            case kTagRt:
              subTree.apply(TextStyleOps.fontSizeEm, .5);
              break;
          }
        },
        onParsed: (tree) {
          final replacement = tree.parent?.sub();
          if (replacement == null) {
            return tree;
          }

          final rubyBits = <BuildBit>[];
          for (final bit in tree.children) {
            if (!bit.isRtTree || rubyBits.isEmpty) {
              if (rubyBits.isEmpty && bit is WhitespaceBit) {
                // ruby contents should not start with a whitespace
                replacement.append(bit);
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

            replacement.append(
              WidgetBit.inline(
                replacement,
                WidgetPlaceholder(
                  builder: (_, __) => HtmlRuby(
                    rt: rtTree.build(),
                    ruby: rubyTree.build(),
                  ),
                  debugLabel: kTagRuby,
                ),
                alignment: PlaceholderAlignment.baseline,
              ),
            );
          }

          for (final rubyBit in rubyBits) {
            // preserve orphan bits if any
            replacement.append(rubyBit);
          }

          return replacement;
        },
        priority: Priority.tagRuby,
      );

  static StylesMap _cssDisplayNone(BuildTree _) =>
      {kCssDisplay: kCssDisplayNone};
}

extension on BuildBit {
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
