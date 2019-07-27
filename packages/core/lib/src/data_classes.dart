import 'package:flutter/widgets.dart';
import 'package:html/dom.dart' as dom;

NodeMetadata lazySet(
  NodeMetadata meta, {
  BuildOp buildOp,
  Color color,
  bool decoOver,
  bool decoStrike,
  bool decoUnder,
  TextDecorationStyle decorationStyle,
  CssBorderStyle decorationStyleFromCssBorderStyle,
  String fontFamily,
  String fontSize,
  bool fontStyleItalic,
  FontWeight fontWeight,
  bool isBlockElement,
  bool isNotRenderable,
  Iterable<BuildOp> parentOps,
  Iterable<String> styles,
  Iterable<String> stylesPrepend,
}) {
  meta ??= NodeMetadata();

  if (buildOp != null) {
    meta._buildOps ??= [];
    final ops = meta._buildOps as List<BuildOp>;
    if (ops.indexOf(buildOp) == -1) {
      ops.add(buildOp);
    }
  }

  if (color != null) meta.color = color;

  if (decoStrike != null) meta.decoStrike = decoStrike;
  if (decoOver != null) meta.decoOver = decoOver;
  if (decoUnder != null) meta.decoUnder = decoUnder;

  if (decorationStyle != null) meta.decorationStyle = decorationStyle;
  if (decorationStyleFromCssBorderStyle != null) {
    switch (decorationStyleFromCssBorderStyle) {
      case CssBorderStyle.dashed:
        meta.decorationStyle = TextDecorationStyle.dashed;
        break;
      case CssBorderStyle.dotted:
        meta.decorationStyle = TextDecorationStyle.dotted;
        break;
      case CssBorderStyle.double:
        meta.decorationStyle = TextDecorationStyle.double;
        break;
      case CssBorderStyle.solid:
        meta.decorationStyle = TextDecorationStyle.solid;
        break;
    }
  }

  if (fontFamily != null) meta.fontFamily = fontFamily;
  if (fontSize != null) meta.fontSize = fontSize;
  if (fontStyleItalic != null) meta.fontStyleItalic = fontStyleItalic;
  if (fontWeight != null) meta.fontWeight = fontWeight;

  if (isBlockElement != null) meta._isBlockElement = isBlockElement;
  if (isNotRenderable != null) meta.isNotRenderable = isNotRenderable;

  if (parentOps != null) {
    assert(meta._parentOps == null);
    meta._parentOps = parentOps;
  }

  if (stylesPrepend != null) {
    styles = stylesPrepend;
  }
  if (styles != null) {
    assert(styles.length % 2 == 0);
    assert(!meta._stylesFrozen);
    meta._styles ??= [];
    if (styles == stylesPrepend) {
      meta._styles.insertAll(0, styles);
    } else {
      meta._styles.addAll(styles);
    }
  }

  return meta;
}

class BuildOp {
  final bool isBlockElement;

  // op with lower priority will run first
  final int priority;

  final BuildOpDefaultStyles _defaultStyles;
  final BuildOpOnChild _onChild;
  final BuildOpOnPieces _onPieces;
  final BuildOpOnWidgets _onWidgets;

  BuildOp({
    BuildOpDefaultStyles defaultStyles,
    bool isBlockElement,
    BuildOpOnChild onChild,
    BuildOpOnPieces onPieces,
    BuildOpOnWidgets onWidgets,
    this.priority = 10,
  })  : _defaultStyles = defaultStyles,
        this.isBlockElement = isBlockElement ?? onWidgets != null,
        _onChild = onChild,
        _onPieces = onPieces,
        _onWidgets = onWidgets;

  bool get hasOnChild => _onChild != null;

  List<String> defaultStyles(NodeMetadata meta, dom.Element e) =>
      _defaultStyles != null ? _defaultStyles(meta, e) : null;

  NodeMetadata onChild(NodeMetadata meta, dom.Element e) =>
      _onChild != null ? _onChild(meta, e) : meta;

  Iterable<BuiltPiece> onPieces(
    NodeMetadata meta,
    Iterable<BuiltPiece> pieces,
  ) =>
      _onPieces != null ? _onPieces(meta, pieces) : pieces;

  Iterable<Widget> onWidgets(NodeMetadata meta, Iterable<Widget> widgets) =>
      (_onWidgets != null ? _onWidgets(meta, widgets) : null) ?? widgets;
}

typedef Iterable<String> BuildOpDefaultStyles(
  NodeMetadata meta,
  dom.Element e,
);
typedef NodeMetadata BuildOpOnChild(NodeMetadata meta, dom.Element e);
typedef Iterable<BuiltPiece> BuildOpOnPieces(
  NodeMetadata meta,
  Iterable<BuiltPiece> pieces,
);
typedef Iterable<Widget> BuildOpOnWidgets(
    NodeMetadata meta, Iterable<Widget> widgets);

