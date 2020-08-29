part of '../core_ops.dart';

const kTagQ = 'q';

class TagQ {
  final WidgetFactory wf;

  TagQ(this.wf);

  BuildOp get buildOp => BuildOp(
        onProcessed: (_, tree) =>
            wrapTree(tree, append: _TagQBit.closing, prepend: _TagQBit.opening),
      );
}

class _TagQBit extends BuildBit<Null> {
  final bool isOpening;

  _TagQBit(BuildTree parent, TextStyleBuilder tsb, this.isOpening)
      : super(parent, tsb);

  @override
  String buildBit(Null _) => isOpening ? '“' : '”';

  @override
  BuildBit copyWith({BuildTree parent, TextStyleBuilder tsb}) =>
      _TagQBit(parent ?? this.parent, tsb ?? this.tsb, isOpening);

  static _TagQBit closing(BuildTree parent) =>
      _TagQBit(parent, parent.tsb, false);

  static _TagQBit opening(BuildTree parent) =>
      _TagQBit(parent, parent.tsb, true);
}
