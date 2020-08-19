import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:html/dom.dart' as dom;

import 'internal/margin_vertical.dart';
import 'core_helpers.dart';
import 'core_widget_factory.dart';

part 'data/css.dart';
part 'data/image.dart';
part 'data/table.dart';
part 'data/text_bits.dart';
part 'data/text_style.dart';

/// A building operation to customize how a DOM element is rendered.
@immutable
class BuildOp {
  /// Controls whether the element should be rendered with [CssBlock].
  ///
  /// Default: `true` if [onWidgets] callback is set, `false` otherwise.
  final bool isBlockElement;

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
  /// in [WidgetFactory.parseTag] or [onChild].
  final Map<String, String> Function(NodeMetadata meta) defaultStyles;

  /// The callback that will be called whenver a child element is found.
  ///
  /// Please note that all children and grandchildren etc. will trigger this method,
  /// it's easy to check whether an element is direct child:
  ///
  /// ```dart
  /// BuildOp(
  ///   onChild: (childMeta) {
  ///     if (!childElement.domElement.parent != parentMeta.domElement) return;
  ///     childMeta.doSomethingHere;
  ///   },
  /// );
  ///
  /// ```
  final void Function(NodeMetadata childMeta) onChild;

  /// The callback that will be called when child elements have been processed.
  final Iterable<BuiltPiece> Function(
      NodeMetadata meta, Iterable<BuiltPiece> pieces) onPieces;

  /// The callback that will be called when child elements have been built.
  ///
  /// Note: only works if it's a block element.
  final Iterable<Widget> Function(
      NodeMetadata meta, Iterable<WidgetPlaceholder> widgets) onWidgets;

  /// Creates a build op.
  BuildOp({
    this.defaultStyles,
    bool isBlockElement,
    this.onChild,
    this.onPieces,
    this.onWidgets,
    this.priority = 10,
  }) : isBlockElement = isBlockElement ?? onWidgets != null;
}

/// An intermediate data piece while the widget tree is being built.
class BuiltPiece {
  /// The text bits.
  final TextBits text;

  /// The widgets.
  final Iterable<WidgetPlaceholder> widgets;

  /// Creates a text piece.
  BuiltPiece.text(this.text) : widgets = null;

  /// Creates a piece with widgets.
  BuiltPiece.widgets(Iterable<Widget> widgets)
      : text = null,
        widgets = widgets.map(_placeholder);

  static WidgetPlaceholder _placeholder(Widget widget) =>
      widget is WidgetPlaceholder
          ? widget
          : WidgetPlaceholder<Widget>(widget, child: widget);
}

/// A DOM node.
abstract class NodeMetadata {
  /// The associatd DOM element.
  final dom.Element domElement;

  final TextStyleBuilder _tsb;

  /// Controls whether the node is renderable.
  bool isNotRenderable;

  /// Creates a node.
  NodeMetadata(this.domElement, this._tsb);

  /// The registered build ops.
  Iterable<BuildOp> get buildOps;

  /// Returns `true` if node should be rendered as block.
  bool get isBlockElement;

  /// The parents' build ops that have [BuildOp.onChild].
  Iterable<BuildOp> get parentOps;

  /// The inline styles.
  ///
  /// These are usually collected from:
  ///
  /// - [WidgetFactory.parseTag] or [BuildOp.onChild] by calling `meta[key] = value`
  /// - [BuildOp.defaultStyles] returning a map
  /// - Attribute `style` of [domElement]
  Iterable<MapEntry<String, String>> get styles;

  /// Sets whether node should be rendered as block.
  set isBlockElement(bool value);

  /// Adds an inline style.
  operator []=(String key, String value);

  /// Gets an inline style value by key.
  String operator [](String key) {
    String value;
    for (final x in styles) {
      if (x.key == key) value = x.value;
    }
    return value;
  }

  /// Registers a build op.
  void register(BuildOp op);

  /// Enqueues a text style builder callback.
  ///
  /// Returns the associated [TextStyleBuilder].
  TextStyleBuilder tsb<T>([
    TextStyleHtml Function(TextStyleHtml, T) builder,
    T input,
  ]) =>
      _tsb..enqueue(builder, input);
}
