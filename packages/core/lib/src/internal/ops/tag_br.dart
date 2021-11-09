part of '../core_ops.dart';

const kTagBr = 'br';

class TagBr {
  final WidgetFactory wf;

  TagBr(this.wf);

  BuildOp get buildOp => BuildOp(onTree: (_, tree) => tree.add(TagBrBit(tree)));
}

class TagBrBit extends BuildBit<void, String> {
  TagBrBit(BuildTree parent, {TextStyleBuilder? tsb})
      : super(parent, tsb ?? parent.tsb);

  @override
  bool get swallowWhitespace => true;

  @override
  String buildBit(void _) => '\n';

  @override
  BuildBit copyWith({BuildTree? parent, TextStyleBuilder? tsb}) =>
      TagBrBit(parent ?? this.parent!, tsb: tsb ?? this.tsb);

  @override
  String toString() => '<BR />';
}
