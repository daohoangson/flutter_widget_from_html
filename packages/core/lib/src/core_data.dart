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

/// {@template flutter_widget_from_html.defaultStyles}
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
/// {@endtemplate}
typedef DefaultStyles = Map<String, String> Function(BuildTree tree);

/// {@template flutter_widget_from_html.onChild}
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
/// ```
/// {@endtemplate}
typedef OnChild = void Function(BuildTree tree, BuildTree subTree);

/// {@template flutter_widget_from_html.onTree}
/// The callback that will be called when child elements have been processed.
/// {@endtemplate}
typedef OnTree = void Function(BuildTree tree);

/// {@template flutter_widget_from_html.onFlattening}
/// The callback that will be called before flattening.
///
/// This is the last chance to modify the [BuildTree] before inline rendering.
/// {@endtemplate}
typedef OnFlattening = void Function(BuildTree tree);

/// {@template flutter_widget_from_html.onBuilt}
/// The callback that will be called after building widget.
///
/// This only works if it's a block element.
/// {@endtemplate}
typedef OnBuilt = Widget? Function(
  BuildTree tree,
  WidgetPlaceholder placeholder,
);

/// A building operation to customize how a DOM element is rendered.
@immutable
class BuildOp {
  /// A human-readable description of this op.
  final String? debugLabel;

  /// The execution priority, op with lower priority will run first.
  ///
  /// Default: 10.
  final int priority;

  /// {@macro flutter_widget_from_html.defaultStyles}
  final DefaultStyles? defaultStyles;

  /// Controls whether the element must be rendered as a block.
  ///
  /// Default: `true` if [onBuilt] is set, `false` otherwise.
  ///
  /// If an element has multiple build ops and one of them require block rendering,
  /// it will be rendered as block.
  final bool? mustBeBlock;

  /// {@macro flutter_widget_from_html.onChild}
  final OnChild? onChild;

  /// {@macro flutter_widget_from_html.onTree}
  final OnTree? onTree;

  /// {@macro flutter_widget_from_html.onFlattening}
  ///
  /// If an op has both this callback and [onBuilt], it will be skipped if
  /// `onBuilt` returns a non-null result.
  final OnFlattening? onFlattening;

  /// {@macro flutter_widget_from_html.onBuilt}
  ///
  /// If an op has both this callback and [onFlattening], returning
  /// a non-null result will skip `onFlattening`.
  final OnBuilt? onBuilt;

  /// Creates a build op.
  const BuildOp({
    this.debugLabel,
    this.priority = 10,
    this.defaultStyles,
    this.mustBeBlock,
    this.onChild,
    this.onTree,
    this.onFlattening,
    this.onBuilt,
  });
}
