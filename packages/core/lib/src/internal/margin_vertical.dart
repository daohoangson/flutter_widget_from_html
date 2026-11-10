import 'dart:math';

import 'package:flutter/widgets.dart';

import '../core_data.dart';
import '../core_helpers.dart';

class HeightPlaceholder extends WidgetPlaceholder {
  final InheritanceResolvers inheritanceResolvers;

  final List<CssLength> _heights = [];

  HeightPlaceholder(
    CssLength height,
    this.inheritanceResolvers, {
    super.debugLabel,
    super.key,
  }) : super(builder: (c, w) => _build(c, w, height, inheritanceResolvers)) {
    _heights.add(height);
  }

  CssLength get height => _heights.first;

  @override
  Widget build(BuildContext context) {
    if (context._skipBuildOrZero > 0) {
      return this;
    } else {
      return super.build(context);
    }
  }

  void mergeWith(HeightPlaceholder other) {
    final height = other.height;
    _heights.add(height);

    super.wrapWith((c, w) => _build(c, w, height, other.inheritanceResolvers));
  }

  @override
  HeightPlaceholder wrapWith(
    Widget? Function(BuildContext context, Widget child) builder,
  ) =>
      this;

  static Widget _build(
    BuildContext context,
    Widget child,
    CssLength height,
    InheritanceResolvers inheritanceResolvers,
  ) {
    final existing = (child is SizedBox ? child.height : null) ?? 0.0;
    final value = height.getValue(inheritanceResolvers.resolve(context));
    if (value != null && value > existing) {
      return SizedBox(height: value);
    }
    return child;
  }
}

/// An extension on [BuildContext].
extension SkipBuildHeightPlaceholder on BuildContext {
  static final _skipBuild = Expando<int>();

  /// Sets whether to skip building [HeightPlaceholder]s.
  ///
  /// This type of placeholder has special merging logic so they need
  /// to be preserved during column contents traversal.
  set skipBuildHeightPlaceholder(bool newValue) {
    final delta = newValue ? 1 : -1;
    final newCounter = _skipBuildOrZero + delta;
    _skipBuild[this] = max(0, newCounter);
  }

  int get _skipBuildOrZero => _skipBuild[this] ?? 0;
}
