part of '../core_ops.dart';

extension BuildTreeEllipsis on BuildTree {
  _BuildTreeEllipsis get _ellipsis =>
      getNonInherited<_BuildTreeEllipsis>() ??
      setNonInherited(const _BuildTreeEllipsis());

  int get maxLines => _ellipsis.maxLines;

  set maxLines(int value) =>
      setNonInherited<_BuildTreeEllipsis>(_ellipsis.copyWith(maxLines: value));

  TextOverflow get overflow => _ellipsis.overflow;

  set overflow(TextOverflow value) =>
      setNonInherited<_BuildTreeEllipsis>(_ellipsis.copyWith(overflow: value));
}

@immutable
class _BuildTreeEllipsis {
  final int maxLines;
  final TextOverflow overflow;

  const _BuildTreeEllipsis({
    this.maxLines = -1,
    this.overflow = TextOverflow.clip,
  });

  _BuildTreeEllipsis copyWith({
    int? maxLines,
    TextOverflow? overflow,
  }) =>
      _BuildTreeEllipsis(
        maxLines: maxLines ?? this.maxLines,
        overflow: overflow ?? this.overflow,
      );
}
