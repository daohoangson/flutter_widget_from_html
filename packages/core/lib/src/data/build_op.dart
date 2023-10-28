part of '../core_data.dart';

const kPriorityDefault = 10;
const kPriorityInlineBlockDefault = 9000003000000000;

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

/// {@template flutter_widget_from_html.onRenderInlineBlock}
/// The callback that will be called after all child nodes have been parsed.
///
/// The returning widget will be rendered inline.
/// Use [BuildOp.inline] to control the alignment and baseline.
/// {@endtemplate}
typedef OnRenderInlineBlock = Widget Function(BuildTree tree, Widget child);

/// {@template flutter_widget_from_html.onRenderedBlock}
/// The callback that will be called after widget has been built.
///
/// This cannot return a different placeholder,
/// use [BuildOp.onRenderBlock] for that.
/// {@endtemplate}
typedef OnRenderedBlock = void Function(BuildTree tree, Widget block);

/// {@template flutter_widget_from_html.onRenderedChildren}
/// The callback that will be called after children widgets has been built.
///
/// If no return value is provided, the default behavior is to wrap the children
/// using [WidgetFactory.buildColumnPlaceholder] before continue with
/// [BuildOp.onRenderBlock] callbacks.
///
/// If there are more than one [BuildOp]s with this callback, the first one
/// returning a non-null value will win.
/// {@endtemplate}
typedef OnRenderedChildren = WidgetPlaceholder? Function(
  BuildTree tree,
  Iterable<WidgetPlaceholder> children,
);

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

  //// {@macro flutter_widget_from_html.onRenderedChildren}
  final OnRenderedChildren? onRenderedChildren;

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
    OnRenderedChildren? onRenderedChildren,
    OnVisitChild? onVisitChild,
    int priority = kPriorityDefault,

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
    final onRenderBlockOrOnWidgets = onRenderBlock ??
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
            : null);

    return BuildOp.v2(
      alwaysRenderBlock: alwaysRenderBlock ??
          (onWidgetsIsOptional ? null : (onRenderBlockOrOnWidgets != null)),
      debugLabel: debugLabel,
      defaultStyles: defaultStyles,
      onParsed: onParsed ??
          (onTree != null
              ? (tree) {
                  onTree(tree, tree);
                  return tree;
                }
              : null),
      onRenderBlock: onRenderBlockOrOnWidgets,
      onRenderInline: onRenderInline ??
          (onTreeFlattening != null
              ? (tree) => onTreeFlattening(tree, tree)
              : null),
      onRenderedBlock: onRenderedBlock,
      onRenderedChildren: onRenderedChildren,
      onVisitChild: onVisitChild ??
          (onChild != null ? (_, subTree) => onChild(subTree) : null),
      priority: priority,
    );
  }

  /// Creates an inline build op.
  factory BuildOp.inline({
    PlaceholderAlignment alignment = PlaceholderAlignment.baseline,
    TextBaseline baseline = TextBaseline.alphabetic,
    String? debugLabel,
    required OnRenderInlineBlock onRenderInlineBlock,
    int priority = kPriorityInlineBlockDefault,
  }) =>
      BuildOp.v2(
        debugLabel: debugLabel,
        onParsed: (tree) {
          final bits = [...tree.bits];
          if (bits.length == 1) {
            final bit = bits.first;
            if (bit is WidgetBit &&
                bit.isInline == true &&
                bit.alignment == alignment &&
                bit.baseline == baseline) {
              // tree has exactly 1 inline bit & all configurations match
              // let's reuse the existing placeholder
              bit.child.wrapWith((_, w) => onRenderInlineBlock(tree, w));
              return tree;
            }
          }

          final parent = tree.parent;
          return parent.sub()
            ..append(
              WidgetBit.inline(
                parent,
                WidgetPlaceholder(
                  debugLabel: debugLabel,
                  child: onRenderInlineBlock(tree, tree.build() ?? widget0),
                ),
                alignment: alignment,
                baseline: baseline,
              ),
            );
        },
        priority: priority,
      );

  /// Creates a second generation build op.
  const BuildOp.v2({
    this.alwaysRenderBlock,
    this.debugLabel,
    this.defaultStyles,
    this.onParsed,
    this.onRenderBlock,
    this.onRenderInline,
    this.onRenderedBlock,
    this.onRenderedChildren,
    this.onVisitChild,
    this.priority = kPriorityDefault,
  });
}
