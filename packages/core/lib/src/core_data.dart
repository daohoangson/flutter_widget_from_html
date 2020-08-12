import 'package:flutter/widgets.dart';
import 'package:html/dom.dart' as dom;

import 'core_helpers.dart';
import 'core_widget_factory.dart';

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

  Map<String, String> defaultStyles(NodeMetadata meta, dom.Element e) =>
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
          ? _onWidgets(meta, widgets)?.map(_placeholder)
          : null) ??
      widgets;

  WidgetPlaceholder _placeholder(Widget widget) => widget is WidgetPlaceholder
      ? widget
      : WidgetPlaceholder<BuildOp>(child: widget, generator: this);
}

typedef _BuildOpDefaultStyles = Map<String, String> Function(
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

  double getValue(BuildContext context, TextStyleBuilder tsb) =>
      getValueFromStyle(tsb.build(context));

  double getValueFromStyle(
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

  CssLength left(TextDirection dir) =>
      _left ?? (dir == TextDirection.ltr ? inlineStart : inlineEnd);

  CssLength right(TextDirection dir) =>
      _right ?? (dir == TextDirection.ltr ? inlineEnd : inlineStart);
}

enum CssLengthUnit {
  em,
  percentage,
  pt,
  px,
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

  NodeMetadata(this._tsb, this._parentOps);

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
    TextStyleHtml Function(BuildContext, TextStyleHtml, T) builder,
    T input,
  ]) =>
      _tsb..enqueue(builder, input);
}

@immutable
class TextStyleHtml {
  final double height;
  final TextStyleHtml parent;
  final TextStyle style;

  TextStyleHtml._({
    this.height,
    this.parent,
    this.style,
  });

  factory TextStyleHtml.style(TextStyle style) => TextStyleHtml._(style: style);

  TextStyleHtml get root => parent?.root ?? this;

  TextStyle get styleWithHeight =>
      height != null && height >= 0 ? style.copyWith(height: height) : style;

  TextStyleHtml copyWith({
    double height,
    TextStyleHtml parent,
    TextStyle style,
  }) =>
      TextStyleHtml._(
        height: height ?? this.height,
        parent: parent ?? this.parent,
        style: style ?? this.style,
      );
}

class TextStyleBuilder<T1> {
  final TextStyleBuilder parent;
  final WidgetFactory wf;

  List<Function> _builders;
  List _inputs;
  TextStyleHtml _parentOutput;
  TextStyleHtml _output;
  List _signature;

  TextStyleBuilder.root({
    TextStyle style,
    this.wf,
  }) : parent = null {
    if (style != null) enqueue(_rootBuilderStyle, style);
    enqueue(_rootBuilderTextScaleFactor);
  }

  TextStyleBuilder._(this.parent) : wf = null;

  int _maxLines;
  int get maxLines => _maxLines ?? parent?.maxLines;
  set maxLines(int v) => _maxLines = v;

  TextAlign _textAlign;
  TextAlign get textAlign => _textAlign ?? parent?.textAlign;
  set textAlign(TextAlign v) => _textAlign = v;

  TextOverflow _textOverflow;
  TextOverflow get textOverflow => _textOverflow ?? parent?.textOverflow;
  set textOverflow(TextOverflow v) => _textOverflow = v;

  void enqueue<T2>(
    TextStyleHtml Function(BuildContext, TextStyleHtml, T2) builder, [
    T2 input,
  ]) {
    if (builder == null) return;

    assert(_output == null, 'Cannot add builder after being built');
    _builders ??= [];
    _builders.add(builder);

    _inputs ??= [];
    _inputs.add(input);
  }

  TextStyleHtml build(BuildContext context) {
    if (parent == null) {
      // root tsb: verify signature and reset _output if it doesn't match
      final signature = wf?.generateTsbSignature(context) ?? [];
      if (!_checkSignaturesMatch(signature, _signature)) {
        final contextStyle = DefaultTextStyle.of(context).style;
        _parentOutput = TextStyleHtml.style(contextStyle);
        _output = null;
        _signature = signature;
      }
    } else {
      // for others, compare output from parent
      final parentOutput = parent.build(context);
      if (parentOutput != _parentOutput) {
        _parentOutput = parentOutput;
        _output = null;
      }
    }

    if (_output != null) return _output;

    if (_builders == null) {
      _output = _parentOutput;
      return _output;
    }

    _output = _parentOutput.copyWith(parent: _parentOutput);
    final l = _builders.length;
    for (var i = 0; i < l; i++) {
      final builder = _builders[i];
      _output = builder(context, _output, _inputs[i]);
      assert(_output?.parent == _parentOutput,
          '$builder must return a valid text style');
    }

    return _output;
  }

  bool hasSameStyleWith(TextStyleBuilder other) {
    var thisWithBuilder = this;
    while (thisWithBuilder._builders == null) {
      thisWithBuilder = thisWithBuilder.parent;
    }

    var otherWithBuilder = other;
    while (otherWithBuilder._builders == null) {
      otherWithBuilder = otherWithBuilder.parent;
    }

    return thisWithBuilder == otherWithBuilder;
  }

  TextStyleBuilder sub() => TextStyleBuilder._(this);

  static bool _checkSignaturesMatch(List a, List b) {
    if (a?.length != b?.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }

    return true;
  }

  static TextStyleHtml _rootBuilderStyle(
          BuildContext _, TextStyleHtml parent, TextStyle style) =>
      parent.copyWith(style: style.inherit ? parent.style.merge(style) : style);

  static TextStyleHtml _rootBuilderTextScaleFactor(
      BuildContext context, TextStyleHtml parent, _) {
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    if (textScaleFactor == 1) return parent;

    final style = parent.style;
    final scaled = style.copyWith(fontSize: style.fontSize * textScaleFactor);
    return parent.copyWith(style: scaled);
  }
}
