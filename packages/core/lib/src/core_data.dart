import 'package:flutter/widgets.dart';
import 'package:html/dom.dart' as dom;

import 'core_helpers.dart';
import 'core_widget_factory.dart';

part 'data/table_data.dart';
part 'data/text_bits.dart';

/// A building operation to customize how a DOM element is rendered.
@immutable
class BuildOp {
  /// Whether the element should be rendered with [CssBlock].
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
  ///   defaultStyles: (_, __) => {'color': 'red'},
  /// )
  /// ```
  ///
  /// Note: op must be registered early for this to work e.g.
  /// in [WidgetFactory.parseTag] or [onChild].
  final Map<String, String> Function(NodeMetadata meta, dom.Element element)
      defaultStyles;

  /// The callback that will be called whenver a child element is found.
  ///
  /// Please note that all children and grandchildren etc. will trigger this method,
  /// it's easy to check whether an element is direct child:
  ///
  /// ```dart
  /// BuildOp(
  ///   onChild: (childMeta, childElement) {
  ///     if (!childElement.parent != parentMeta.domElement) return;
  ///     childMeta.doSomethingHere;
  ///   },
  /// );
  ///
  /// ```
  final void Function(NodeMetadata childMeta, dom.Element childElement) onChild;

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

@immutable
class ImgMetadata {
  final String alt;
  final String title;
  final String url;

  ImgMetadata({
    this.alt,
    this.title,
    @required this.url,
  });
}

class NodeMetadata {
  List<BuildOp> _buildOps;
  dom.Element _domElement;
  final Iterable<BuildOp> _parentOps;
  final TextStyleBuilder _tsb;

  bool _isBlockElement;
  bool isNotRenderable;
  List<String> _styles;
  bool _stylesFrozen = false;

  NodeMetadata(this._tsb, [this._parentOps]);

  dom.Element get domElement => _domElement;

  bool get hasOps => _buildOps != null;

  bool get hasParents => _parentOps != null;

  bool get isBlockElement {
    if (_isBlockElement == true) return true;
    return _buildOps?.where((o) => o.isBlockElement)?.length?.compareTo(0) == 1;
  }

  Iterable<BuildOp> get ops => _buildOps;

  Iterable<BuildOp> get parents => _parentOps;

  Iterable<MapEntry<String, String>> get styleEntries sync* {
    _stylesFrozen = true;
    if (_styles == null) return;

    final iterator = _styles.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current;
      if (!iterator.moveNext()) return;
      yield MapEntry(key, iterator.current);
    }
  }

  set domElement(dom.Element e) {
    assert(_domElement == null);
    _domElement = e;

    if (_buildOps != null) {
      _buildOps.sort((a, b) => a.priority.compareTo(b.priority));
      _buildOps = List.unmodifiable(_buildOps);
    }
  }

  set isBlockElement(bool v) => _isBlockElement = v;

  set op(BuildOp op) {
    if (op == null) return;
    _buildOps ??= [];
    if (!_buildOps.contains(op)) _buildOps.add(op);
  }

  void addStyle(String key, String value) {
    assert(!_stylesFrozen);
    _styles ??= [];
    _styles..add(key)..add(value);
  }

  void insertStyle(String key, String value) {
    assert(!_stylesFrozen);
    _styles ??= [];
    _styles..insertAll(0, [key, value]);
  }

  String style(String key) {
    String value;
    for (final x in styleEntries) {
      if (x.key == key) value = x.value;
    }
    return value;
  }

  TextStyleBuilder tsb<T>([
    TextStyleHtml Function(TextStyleHtml, T) builder,
    T input,
  ]) =>
      _tsb..enqueue(builder, input);
}

@immutable
class TextStyleHtml {
  final Iterable<HtmlWidgetDependency> _deps;
  final double height;
  final int maxLines;
  final TextStyleHtml parent;
  final TextStyle style;
  final TextAlign textAlign;
  final TextDirection textDirection;
  final TextOverflow textOverflow;

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

  TextStyleHtml get root => parent?.root ?? this;

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
        deps: _deps,
        height: height ?? this.height,
        maxLines: maxLines ?? this.maxLines,
        parent: parent ?? this.parent,
        style: style ?? this.style,
        textAlign: textAlign ?? this.textAlign,
        textDirection: textDirection ?? this.textDirection,
        textOverflow: textOverflow ?? this.textOverflow,
      );

  T getDependency<T>() => _getDependency<T>(_deps);

  static T _getDependency<T>(Iterable<HtmlWidgetDependency> deps) {
    for (final found in deps.whereType<HtmlWidgetDependency<T>>()) {
      return found.value;
    }

    return null;
  }
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
