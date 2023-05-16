import 'package:csslib/visitor.dart' as css;
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:fwfh_text_style/fwfh_text_style.dart';
import 'package:html/dom.dart' as dom;

import 'core_helpers.dart';
import 'core_widget_factory.dart';

part 'data/build_bits.dart';
part 'data/css.dart';
part 'data/html_style.dart';
part 'data/image.dart';

/// A building operation to customize how a DOM element is rendered.
@immutable
class BuildOp {
  /// The recommended maximum value for [priority].
  ///
  /// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number/MAX_SAFE_INTEGER
  static const kPriorityMax = 9007199254740991;

  /// A human-readable description of this op.
  final String? debugLabel;

  /// The execution priority, op with lower priority will run first.
  ///
  /// Default: 10.
  final int priority;

  /// The callback that should return default styling map.
  ///
  /// See list of all supported inline stylings in README.md, the sample op
  /// below just changes the color:
  ///
  /// ```dart
  /// BuildOp(
  ///   defaultStyles: (_) => {'color': 'red'},
  /// )
  /// ```
  ///
  /// Note: op must be registered early for this to work e.g.
  /// in [WidgetFactory.parse] or [onChild].
  final Map<String, String> Function(dom.Element element)? defaultStyles;

  /// The callback that will be called before processing a child element.
  ///
  /// Please note that all children and grandchildren etc. will trigger this,
  /// it's easy to check whether an element is direct child:
  ///
  /// ```dart
  /// BuildOp(
  ///   onSubTree: (tree, subTree) {
  ///     if (!subTree.element.parent != tree.element) return;
  ///     subTree.doSomething();
  ///   },
  /// );
  ///
  /// ```
  final void Function(BuildTree tree, BuildTree subTree)? onChild;

  /// The callback that will be called when child elements have been processed.
  final void Function(BuildTree tree)? onTree;

  /// The callback that will be called before flattening.
  ///
  /// This is the last chance to modify the [BuildTree] before inline rendering.
  ///
  /// If an op has both this callback and [onBuilt], it will be skipped if
  /// `onBuilt` returns a non-null result.
  final void Function(BuildTree tree)? onFlattening;

  /// The callback that will be called when child elements have been built.
  ///
  /// This only works if it's a block element.
  ///
  /// If an op has both this callback and [onFlattening], returning
  /// a non-null result will skip `onTreeFlattening`.
  final Widget? Function(
    BuildTree tree,
    WidgetPlaceholder placeholder,
  )? onBuilt;

  /// Controls whether the element should be forced to be rendered as block.
  ///
  /// Default: `false`.
  /// TODO: rename this
  final bool onWidgetsIsOptional;

  /// Creates a build op.
  const BuildOp({
    this.debugLabel,
    this.priority = 10,
    this.defaultStyles,
    this.onChild,
    this.onTree,
    this.onFlattening,
    this.onBuilt,
    this.onWidgetsIsOptional = false,
  });
}
