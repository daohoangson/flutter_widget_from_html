import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:html/dom.dart' as dom;

import 'internal/margin_vertical.dart';
import 'core_helpers.dart';
import 'core_widget_factory.dart';
import 'internal/tsh_widget.dart';

part 'data/table.dart';
part 'data/text_bits.dart';

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
          : WidgetPlaceholder<Widget>(child: widget, generator: widget);
}

/// A border.
@immutable
class CssBorderSide {
  /// The border color.
  final Color color;

  /// The border style.
  final TextDecorationStyle style;

  /// The border width (thickness).
  final CssLength width;

  /// Creates a border.
  CssBorderSide({this.color, this.style, this.width});
}

/// A length measurement.
@immutable
class CssLength {
  /// The measurement number.
  final double number;

  /// The measurement unit.
  final CssLengthUnit unit;

  /// Creates a measurement.
  ///
  /// [number] must not be negative.
  CssLength(
    this.number, [
    this.unit = CssLengthUnit.px,
  ])  : assert(!number.isNegative),
        assert(unit != null);

  /// Returns `true` if value is non-zero.
  bool get isNotEmpty => number > 0;

  /// Calculates value in logical pixel.
  double getValue(TextStyleHtml tsh, {double baseValue, double scaleFactor}) {
    double value;
    switch (unit) {
      case CssLengthUnit.em:
        baseValue ??= tsh.style.fontSize;
        value = baseValue * number;
        scaleFactor = 1;
        break;
      case CssLengthUnit.percentage:
        if (baseValue == null) return null;
        value = baseValue * number / 100;
        scaleFactor = 1;
        break;
      case CssLengthUnit.pt:
        value = number * 96 / 72;
        break;
      case CssLengthUnit.px:
        value = number;
        break;
    }

    if (value == null) return null;
    if (scaleFactor != null) value *= scaleFactor;

    return value;
  }
}

/// A set of length measurements.
@immutable
class CssLengthBox {
  /// The bottom measurement.
  final CssLength bottom;

  /// The inline end (right) measurement.
  final CssLength inlineEnd;

  /// The inline start (left) measurement.
  final CssLength inlineStart;

  final CssLength _left;

  final CssLength _right;

  /// The top measurement.
  final CssLength top;

  /// Creates a set.
  const CssLengthBox({
    this.bottom,
    this.inlineEnd,
    this.inlineStart,
    CssLength left,
    CssLength right,
    this.top,
  })  : _left = left,
        _right = right;

  /// Creates a copy with the given measurements replaced with the new values.
  CssLengthBox copyWith({
    CssLength bottom,
    CssLength inlineEnd,
    CssLength inlineStart,
    CssLength left,
    CssLength right,
    CssLength top,
  }) =>
      CssLengthBox(
        bottom: bottom ?? this.bottom,
        inlineEnd: inlineEnd ?? this.inlineEnd,
        inlineStart: inlineStart ?? this.inlineStart,
        left: left ?? _left,
        right: right ?? _right,
        top: top ?? this.top,
      );

  /// Returns `true` if any of the left, right, inline measurements is set.
  bool get hasLeftOrRight =>
      inlineEnd?.isNotEmpty == true ||
      inlineStart?.isNotEmpty == true ||
      _left?.isNotEmpty == true ||
      _right?.isNotEmpty == true;

  /// Calculates the left value taking text direction into account.
  double getValueLeft(TextStyleHtml tsh) => (_left ??
          (tsh.textDirection == TextDirection.ltr ? inlineStart : inlineEnd))
      ?.getValue(tsh);

  /// Calculates the right value taking text direction into account.
  double getValueRight(TextStyleHtml tsh) => (_right ??
          (tsh.textDirection == TextDirection.ltr ? inlineEnd : inlineStart))
      ?.getValue(tsh);
}

/// Length measurement units.
enum CssLengthUnit {
  /// Relative unit: em.
  em,

  /// Relative unit: percentage.
  percentage,

  /// Absolute unit: points, 1pt = 1/72th of 1in.
  pt,

  /// Absolute unit: pixels, 1px = 1/96th of 1in.
  px,
}

/// A dependency value.
///
/// The list of dependencies are prepared by [WidgetFactory.getDependencies],
/// by default it includes:
///
/// - [MediaQueryData]
/// - [TextDirection]
/// - [TextStyle]
/// - [ThemeData] (enhanced package only)
///
/// If any of these dependencies change, the HTML widget tree will be re-rendered.
/// Use [TextStyleHtml.getDependency] to get dependency value.
///
/// ```dart
/// // in normal widget building:
/// final scale = MediaQuery.of(context).textScaleFactor;
/// final color = Theme.of(context).accentColor;
///
/// // in build ops:
/// final scale = tsh.getDependency<MediaQueryData>().textScaleFactor;
/// final color = tsh.getDependency<ThemeData>().accentColor;
/// ```
///
/// Note about text direction:
/// Because text direction can be changed within the HTML widget tree
/// (by attribute `dir` or inline style `direction`),
/// getting a [TextDirection] via `getDependency` will return out of date information.
/// It's recommended to use [TextStyleHtml.textDirection] instead.
///
/// ```dart
/// final widgetValue = Directionality.of(context);
/// final buildOpValue = tsh.textDirection;
/// ```
@immutable
class HtmlWidgetDependency<T> {
  /// The actual data.
  final T value;

  /// Creates a dependency.
  HtmlWidgetDependency(this.value);
}

/// An image.
@immutable
class ImageMetadata {
  /// The image alternative text.
  final String alt;

