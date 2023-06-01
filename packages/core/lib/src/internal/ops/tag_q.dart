part of '../core_ops.dart';

const kTagQ = 'q';

extension TagQ on WidgetFactory {
  BuildOp get tagQ => const BuildOp.v1(
        debugLabel: kTagQ,
        onParsed: _onParsed,
        priority: Priority.tagQ,
      );

  static BuildTree _onParsed(BuildTree tree) {
    const opening = '“';
    const closing = '”';
    final firstParent = tree.first?.parent;
    final lastParent = tree.last?.parent;
    if (firstParent == null || lastParent == null) {
      return tree
        ..prepend(TextBit(tree, opening))
        ..append(TextBit(tree, closing));
    }

    firstParent.prepend(TextBit(firstParent, opening));
    lastParent.append(TextBit(lastParent, closing));
    return tree;
  }
}
