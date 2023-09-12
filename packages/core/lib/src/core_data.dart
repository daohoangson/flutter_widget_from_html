import 'package:csslib/visitor.dart' as css;
import 'package:flutter/widgets.dart';
import 'package:html/dom.dart' as dom;

import 'core_helpers.dart';
import 'core_legacy.dart';
import 'core_widget_factory.dart';

part 'data/build_bits.dart';
part 'data/css.dart';
part 'data/html_style.dart';
part 'data/image.dart';
part 'data/normal_line_height.dart';

/// A collection of style's key and value pairs.
typedef StylesMap = Map<String, String>;

/// {@template flutter_widget_from_html.defaultStyles}
/// The callback that should return default styling map.
///
/// See list of all supported inline stylings in README.md, the sample op
/// below just changes the color:
///
/// ```dart
/// BuildOp.v1(
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
/// BuildOp.v1(
///   onChild: (tree, subTree) {
///     if (subTree.element.parent != tree.element) return;
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
/// The callback that will be called during widget build.
///
/// Returning a new placeholder is allowed.
///
/// This only works if it's a block element.
/// {@endtemplate}
typedef OnRenderBlock = Widget Function(
  BuildTree tree,
  WidgetPlaceholder placeholder,
);

/// {@template flutter_widget_from_html.onRenderInline}
/// The callback that will be called before flattening.
///
/// This is the last chance to modify the [BuildTree] for inline rendering.
/// {@endtemplate}
typedef OnRenderInline = void Function(BuildTree tree);

/// {@template flutter_widget_from_html.onRenderedBlock}
/// The callback that will be called after widget has been built.
///
/// This cannot return a different placeholder,
/// use [BuildOp.onRenderBlock] for that.
/// {@endtemplate}
typedef OnRenderedBlock = void Function(BuildTree tree, Widget block);

/// A building operation to customize how a DOM element is rendered.
@immutable
class BuildOp {
  /// Controls whether the element must be rendered as a block.
  ///
  /// Default: `true` if [onRenderBlock] is set, `false` otherwise.
  ///
  /// If an element has multiple build ops and one of them require block rendering,
  /// it will be rendered as block.
  final bool? alwaysRenderBlock;

  /// A human-readable description of this op.
  final String? debugLabel;

  /// {@macro flutter_widget_from_html.defaultStyles}
  final DefaultStyles? defaultStyles;

  /// {@macro flutter_widget_from_html.onChild}
  final OnChild? onChild;

  /// {@macro flutter_widget_from_html.onParsed}
  final OnParsed? onParsed;

  /// {@macro flutter_widget_from_html.onRenderBlock}
  final OnRenderBlock? onRenderBlock;

  /// {@macro flutter_widget_from_html.onRenderInline}
  final OnRenderInline? onRenderInline;

  /// {@macro flutter_widget_from_html.onRenderedBlock}
  final OnRenderedBlock? onRenderedBlock;

  /// The execution priority, op with lower priority will run first.
  ///
  /// Default: 10.
  final int priority;

  /// Creates a legacy build op.
  @Deprecated('Use BuildOp.v1 instead.')
  factory BuildOp({
    Map<String, String> Function(dom.Element element)? defaultStyles,
    void Function(BuildMetadata subTree)? onChild,
    void Function(BuildMetadata meta, BuildTree tree)? onTree,
    void Function(BuildMetadata meta, BuildTree tree)? onTreeFlattening,
    Iterable<Widget>? Function(
      BuildTree tree,
      Iterable<WidgetPlaceholder> children,
    )? onWidgets,
    bool onWidgetsIsOptional = false,
    int priority = 10,
  }) {
    return BuildOp.v1(
      alwaysRenderBlock: onWidgetsIsOptional ? null : (onWidgets != null),
      defaultStyles:
          defaultStyles != null ? (tree) => defaultStyles(tree.element) : null,
      onChild: onChild != null ? (_, subTree) => onChild(subTree) : null,
      onParsed: onTree != null
          ? (tree) {
              onTree(tree, tree);
              return tree;
            }
          : null,
      onRenderBlock: onWidgets != null
          ? (tree, placeholder) {
              final children = onWidgets(tree, [placeholder]);
              switch (children?.length) {
                case null:
                  return placeholder;
                case 0:
                  return widget0;
                case 1:
                  return children?.first ?? widget0;
                default:
                  throw UnsupportedError(
                    'onWidgets must return exactly 1 widget, got ${children?.length}',
                  );
              }
            }
          : null,
      onRenderInline: onTreeFlattening != null
          ? (tree) => onTreeFlattening(tree, tree)
          : null,
      priority: priority,
    );
  }

  /// Creates a build op.
  const BuildOp.v1({
    this.alwaysRenderBlock,
    this.debugLabel,
    this.defaultStyles,
    this.onChild,
    this.onParsed,
    this.onRenderBlock,
    this.onRenderInline,
    this.onRenderedBlock,
    this.priority = 10,
  });
}
