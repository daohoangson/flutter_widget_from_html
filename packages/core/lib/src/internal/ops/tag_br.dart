part of '../core_ops.dart';

const kTagBr = 'br';

class TagBr {
  final WidgetFactory wf;

  TagBr(this.wf);

  BuildOp get buildOp => BuildOp(onTree: (_, tree) => tree.add(TagBrBit(tree)));
}

class TagBrBit extends BuildBit {
  TagBrBit(BuildTree parent, {HtmlStyleBuilder? tsb})
      : super(parent, tsb ?? parent.tsb);

  @override
  bool get swallowWhitespace => true;

  @override
  BuildBit copyWith({BuildTree? parent, HtmlStyleBuilder? tsb}) =>
      TagBrBit(parent ?? this.parent!, tsb: tsb ?? this.tsb);

  @override
  void flatten(Flattened f) => f.text = '\n';

  @override
  String toString() => '<BR />';
}
