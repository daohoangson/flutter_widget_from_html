part of '../core_ops.dart';

const kTagBr = 'br';

extension TagBr on WidgetFactory {
  BuildOp get tagBr => const BuildOp.v2(
        debugLabel: kTagBr,
        onParsed: _onParsed,
        priority: Priority.tagBr,
      );

  static BuildTree _onParsed(BuildTree tree) => tree..append(TagBrBit(tree));
}

class TagBrBit extends BuildBit {
  @override
  final BuildTree parent;

  const TagBrBit(this.parent);

  @override
  bool? get swallowWhitespace => true;

  @override
  BuildBit copyWith({BuildTree? parent}) => TagBrBit(parent ?? this.parent);

  @override
  void flatten(Flattened f) {
    final previousBit = parent.bits.isNotEmpty ? parent.bits.last : null;
    if (previousBit is TagBrBit) {
      // Do not add extra space if the previous bit is also a <br> tag
      return;
    }

    f.write(text: '\n');
  }

  @override
  String toString() => '<BR />';
}
