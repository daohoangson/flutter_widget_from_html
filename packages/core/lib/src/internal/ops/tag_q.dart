part of '../core_ops.dart';

const kTagQ = 'q';

class TagQ {
  BuildOp get buildOp => BuildOp(
        debugLabel: kTagQ,
        onParsed: (tree) {
          const opening = '“';
          const closing = '”';
          final firstParent = tree.first?.parent;
          final lastParent = tree.last?.parent;
          if (firstParent == null || lastParent == null) {
            tree
              ..prepend(TextBit(tree, opening))
              ..append(TextBit(tree, closing));
            return;
          }

          firstParent.prepend(TextBit(firstParent, opening));
          lastParent.append(TextBit(lastParent, closing));
        },
        priority: Prioritiy.tagQ,
      );
}
