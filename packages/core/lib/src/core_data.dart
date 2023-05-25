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

/// A collection of style's key and value pairs.
typedef StylesMap = Map<String, String>;

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
typedef DefaultStyles = StylesMap Function(BuildTree tree);

/// {@template flutter_widget_from_html.onChild}
/// The callback that will be called before processing a child element.
///
/// Please note that all children and grandchildren etc. will trigger this,
/// it's easy to check whether an element is direct child:
///
/// ```dart
/// BuildOp(
///   onChild: (tree, subTree) {
///     if (!subTree.element.parent != tree.element) return;
///     subTree.doSomething();
///   },
/// );
/// ```
/// {@endtemplate}
typedef OnChild = void Function(BuildTree tree, BuildTree subTree);

/// {@template flutter_widget_from_html.onParsed}
/// The callback that will be called when child elements have been processed.
///
/// Returning a different build tree is allowed.
/// {@endtemplate}
typedef OnParsed = BuildTree Function(BuildTree tree);

/// {@template flutter_widget_from_html.onRenderBlock}
/// The callback that will be called after building widget.
///
/// This only works if it's a block element.
/// {@endtemplate}
typedef OnRenderBlock = Widget? Function(
  BuildTree tree,
  WidgetPlaceholder placeholder,
);

/// {@template flutter_widget_from_html.onRenderInline}
/// The callback that will be called before flattening.
///
/// This is the last chance to modify the [BuildTree] for inline rendering.
/// {@endtemplate}
typedef OnRenderInline = void Function(BuildTree tree);

/// A building operation to customize how a DOM element is rendered.
@immutable
class BuildOp {
  /// A human-readable description of this op.
  final String? debugLabel;

  /// {@macro flutter_widget_from_html.defaultStyles}
  final DefaultStyles? defaultStyles;

  /// Controls whether the element must be rendered as a block.
  ///
  /// Default: `true` if [onRenderBlock] is set, `false` otherwise.
  ///
  /// If an element has multiple build ops and one of them require block rendering,
  /// it will be rendered as block.
  final bool? mustBeBlock;

  /// {@macro flutter_widget_from_html.onChild}
  final OnChild? onChild;

  /// {@macro flutter_widget_from_html.onParsed}
  final OnParsed? onParsed;

  /// {@macro flutter_widget_from_html.onRenderBlock}
  ///
  /// If an op has both this callback and [onRenderInline], returning
  /// a non-null result will skip `onRenderInline`.
  final OnRenderBlock? onRenderBlock;

  /// {@macro flutter_widget_from_html.onRenderInline}
  ///
  /// If an op has both this callback and [onRenderBlock], it will be skipped if
  /// `onRenderBlock` returns a non-null result.
  final OnRenderInline? onRenderInline;

  /// The execution priority, op with lower priority will run first.
  ///
  /// Default: 10.
  final int priority;

  /// Creates a build op.
  const BuildOp({
    this.debugLabel,
    this.defaultStyles,
    this.mustBeBlock,
    this.onChild,
    this.onParsed,
    this.onRenderBlock,
    this.onRenderInline,
    this.priority = 10,
  });
}
