import 'dart:math';

import 'package:flutter/widgets.dart';

import '../core_data.dart';
import '../core_helpers.dart';

class HeightPlaceholder extends WidgetPlaceholder {
  final List<_Height> _heights;

  HeightPlaceholder(
    CssLength height,
    InheritanceResolvers inheritanceResolvers, {
    String? debugLabel,
    Key? key,
  }) : this._(
          [_Height(height, inheritanceResolvers)],
          debugLabel: debugLabel,
          key: key,
        );

  HeightPlaceholder._(
    this._heights, {
    super.debugLabel,
    super.key,
  }) : super(builder: (c, w) => _build(c, w, _heights));

  @override
  Widget build(BuildContext context) {
    if (context._skipBuildOrZero > 0) {
      return this;
    } else {
      return super.build(context);
    }
  }

  /// Returns a new placeholder that renders the largest height of both.
  ///
  /// Neither placeholder is modified: they are reused across rebuilds.
  HeightPlaceholder mergedWith(HeightPlaceholder other) => HeightPlaceholder._(
        [..._heights, ...other._heights],
        debugLabel: debugLabel,
        key: key,
      );

  @override
  HeightPlaceholder wrapWith(
    Widget? Function(BuildContext context, Widget child) builder,
  ) =>
      this;

  static Widget _build(
    BuildContext context,
    Widget child,
    List<_Height> heights,
  ) {
    var max = 0.0;
    for (final height in heights) {
      final value = height.height.getValue(
        height.inheritanceResolvers.resolve(context),
      );
      if (value != null && value > max) {
        max = value;
      }
    }

    final existing = (child is SizedBox ? child.height : null) ?? 0.0;
    return max > existing ? SizedBox(height: max) : child;
  }
}

@immutable
class _Height {
  final CssLength height;
  final InheritanceResolvers inheritanceResolvers;

  const _Height(this.height, this.inheritanceResolvers);
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
