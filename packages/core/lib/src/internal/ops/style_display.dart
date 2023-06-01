part of '../core_ops.dart';

extension StyleDisplayInlineBlock on WidgetFactory {
  BuildOp get displayInlineBlock => const BuildOp.v1(
        debugLabel: 'display: inline-block',
        onParsed: _onParsed,
        priority: Late.displayInlineBlock,
      );

  static BuildTree _onParsed(BuildTree tree) {
    final parent = tree.parent;
    if (parent == null) {
      return tree;
    }

    return parent.sub()
      ..append(
        WidgetBit.inline(
          parent,
          WidgetPlaceholder(
            builder: (_, __) => tree.build(),
            debugLabel: kCssDisplayInlineBlock,
          ),
          alignment: PlaceholderAlignment.baseline,
        ),
      );
  }
}

extension StyleDisplayNone on WidgetFactory {
  BuildOp get displayNone => const BuildOp.v1(
        debugLabel: 'display: none',
        onParsed: _onParsed,
        priority: Late.displayNone,
      );

  static BuildTree _onParsed(BuildTree tree) => tree.parent?.sub() ?? tree;
}
