part of '../core_ops.dart';

extension StyleDisplayInlineBlock on WidgetFactory {
  BuildOp get displayInlineBlock => const BuildOp.v2(
        debugLabel: 'display: inline-block',
        onParsed: _onParsed,
        priority: Late.displayInlineBlock,
      );

  static BuildTree _onParsed(BuildTree tree) {
    final bits = [...tree.bits];
    if (bits.length == 1) {
      final bit = bits.first;
      if (bit is WidgetBit && bit.isInline == true) {
        // tree has exactly 1 inline bit, nothing to do here
        return tree;
      }
    }

    final parent = tree.parent;
    return parent.sub()
      ..append(
        WidgetBit.inline(
          parent,
          WidgetPlaceholder(
            debugLabel: kCssDisplayInlineBlock,
            child: tree.build(),
          ),
        ),
      );
  }
}

extension StyleDisplayNone on WidgetFactory {
  BuildOp get displayNone => const BuildOp.v2(
        debugLabel: 'display: none',
        onParsed: _onParsed,
        priority: Late.displayNone,
      );

  static BuildTree _onParsed(BuildTree tree) => tree.parent.sub();
}
