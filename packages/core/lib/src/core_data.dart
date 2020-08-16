import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:html/dom.dart' as dom;

import 'internal/margin_vertical.dart';
import 'core_helpers.dart';

part 'data/table.dart';
part 'data/text_bits.dart';

@immutable
class BuildOp {
  final bool isBlockElement;

  final int priority;

  final Map<String, String> Function(NodeMetadata meta, dom.Element element)
      defaultStyles;

  final void Function(NodeMetadata childMeta, dom.Element childElement) onChild;

  final Iterable<BuiltPiece> Function(
      NodeMetadata meta, Iterable<BuiltPiece> pieces) onPieces;

  final Iterable<Widget> Function(
      NodeMetadata meta, Iterable<WidgetPlaceholder> widgets) onWidgets;

  BuildOp({
    this.defaultStyles,
    bool isBlockElement,
    this.onChild,
    this.onPieces,
    this.onWidgets,
    this.priority = 10,
  }) : isBlockElement = isBlockElement ?? onWidgets != null;
}

class BuiltPiece {
  final TextBits text;
  final Iterable<WidgetPlaceholder> widgets;

  BuiltPiece.text(this.text) : widgets = null;

  BuiltPiece.widgets(Iterable<Widget> widgets)
      : text = null,
        widgets = widgets.map(_placeholder);

  bool get hasWidgets => widgets != null;

  static WidgetPlaceholder _placeholder(Widget widget) =>
      widget is WidgetPlaceholder
          ? widget
          : WidgetPlaceholder<Widget>(child: widget, generator: widget);
}

class CssBorderSide {
  Color color;
  TextDecorationStyle style;
  CssLength width;
}

class CssBorders {
  CssBorderSide bottom;
  CssBorderSide left;
  CssBorderSide right;
  CssBorderSide top;
}

class CssLength {
  final double number;
  final CssLengthUnit unit;

  CssLength(
    this.number, [
    this.unit = CssLengthUnit.px,
  ])  : assert(!number.isNegative),
        assert(unit != null);

  bool get isNotEmpty => number > 0;

  double getValue(
    TextStyleHtml tsh, {
    double baseValue,
    double scaleFactor,
  }) {
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

class CssLengthBox {
  final CssLength bottom;
  final CssLength inlineEnd;
  final CssLength inlineStart;
  final CssLength _left;
  final CssLength _right;
  final CssLength top;

  const CssLengthBox({
    this.bottom,
    this.inlineEnd,
    this.inlineStart,
    CssLength left,
    CssLength right,
    this.top,
  })  : _left = left,
        _right = right;

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

  bool get hasLeftOrRight =>
      inlineEnd?.isNotEmpty == true ||
      inlineStart?.isNotEmpty == true ||
      _left?.isNotEmpty == true ||
      _right?.isNotEmpty == true;

  double getValueLeft(TextStyleHtml tsh) => (_left ??
          (tsh.textDirection == TextDirection.ltr ? inlineStart : inlineEnd))
      ?.getValue(tsh);

  double getValueRight(TextStyleHtml tsh) => (_right ??
          (tsh.textDirection == TextDirection.ltr ? inlineEnd : inlineStart))
      ?.getValue(tsh);
}

enum CssLengthUnit {
  em,
  percentage,
  pt,
  px,
}

@immutable
class HtmlWidgetDependencies {
  final Iterable<HtmlWidgetDependency> _values;

  HtmlWidgetDependencies(this._values);

  T getValue<T>() => _values.whereType<HtmlWidgetDependency<T>>().first?.value;
}

@immutable
class HtmlWidgetDependency<T> {
  final T value;

  HtmlWidgetDependency(this.value);
}

@immutable
class ImageMetadata {
  final String alt;

  final Iterable<ImageSource> sources;

  final String title;

  ImageMetadata({this.alt, this.sources, this.title});
}

@immutable
class ImageSource {
  final double height;

  final String url;

  final double width;

  ImageSource(this.url, {this.height, this.width}) : assert(url != null);
}

abstract class NodeMetadata {
  final dom.Element domElement;

  final TextStyleBuilder _tsb;

  bool isNotRenderable;

  NodeMetadata(this.domElement, this._tsb);

  Iterable<BuildOp> get buildOps;

  bool get isBlockElement;

  Iterable<BuildOp> get parentOps;

  Iterable<MapEntry<String, String>> get styles;

  set isBlockElement(bool value);

  operator []=(String key, String value);

  String operator [](String key) {
    String value;
    for (final x in styles) {
      if (x.key == key) value = x.value;
    }
    return value;
  }

  void register(BuildOp op);

  TextStyleBuilder tsb<T>([
    TextStyleHtml Function(TextStyleHtml, T) builder,
    T input,
  ]) =>
      _tsb..enqueue(builder, input);
}

@immutable
class TextStyleHtml {
  final HtmlWidgetDependencies deps;
  final double height;
  final int maxLines;
  final TextStyleHtml parent;
  final TextStyle style;
  final TextAlign textAlign;
  final TextDirection textDirection;
  final TextOverflow textOverflow;

  TextStyleHtml({
    this.deps,
    this.height,
    this.maxLines,
    this.parent,
    this.style,
    this.textAlign,
    this.textDirection,
    this.textOverflow,
  });

  TextStyle get styleWithHeight =>
      height != null && height >= 0 ? style.copyWith(height: height) : style;

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
        deps: deps,
        height: height ?? this.height,
        maxLines: maxLines ?? this.maxLines,
        parent: parent ?? this.parent,
        style: style ?? this.style,
        textAlign: textAlign ?? this.textAlign,
        textDirection: textDirection ?? this.textDirection,
        textOverflow: textOverflow ?? this.textOverflow,
      );
}

class TextStyleBuilder<T1> {
  final TextStyleBuilder parent;

  List<Function> _builders;
  List _inputs;
  TextStyleHtml _parentOutput;
  TextStyleHtml _output;

  TextStyleBuilder({this.parent});

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

  TextStyleHtml build() {
    assert(parent != null);
    final parentOutput = parent.build();
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

  TextStyleBuilder sub() => TextStyleBuilder(parent: this);
}