abstract class BuiltPiece {
  bool get hasWidgets;

  TextBlock get block;
  Iterable<Widget> get widgets;
}

class BuiltPieceSimple extends BuiltPiece {
  final TextBlock block;
  final Iterable<Widget> widgets;

  BuiltPieceSimple({
    this.block,
    this.widgets,
  }) : assert((block == null) != (widgets == null));

  bool get hasWidgets => widgets != null;
}

class CssBorderSide {
  Color color;
  CssBorderStyle style;
  CssLength width;
}

enum CssBorderStyle { dashed, dotted, double, solid }

class CssBorders {
  CssBorderSide bottom;
  CssBorderSide left;
  CssBorderSide right;
  CssBorderSide top;
}

class CssMargin {
  CssLength bottom;
  CssLength left;
  CssLength right;
  CssLength top;

  bool get isNotEmpty =>
      bottom?.isNotEmpty == true ||
      left?.isNotEmpty == true ||
      right?.isNotEmpty == true ||
      top?.isNotEmpty == true;

  CssMargin copyWith({
    CssLength bottom,
    CssLength left,
    CssLength right,
    CssLength top,
  }) =>
      CssMargin()
        ..bottom = bottom ?? this.bottom
        ..left = left ?? this.left
        ..right = right ?? this.right
        ..top = top ?? this.top;
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

  double getValue(TextStyle style) {
    switch (this.unit) {
      case CssLengthUnit.em:
        return style.fontSize * number / 1;
      case CssLengthUnit.px:
        return number;
    }

    return 0;
  }
}

enum CssLengthUnit {
  em,
  px,
}

class NodeMetadata {
  Iterable<BuildOp> _buildOps;
  dom.Element _domElement;
  Iterable<BuildOp> _parentOps;
  TextStyleBuilders _tsb;

  Color color;
  bool decoOver;
  bool decoStrike;
  bool decoUnder;
  TextDecorationStyle decorationStyle;
  String fontFamily;
  String fontSize;
  bool fontStyleItalic;
  FontWeight fontWeight;
  bool _isBlockElement;
  bool isNotRenderable;
  List<String> _styles;
  bool _stylesFrozen = false;

  dom.Element get domElement => _domElement;

  bool get hasOps => _buildOps != null;

  bool get hasParents => _parentOps != null;

  Iterable<BuildOp> get ops => _buildOps;

  Iterable<BuildOp> get parents => _parentOps;

  TextStyleBuilders get tsb => _tsb;

  set domElement(dom.Element e) {
    assert(_domElement == null);
    _domElement = e;

    if (_buildOps != null) {
      final ops = _buildOps as List;
      ops.sort((a, b) => a.priority.compareTo(b.priority));
      _buildOps = List.unmodifiable(ops);
    }
  }

  set tsb(TextStyleBuilders tsb) {
    assert(_tsb == null);
    _tsb = tsb;
  }

  bool get isBlockElement {
    if (_isBlockElement == true) return true;
    return _buildOps?.where((o) => o.isBlockElement)?.length?.compareTo(0) == 1;
  }

  void styles(void f(String key, String value)) {
    _stylesFrozen = true;
    if (_styles == null) return;

    final iterator = _styles.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current;
      if (!iterator.moveNext()) return;
      f(key, iterator.current);
    }
  }

  TextStyle textStyle(BuildContext context) => tsb.build(context);
}

typedef NodeMetadata NodeMetadataCollector(NodeMetadata meta, dom.Element e);

abstract class _TextBit {
  TextBit get first;
  bool get hasTrailingSpace;
  bool get isEmpty;
  TextBit get last;

  bool get isNotEmpty => !isEmpty;
}

class TextBit extends _TextBit {
  final TextBlock block;
  final String data;
  final VoidCallback onTap;
  final TextStyleBuilders tsb;
  final WidgetSpan widgetSpan;

  TextBit.text(this.block, this.data, this.tsb, {this.onTap})
      : assert(block != null),
        assert(data != null),
        assert(tsb != null),
        widgetSpan = null;

  TextBit.space(this.block)
      : assert(block != null),
        data = null,
        onTap = null,
        tsb = null,
        widgetSpan = null;

  TextBit.widget(this.block, this.widgetSpan)
      : assert(block != null),
        assert(widgetSpan != null),
        data = null,
        onTap = null,
        tsb = null;

  @override
  TextBit get first => this;

  @override
  bool get hasTrailingSpace => isSpace;

  @override
  bool get isEmpty => false;

  @override
  TextBit get last => this;

  bool get isSpace => data == null && widgetSpan == null;
  bool get isText => data != null;
  bool get isWidget => widgetSpan != null;

