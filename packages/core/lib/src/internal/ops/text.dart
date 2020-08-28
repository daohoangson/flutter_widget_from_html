part of '../core_ops.dart';

void wrapBuildBits(
  BuildTree tree, {
  BuildBit Function(BuildTree parent) appendBuilder,
  BuildBit Function(BuildTree parent) prependBuilder,
}) {
  if (tree.isEmpty) {
    if (prependBuilder != null) tree.add(prependBuilder(tree));
    if (appendBuilder != null) tree.add(appendBuilder(tree));
    return;
  }

  final first = tree.first;
  final last = tree.last;
  if (prependBuilder != null) prependBuilder(first.parent).insertBefore(first);
  if (appendBuilder != null) appendBuilder(last.parent).insertAfter(last);
}
