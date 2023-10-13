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
part 'data/lockable_list.dart';
part 'data/normal_line_height.dart';

const _defaultPriority = 10;

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
///   defaultStyles: (domElement) => {'color': 'red'},
/// )
/// ```
///
/// Note: op must be registered early for this to work e.g.
/// in [WidgetFactory.parse] or [onVisitChild].
/// {@endtemplate}
typedef DefaultStyles = StylesMap Function(dom.Element element);

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

/// {@template flutter_widget_from_html.onVisitChild}
/// The callback that will be called before processing a child element.
///
/// Please note that all children and grandchildren etc. will trigger this,
/// use `element` to check whether a subtree is direct child:
///
/// ```dart
/// BuildOp(
///   onVisitChild: (tree, subTree) {
///     if (subTree.element.parent != tree.element) return;
///     subTree.doSomething();
///   },
/// );
/// ```
/// {@endtemplate}
typedef OnVisitChild = void Function(BuildTree tree, BuildTree subTree);

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

  /// {@macro flutter_widget_from_html.onParsed}
  final OnParsed? onParsed;

  /// {@macro flutter_widget_from_html.onRenderBlock}
  final OnRenderBlock? onRenderBlock;

  /// {@macro flutter_widget_from_html.onRenderInline}
  final OnRenderInline? onRenderInline;

  /// {@macro flutter_widget_from_html.onRenderedBlock}
  final OnRenderedBlock? onRenderedBlock;

  /// {@macro flutter_widget_from_html.onVisitChild}
  final OnVisitChild? onVisitChild;

  /// The execution priority, op with lower priority will run first.
  ///
  /// Default: 10.
  final int priority;

  /// Creates a build op.
  factory BuildOp({
    bool? alwaysRenderBlock,
    String? debugLabel,
    DefaultStyles? defaultStyles,
    OnParsed? onParsed,
    OnRenderBlock? onRenderBlock,
    OnRenderInline? onRenderInline,
    OnRenderedBlock? onRenderedBlock,
    OnVisitChild? onVisitChild,
    int priority = _defaultPriority,

    // legacy v1 parameters
    @Deprecated('Use onVisitChild instead.')
    void Function(BuildMetadata subTree)? onChild,
    @Deprecated('Use onParsed instead.')
    void Function(BuildMetadata meta, BuildTree tree)? onTree,
    @Deprecated('Use onRenderInline instead.')
    void Function(BuildMetadata meta, BuildTree tree)? onTreeFlattening,
    @Deprecated('Use onRenderBlock instead.')
    Iterable<Widget>? Function(
      BuildMetadata meta,
      Iterable<WidgetPlaceholder> widgets,
    )? onWidgets,
    @Deprecated('Use alwaysRenderBlock instead.')
    bool onWidgetsIsOptional = false,
  }) {
    return BuildOp.v2(
      alwaysRenderBlock: alwaysRenderBlock ??
          (onWidgetsIsOptional ? null : (onWidgets != null)),
      debugLabel: debugLabel,
      defaultStyles: defaultStyles,
      onParsed: onParsed ??
          (onTree != null
              ? (tree) {
                  onTree(tree, tree);
                  return tree;
                }
              : null),
      onRenderBlock: onRenderBlock ??
          (onWidgets != null
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
              : null),
      onRenderInline: onRenderInline ??
          (onTreeFlattening != null
              ? (tree) => onTreeFlattening(tree, tree)
              : null),
      onRenderedBlock: onRenderedBlock,
      onVisitChild: onVisitChild ??
          (onChild != null ? (_, subTree) => onChild(subTree) : null),
      priority: priority,
    );
  }

  /// Creates a second generation build op.
  const BuildOp.v2({
    this.alwaysRenderBlock,
    this.debugLabel,
    this.defaultStyles,
    this.onParsed,
    this.onRenderBlock,
    this.onRenderInline,
    this.onRenderedBlock,
    this.onVisitChild,
    this.priority = _defaultPriority,
  });
}
