part of '../core_ops.dart';

const kTagQ = 'q';

class TagQ {
  final WidgetFactory wf;

  TagQ(this.wf);

  BuildOp get buildOp => BuildOp(
        onTree: (_, t) => wrapTree(t, append: _closing, prepend: _opening),
      );

  static BuildBit _closing(BuildTree parent) =>
      TextBit(parent, '”', tsb: parent.tsb);

  static BuildBit _opening(BuildTree parent) =>
      TextBit(parent, '“', tsb: parent.tsb);
}
