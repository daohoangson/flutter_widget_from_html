part of '../core_ops.dart';

const kTagBr = 'br';

class TagBr {
  final WidgetFactory wf;

  TagBr(this.wf);

  BuildOp get buildOp => BuildOp(
        debugLabel: kTagBr,
        onTree: (tree) => tree.append(TagBrBit(tree)),
        priority: Prioritiy.tagBr,
      );
}

class TagBrBit extends BuildBit {
  const TagBrBit(BuildTree? parent) : super(parent);

  @override
  bool get swallowWhitespace => true;

  @override
  BuildBit copyWith({BuildTree? parent}) => TagBrBit(parent ?? this.parent);

  @override
  void flatten(Flattened f) => f.write(text: '\n');

  @override
  String toString() => '<BR />';
}
