import 'package:csslib/visitor.dart' as css;
import 'package:flutter/widgets.dart';
import 'package:fwfh_text_style/fwfh_text_style.dart';
import 'package:html/dom.dart' as dom;

import 'core_helpers.dart';

part 'data/build_bits.dart';
part 'data/css.dart';
part 'data/image.dart';
part 'data/text_style.dart';

/// A building element metadata.
abstract class BuildMetadata {
  /// The associated element.
  final dom.Element element;

  /// The associated [TextStyleBuilder].
  final TextStyleBuilder tsb;

  /// The maximum number of lines for the text to span.
  ///
  /// Used in [WidgetFactory.buildText] for [RichText.maxLines].
  int maxLines = -1;

  /// How visual overflow should be handled.
  ///
  /// Used in [WidgetFactory.buildText] for [RichText.overflow].
  TextOverflow overflow = TextOverflow.clip;

  /// Creates a node.
  BuildMetadata(this.element, this.tsb);

  /// The registered build ops.
  Iterable<BuildOp> get buildOps;

  /// The parents' build ops that have [BuildOp.onChild].
  Iterable<BuildOp> get parentOps;

  /// The styling declarations.
  ///
  /// These are collected from:
  ///
  /// - [WidgetFactory.parse] or [BuildOp.onChild] via `meta[key] = value`
  /// - [BuildOp.defaultStyles] returning a map
  /// - Attribute `style` of [domElement]
  List<css.Declaration> get styles;

  /// Adds an inline style.
  void operator []=(String key, String value);

  /// Gets a styling declaration by `property`.
  css.Declaration? operator [](String key) {
    for (final style in styles.reversed) {
      if (style.property == key) {
        return style;
      }
    }
    return null;
  }

  /// Registers a build op.
  void register(BuildOp op);

  @override
  String toString() => 'BuildMetadata(${element.outerHtml})';
}

/// A building operation to customize how a DOM element is rendered.
@immutable
class BuildOp {
  /// The recommended maximum value for [priority].
  ///
  /// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number/MAX_SAFE_INTEGER
  static const kPriorityMax = 9007199254740991;

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

  /// The callback that will be called whenver a child element is found.
  ///
  /// Please note that all children and grandchildren etc. will trigger this,
  /// it's easy to check whether an element is direct child:
  ///
  /// ```dart
  /// BuildOp(
  ///   onChild: (childMeta) {
  ///     if (!childElement.element.parent != parentMeta.element) return;
  ///     childMeta.doSomethingHere;
  ///   },
  /// );
  ///
  /// ```
  final void Function(BuildMetadata childMeta)? onChild;

  /// The callback that will be called when child elements have been processed.
  final void Function(BuildMetadata meta, BuildTree tree)? onTree;

  /// The callback that will be called before flattening.
  final void Function(BuildMetadata meta, BuildTree tree)? onTreeFlattening;

  /// The callback that will be called when child elements have been built.
  ///
  /// Note: only works if it's a block element.
  final Iterable<Widget>? Function(
    BuildMetadata meta,
    Iterable<WidgetPlaceholder> widgets,
  )? onWidgets;

  /// Controls whether the element should be forced to be rendered as block.
  ///
  /// Default: `false`.
  final bool onWidgetsIsOptional;

  /// Creates a build op.
  const BuildOp({
    this.defaultStyles,
    this.onChild,
    this.onTree,
    this.onTreeFlattening,
    this.onWidgets,
    this.onWidgetsIsOptional = false,
    this.priority = 10,
  });
}
