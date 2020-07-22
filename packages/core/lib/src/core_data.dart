import 'package:flutter/widgets.dart';
import 'package:html/dom.dart' as dom;

import 'core_builder.dart';
import 'core_helpers.dart';

part 'data/table_data.dart';
part 'data/text_bits.dart';

class BuildOp {
  final bool isBlockElement;

  // op with lower priority will run first
  final int priority;

  final _BuildOpDefaultStyles _defaultStyles;
  final _BuildOpOnChild _onChild;
  final _BuildOpOnPieces _onPieces;
  final _BuildOpOnWidgets _onWidgets;

  BuildOp({
    _BuildOpDefaultStyles defaultStyles,
    bool isBlockElement,
    _BuildOpOnChild onChild,
    _BuildOpOnPieces onPieces,
    _BuildOpOnWidgets onWidgets,
    this.priority = 10,
  })  : _defaultStyles = defaultStyles,
        isBlockElement = isBlockElement ?? onWidgets != null,
        _onChild = onChild,
        _onPieces = onPieces,
        _onWidgets = onWidgets;

  bool get hasOnChild => _onChild != null;

  List<String> defaultStyles(NodeMetadata meta, dom.Element e) =>
      _defaultStyles != null ? _defaultStyles(meta, e) : null;

  void onChild(NodeMetadata meta, dom.Element e) =>
      _onChild != null ? _onChild(meta, e) : meta;

  Iterable<BuiltPiece> onPieces(
    NodeMetadata meta,
    Iterable<BuiltPiece> pieces,
  ) =>
      _onPieces != null ? _onPieces(meta, pieces) : pieces;

  Iterable<WidgetPlaceholder> onWidgets(
          NodeMetadata meta, Iterable<WidgetPlaceholder> widgets) =>
      (_onWidgets != null
          ? _onWidgets(meta, widgets)?.map(_widgetToPlaceholder)
          : null) ??
      widgets;
}

typedef _BuildOpDefaultStyles = Iterable<String> Function(
    NodeMetadata meta, dom.Element e);
typedef _BuildOpOnChild = void Function(NodeMetadata meta, dom.Element e);
typedef _BuildOpOnPieces = Iterable<BuiltPiece> Function(
    NodeMetadata meta, Iterable<BuiltPiece> pieces);
typedef _BuildOpOnWidgets = Iterable<Widget> Function(
    NodeMetadata meta, Iterable<WidgetPlaceholder> widgets);

class BuiltPiece {
  final TextBits text;
  final Iterable<WidgetPlaceholder> widgets;

  BuiltPiece.text(this.text) : widgets = null;

  BuiltPiece.placeholders(this.widgets) : text = null;

  BuiltPiece.widgets(Iterable<Widget> widgets)
      : text = null,
        widgets = widgets.map(_widgetToPlaceholder);

  bool get hasWidgets => widgets != null;
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
    this.number, {
    this.unit = CssLengthUnit.px,
  })  : assert(!number.isNegative),
        assert(unit != null);

  bool get isNotEmpty => number > 0;

  double getValue(BuildContext context, TextStyleBuilders tsb) =>
      getValueFromStyle(context, tsb.build(context).style);

  double getValueFromStyle(BuildContext context, TextStyle style) {
    double value;

    switch (unit) {
      case CssLengthUnit.em:
        value = style.fontSize * number;
        break;
      case CssLengthUnit.percentage:
        return null;
      case CssLengthUnit.px:
        value = number;
        break;
    }

    if (value != null) {
      value = value * MediaQuery.of(context).textScaleFactor;
    }

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

  CssLength left(TextDirection dir) =>
      _left ?? (dir == TextDirection.ltr ? inlineStart : inlineEnd);

  CssLength right(TextDirection dir) =>
      _right ?? (dir == TextDirection.ltr ? inlineEnd : inlineStart);
}

enum CssLengthUnit {
  em,
  percentage,
  px,
}

@immutable
class ImgMetadata {
  final String alt;
  final double height;
  final String title;
  final String url;
  final double width;

  ImgMetadata({
    this.alt,
    this.height,
    this.title,
    @required this.url,
    this.width,
  });
}

@immutable
class TextStyleHtml {
  final TextAlign align;
  final double height;
  final int maxLines;
  final TextStyle style;
  final TextOverflow textOverflow;

  TextStyleHtml._({
    this.align,
    this.height,
    this.maxLines,
    this.style,
    this.textOverflow,
  });

  TextStyleHtml.style(this.style)
      : align = null,
        height = null,
        maxLines = null,
        textOverflow = null;

  TextStyleHtml copyWith({
    TextAlign align,
    double height,
    int maxLines,
    TextStyle style,
    TextOverflow textOverflow,
  }) =>
      TextStyleHtml._(
        align: align ?? this.align,
        height: height ?? this.height,
        maxLines: maxLines ?? this.maxLines,
        style: style ?? this.style,
        textOverflow: textOverflow ?? this.textOverflow,
      );

  TextStyle build(BuildContext context) {
    var built = style;

    if (height != null && height >= 0) {
      built = built.copyWith(height: height);
    }

    return built;
  }
}

class TextStyleBuilders {
  final _builders = <Function>[];
  final _inputs = [];
  final TextStyleBuilders parent;

  BuildContext _context;
  TextStyleHtml _default;
  TextStyleHtml _output;

  TextStyleBuilders({this.parent});

  BuildContext get context => _context;

  void enqueue<T>(
    TextStyleHtml Function(BuildContext, TextStyleHtml, T) builder, [
    T input,
  ]) {
    assert(_output == null, 'Cannot add builder after being built');
    _builders.add(builder);
    _inputs.add(input);
  }

  TextStyleHtml build(BuildContext context) {
    _resetContextIfNeeded(context);
    if (_output != null) return _output;

    if (parent == null) {
      _output = _default;
    } else {
      _output = parent.build(_context);
    }

    final l = _builders.length;
    for (var i = 0; i < l; i++) {
      _output = _builders[i](context, _output, _inputs[i]);
    }

    return _output;
  }

  TextStyle style(BuildContext context) => build(context).build(context);

  TextStyleBuilders sub() => TextStyleBuilders(parent: this);

  void _resetContextIfNeeded(BuildContext context) {
    final contextStyle = DefaultTextStyle.of(context).style;
    if (context == _context && contextStyle == _default.style) return;

    _context = context;
    _default = TextStyleHtml.style(contextStyle);
    _output = null;
  }
}

WidgetPlaceholder _widgetToPlaceholder(Widget widget) {
  if (widget is WidgetPlaceholder) return widget;
  return WidgetPlaceholder<Widget>(builder: _widgetBuilder, input: widget);
}

Iterable<Widget> _widgetBuilder(
        BuildContext _, Iterable<Widget> __, Widget widget) =>
    [widget];
