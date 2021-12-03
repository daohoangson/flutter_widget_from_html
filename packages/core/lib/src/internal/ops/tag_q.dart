part of '../core_ops.dart';

const kTagQ = 'q';

class TagQ {
  final WidgetFactory wf;

  TagQ(this.wf);

  BuildOp get buildOp => BuildOp(
        onTree: (_, tree) => tree
          ..prepend(TextBit(tree, '“'))
          ..append(TextBit(tree, '”')),
      );
}