  /// The image sources.
  final Iterable<ImageSource> sources;

  /// The image title.
  final String title;

  /// Creates an image.
  ImageMetadata({this.alt, this.sources, this.title});
}

/// An image source.
@immutable
class ImageSource {
  /// The image height.
  final double height;

  /// The image URL.
  final String url;

  /// The image width.
  final double width;

  /// Creates a source.
  ImageSource(this.url, {this.height, this.width}) : assert(url != null);
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

/// A text style.
@immutable
class TextStyleHtml {
  final Iterable<HtmlWidgetDependency> _deps;

  /// The line height.
  final double height;

  /// The number of max lines that should be rendered.
  final int maxLines;

  /// The parent style.
  final TextStyleHtml parent;

  /// The input [TextStyle].
  final TextStyle style;

  /// The text alignment.
  final TextAlign textAlign;

  /// The text direction.
  final TextDirection textDirection;

  /// The overflow behavior.
  final TextOverflow textOverflow;

  /// Creates a text style.
  TextStyleHtml({
    @required Iterable<HtmlWidgetDependency> deps,
    this.height,
    this.maxLines,
    this.parent,
    this.style,
    this.textAlign,
    this.textDirection,
    this.textOverflow,
  }) : _deps = deps;

  /// Creates the root text style.
  factory TextStyleHtml.root(
      Iterable<HtmlWidgetDependency> deps, TextStyle widgetTextStyle) {
    var style = _getDependency<TextStyle>(deps);
    if (widgetTextStyle != null) {
      style = widgetTextStyle.inherit
          ? style.merge(widgetTextStyle)
          : widgetTextStyle;
    }

    var mqd = _getDependency<MediaQueryData>(deps);
    final tsf = mqd.textScaleFactor;
    if (tsf != 1) {
      style = style.copyWith(fontSize: style.fontSize * tsf);
    }

    return TextStyleHtml(
      deps: deps,
      parent: null,
      style: style,
      textDirection: _getDependency<TextDirection>(deps),
    );
  }

  /// Returns a [TextStyle] merged from [style] and [height].
  ///
  /// This needs to be done because
  /// `TextStyle` with existing height cannot be copied with `height=null`.
  /// See [flutter/flutter#58765](https://github.com/flutter/flutter/issues/58765).
  TextStyle get styleWithHeight =>
      height != null && height >= 0 ? style.copyWith(height: height) : style;

  /// Creates a copy with the given fields replaced with the new values.
  TextStyleHtml copyWith({
    double height,
    int maxLines,
    TextStyleHtml parent,
    TextStyle style,
    TextAlign textAlign,
    TextDirection textDirection,
    TextOverflow textOverflow,
  }) =>
      TextStyleHtml(
        deps: _deps,
        height: height ?? this.height,
        maxLines: maxLines ?? this.maxLines,
        parent: parent ?? this.parent,
        style: style ?? this.style,
        textAlign: textAlign ?? this.textAlign,
        textDirection: textDirection ?? this.textDirection,
        textOverflow: textOverflow ?? this.textOverflow,
      );

  /// Gets dependency value by type.
  ///
  /// See [HtmlWidgetDependency].
  T getDependency<T>() => _getDependency<T>(_deps);

  static T _getDependency<T>(Iterable<HtmlWidgetDependency> deps) {
    for (final found in deps.whereType<HtmlWidgetDependency<T>>()) {
      return found.value;
    }

    return null;
  }
}

/// A text styling builder.
class TextStyleBuilder<T1> {
  /// The parent builder.
  final TextStyleBuilder parent;

  List<Function> _builders;
  List _inputs;
  TextStyleHtml _parentOutput;
  TextStyleHtml _output;

  /// Create a builder.
  TextStyleBuilder({this.parent});

  /// Enqueues a callback.
  void enqueue<T2>(
    TextStyleHtml Function(TextStyleHtml, T2) builder, [
    T2 input,
  ]) {
    if (builder == null) return;

    assert(_output == null, 'Cannot add builder after being built');
    _builders ??= [];
    _builders.add(builder);

    _inputs ??= [];
    _inputs.add(input);
  }

  /// Builds a [TextStyleHtml] by calling queued callbacks.
  TextStyleHtml build(BuildContext context) {
    assert(parent != null);
    final parentOutput = parent.build(context);
    if (parentOutput != _parentOutput) {
      _parentOutput = parentOutput;
      _output = null;
    }

    if (_output != null) return _output;
    if (_builders == null) return _output = _parentOutput;

    _output = _parentOutput.copyWith(parent: _parentOutput);
    final l = _builders.length;
    for (var i = 0; i < l; i++) {
      final builder = _builders[i];
      _output = builder(_output, _inputs[i]);
      assert(_output?.parent == _parentOutput);
    }

    return _output;
  }

  /// Returns `true` if this shares same styling with [other].
  bool hasSameStyleWith(TextStyleBuilder other) {
    if (other == null) return false;

    var thisWithBuilder = this;
    while (thisWithBuilder._builders == null) {
      if (thisWithBuilder.parent == null) break;
      thisWithBuilder = thisWithBuilder.parent;
    }

    var otherWithBuilder = other;
    while (otherWithBuilder._builders == null) {
      if (otherWithBuilder.parent == null) break;
      otherWithBuilder = otherWithBuilder.parent;
    }

    return thisWithBuilder == otherWithBuilder;
  }

  /// Creates a sub-builder.
  TextStyleBuilder sub() => TextStyleBuilder(parent: this);
}