  TextBit rebuild({
    String data,
    VoidCallback onTap,
    TextStyleBuilders tsb,
    WidgetSpan widgetSpan,
  }) =>
      isText
          ? TextBit.text(
              block,
              data ?? this.data,
              tsb ?? this.tsb,
              onTap: onTap ?? this.onTap,
            )
          : isWidget
              ? TextBit.widget(block, widgetSpan ?? this.widgetSpan)
              : this;

  TextBit rebuildWidget({
    PlaceholderAlignment alignment,
    TextBaseline baseline,
    Widget child,
  }) =>
      isWidget
          ? rebuild(
              widgetSpan: WidgetSpan(
                alignment: alignment ?? this.widgetSpan.alignment,
                baseline: baseline ?? this.widgetSpan.baseline,
                child: child ?? this.widgetSpan.child,
              ),
            )
          : this;
}

class TextBlock extends _TextBit {
  final TextBlock parent;
  final TextStyleBuilders tsb;
  final List<_TextBit> _children = [];

  TextBlock(this.tsb, {this.parent}) : assert(tsb != null);

  @override
  TextBit get first => _children.first.first;

  @override
  bool get hasTrailingSpace {
    var i = _children.length;
    while (i > 0) {
      i--;
      final child = _children[i];
      if (child.isNotEmpty) return child.hasTrailingSpace;
    }

    return parent == null ? true : isEmpty ? parent.hasTrailingSpace : false;
  }

  @override
  bool get isEmpty {
    for (var i = 0; i < _children.length; i++) {
      if (_children[i].isNotEmpty) {
        return false;
      }
    }

    return true;
  }

  @override
  TextBit get last => _children.last.last;

  TextBit get next {
    if (parent == null) return null;
    final siblings = parent._children;
    final indexOf = siblings.indexOf(this);
    assert(indexOf != -1);

    for (var i = indexOf + 1; i < siblings.length; i++) {
      final next = siblings[i].first;
      if (next != null) return next;
    }

    return parent.next;
  }

  void addBit(TextBit bit, {int index}) =>
      _children.insert(index ?? _children.length, bit);

  bool addSpace() {
    if (hasTrailingSpace) return false;
    addBit(TextBit.space(this));
    return true;
  }

  void addText(String data) => addBit(TextBit.text(this, data, tsb));

  void addWidget(WidgetSpan ws) => addBit(TextBit.widget(this, ws));

  bool forEachBit(f(TextBit bit, int index), {bool reversed = false}) {
    final l = _children.length;
    final i0 = reversed ? l - 1 : 0;
    final i1 = reversed ? -1 : l;
    final ii = reversed ? -1 : 1;

    for (var i = i0; i != i1; i += ii) {
      final child = _children[i];
      final shouldContinue = child is TextBit
          ? f(child, i)
          : child is TextBlock ? child.forEachBit(f, reversed: reversed) : null;
      if (shouldContinue == false) return false;
    }

    return true;
  }

  void rebuildBits(TextBit f(TextBit bit)) {
    var i = 0;
    var l = _children.length;
    while (i < l) {
      final child = _children[i];
      if (child is TextBit) {
        _children[i] = f(child);
      } else if (child is TextBlock) {
        child.rebuildBits(f);
      }
      i++;
    }
  }

  TextBlock sub(TextStyleBuilders tsb) {
    final sub = TextBlock(tsb ?? this.tsb, parent: this);
    _children.add(sub);
    return sub;
  }

  void trimRight() {
    while (isNotEmpty && hasTrailingSpace) {
      final lastChild = _children.last;
      if (lastChild is TextBit) {
        assert(lastChild.isSpace);
        _children.removeLast();
      } else if (lastChild is TextBlock) {
        lastChild.trimRight();
        if (lastChild.isEmpty) {
          _children.removeLast();
        }
      }
    }
  }
}

class TextStyleBuilders {
  final _builders = <Function>[];
  final _inputs = [];
  final TextStyleBuilders parent;

  BuildContext builtContext;
  TextStyle output;

  TextStyleBuilders({this.parent});

  void enqueue<T>(TextStyleBuilder<T> builder, T input) {
    assert(output == null, "Cannot add builder after being built");
    _builders.add(builder);
    _inputs.add(input);
  }

  TextStyle build(BuildContext context) {
    if (context != builtContext) output = null;
    if (output != null) return output;

    builtContext = context;
    if (parent == null) {
      output = DefaultTextStyle.of(context).style;
    } else {
      output = parent.build(context);
    }

    final l = _builders.length;
    for (int i = 0; i < l; i++) {
      output = _builders[i](context, output, _inputs[i]);
    }

    return output;
  }

  TextStyleBuilders sub() => TextStyleBuilders(parent: this);
}

typedef TextStyle TextStyleBuilder<T>(
    BuildContext context, TextStyle textStyle, T input);
