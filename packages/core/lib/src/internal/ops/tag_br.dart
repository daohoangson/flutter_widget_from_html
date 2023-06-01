part of '../core_ops.dart';

const kTagBr = 'br';

extension TagBr on WidgetFactory {
  BuildOp get tagBr => const BuildOp.v1(
        debugLabel: kTagBr,
        onParsed: _onParsed,
        priority: Priority.tagBr,
      );

  static BuildTree _onParsed(BuildTree tree) => tree..append(TagBrBit(tree));
}

class TagBrBit extends BuildBit {
  const TagBrBit(BuildTree? parent) : super(parent);

  @override
  bool? get swallowWhitespace => true;

  @override
  BuildBit copyWith({BuildTree? parent}) => TagBrBit(parent ?? this.parent);

  @override
  void flatten(Flattened f) => f.write(text: '\n');

  @override
  String toString() => '<BR />';
}
