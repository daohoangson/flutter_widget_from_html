part of '../core_ops.dart';

const kTagQ = 'q';

class TagQ {
  final WidgetFactory wf;

  TagQ(this.wf);

  BuildOp get buildOp => BuildOp(
        onTree: (_, tree) =>
            wrapTree(tree, append: _TagQBit.closing, prepend: _TagQBit.opening),
      );
}

class _TagQBit extends BuildBit<void, String> {
  final bool isOpening;

  const _TagQBit(
    BuildTree parent,
    TextStyleBuilder tsb, {
    required this.isOpening,
  }) : super(parent, tsb);

  @override
  String buildBit(void _) => isOpening ? '“' : '”';

  @override
  BuildBit copyWith({BuildTree? parent, TextStyleBuilder? tsb}) =>
      _TagQBit(parent ?? this.parent!, tsb ?? this.tsb, isOpening: isOpening);

  @override
  String toString() =>
      'QBit.${isOpening ? "opening" : "closing"}#$hashCode $tsb';

  static BuildBit closing(BuildTree parent) =>
      _TagQBit(parent, parent.tsb, isOpening: false);

  static BuildBit opening(BuildTree parent) =>
      _TagQBit(parent, parent.tsb, isOpening: true);
}
