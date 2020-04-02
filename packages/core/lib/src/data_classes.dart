import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:html/dom.dart' as dom;

import 'core_helpers.dart';

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

class BuilderContext {
  final BuildContext context;
  final Widget origin;

  BuilderContext(this.context, this.origin);
}

abstract class BuiltPiece {
  bool get hasWidgets;

  TextBits get text;
  Iterable<Widget> get widgets;
}

class BuiltPieceSimple extends BuiltPiece {
  final TextBits text;
  final Iterable<Widget> widgets;

  BuiltPieceSimple({
    this.text,
    this.widgets,
  }) : assert((text == null) != (widgets == null));

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
  CssLength end;
  CssLength left;
  CssLength right;
  CssLength start;
  CssLength top;

  CssMargin copyWith({
    CssLength bottom,
    CssLength end,
    CssLength left,
    CssLength right,
    CssLength start,
    CssLength top,
  }) =>
      CssMargin()
        ..bottom = bottom ?? this.bottom
        ..end = end ?? this.end
        ..left = left ?? this.left
        ..right = right ?? this.right
        ..start = start ?? this.start
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

  double getValue(BuilderContext bc, TextStyleBuilders tsb) {
    double value;

    switch (this.unit) {
      case CssLengthUnit.em:
        value = tsb.build(bc).fontSize * number / 1;
        break;
      case CssLengthUnit.px:
        value = number;
        break;
    }

    if (value != null) {
      value = value * MediaQuery.of(bc.context).textScaleFactor;
    }

    return value;
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
}

typedef NodeMetadata NodeMetadataCollector(NodeMetadata meta, dom.Element e);

@immutable
abstract class TextBit {
  final TextBits parent;

  TextBit(this.parent);

  bool get canCompile => hasWidget;
  String get data => null;
  bool get hasTrailingSpace => false;
  bool get hasWidget => false;
  bool get isEmpty => false;
  bool get isNotEmpty => !isEmpty;
  bool get isSpacing => false;
  TextStyleBuilders get tsb => null;
  IWidgetPlaceholder get widget => null;

  InlineSpan compile(TextStyle style) => throw UnimplementedError();

  bool detach() => parent?.children?.remove(this);

  bool insertAfter(TextBit another) {
    final siblings = another?.parent?.children;
    if (siblings == null) return false;

    final indexOf = siblings.indexOf(another);
    if (indexOf == -1) return false; // detached?

    siblings.insert(indexOf + 1, this);
    return true;
  }

  bool insertBefore(TextBit another) {
    final siblings = another?.parent?.children;
    if (siblings == null) return false;

    final indexOf = siblings.indexOf(another);
    if (indexOf == -1) return false; // detached?

    siblings.insert(indexOf, this);
    return true;
  }

  TextBit clone({TextBits parent});

  static TextBit nextOf(TextBit bit) {
    var x = bit;
    var p = x?.parent;

    while (p != null) {
      final i = p.children.indexOf(x);
      if (i != -1) {
        for (var j = i + 1; j < p.children.length; j++) {
          final candidate = p.children[j];
          if (candidate is TextBits) {
            final first = candidate.first;
            if (first != null) return first;
          } else {
            return candidate;
          }
        }
      }

      x = p;
      p = p.parent;
    }

    return null;
  }

  static TextBit tailOf(TextBits bits) {
    var x = bits;

    while (x != null) {
      final last = x.last;
      if (last != null) return last;
      x = x.parent;
    }

    return null;
  }
}

abstract class TextBits extends TextBit {
  TextBits(TextBits parent) : super(parent);

  Iterable<TextBit> get bits;
  List<TextBit> get children;
  TextBit get first;
  TextBit get last;

  bool addSpace([String data]);
  void addText(String data);
  TextBits sub(TextStyleBuilders tsb);

  static int trimRight(TextBits bits) {
    final children = bits.children;
    var trimmed = 0;

    while (children.isNotEmpty && bits.hasTrailingSpace) {
      final child = children.last;
      if (child is TextBits) {
        final _trimmed = trimRight(child);
        if (_trimmed > 0) {
          trimmed += _trimmed;
        } else {
          children.removeLast();
        }
      } else {
        children.removeLast();
        trimmed++;
      }
    }

    return trimmed;
  }
}

class TextStyleBuilders {
  final _builders = <Function>[];
  final _inputs = [];
  final TextStyleBuilders parent;

  GestureRecognizer recognizer;

  BuilderContext _bc;
  TextStyle _output;
  TextAlign _textAlign;

  BuilderContext get bc => _bc;

  TextAlign get textAlign => _textAlign ?? parent?.textAlign;

  set textAlign(TextAlign v) => _textAlign = v;

  TextStyleBuilders({this.parent});

  TextStyleBuilders clone({TextStyleBuilders parent}) {
    final cloned = TextStyleBuilders(parent: parent ?? this.parent);

    final l = _builders.length;
    for (var i = 0; i < l; i++) {
      cloned._builders.add(_builders[i]);
      cloned._inputs.add(_inputs[i]);
    }

    return cloned;
  }

  void enqueue<T>(TextStyleBuilder<T> builder, T input) {
    assert(_output == null, "Cannot add builder after being built");
    _builders.add(builder);
    _inputs.add(input);
  }

  TextStyle build(BuilderContext bc) {
    _resetContextIfNeeded(bc);
    if (_output != null) return _output;

    if (parent == null) {
      _output = DefaultTextStyle.of(_bc.context).style;
    } else {
      _output = parent.build(_bc);
    }

    final l = _builders.length;
    for (int i = 0; i < l; i++) {
      _output = _builders[i](this, _output, _inputs[i]);
    }

    return _output;
  }

  TextStyleBuilders sub() => TextStyleBuilders(parent: this);

  void _resetContextIfNeeded(BuilderContext bc) {
    if (bc == _bc) return;

    _bc = bc;
    _output = null;
    _textAlign = null;
  }
}

typedef TextStyle TextStyleBuilder<T>(
  TextStyleBuilders tsb,
  TextStyle textStyle,
  T input,
);
