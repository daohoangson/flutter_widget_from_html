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

class CssLength {
  final double number;
  final CssLengthUnit unit;

  CssLength(this.number, {this.unit});

  double getValue(TextStyle parent) {
    if (number == 0) return 0;

    switch (this.unit) {
      case CssLengthUnit.em:
        return parent.fontSize * number / 1;
      case CssLengthUnit.px:
      default:
        return number;
    }
  }
}

enum CssLengthUnit {
  em,
  px,
}

class NodeMetadata {
  Iterable<BuildOp> _buildOps;
  BuildContext _context;
  dom.Element _domElement;
  Iterable<BuildOp> _parentOps;
  TextStyle _textStyle;

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

  BuildContext get context => _context;

  dom.Element get domElement => _domElement;

  bool get hasOps => _buildOps != null;

  bool get hasParents => _parentOps != null;

  Iterable<BuildOp> get ops => _buildOps;

  Iterable<BuildOp> get parents => _parentOps;

  TextStyle get textStyle => _textStyle;

  set domElement(dom.Element e) {
    assert(_domElement == null);
    _domElement = e;

    if (_buildOps != null) {
      final ops = _buildOps as List;
      ops.sort((a, b) => a.priority.compareTo(b.priority));
      _buildOps = List.unmodifiable(ops);
    }
  }

  set context(BuildContext context) {
    assert(_context == null);
    _context = context;
  }

  set textStyle(TextStyle textStyle) {
    assert(_textStyle == null);
    _textStyle = textStyle;
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

class TextBit {
  final TextBlock block;
  final String data;
  final VoidCallback onTap;
  final TextStyle style;

  TextBit({this.block, this.data, this.style, this.onTap});

  TextBit.text(this.block, this.data, this.style)
      : assert(block != null),
        assert(data != null),
        assert(style != null),
        onTap = null;

  TextBit.space(this.block)
      : assert(block != null),
        data = null,
        onTap = null,
        style = null;

  TextBit rebuild({
    TextBlock block,
    String data,
    VoidCallback onTap,
    TextStyle style,
  }) =>
      TextBit(
        block: block ?? this.block,
        data: data ?? this.data,
        style: style ?? this.style,
        onTap: onTap ?? this.onTap,
      );
}

class TextBlock {
  final TextBlock parent;
  final TextStyle style;
  final List<TextBit> _bits;

  bool _hasTrailingSpace = true;
  int _indexEnd;
  int _indexStart;

  TextBlock(this.style, {List<TextBit> bits, this.parent})
      : assert(style != null),
        assert((bits == null) == (parent == null)),
        _bits = bits ?? [] {
    _indexStart = _bits.length;
    _indexEnd = _indexStart;
  }

  bool get hasTrailingSpace => _indexEnd == _bits.length
      ? parent?.hasTrailingSpace ?? _hasTrailingSpace
      : false;
  int get indexEnd => _indexEnd;
  int get indexStart => _indexStart;
  bool get isEmpty => _indexEnd == _indexStart;
  bool get isNotEmpty => !isEmpty;
  Iterable<TextBit> get iterable => _bits.getRange(_indexStart, _indexEnd);
  TextBit get next => _bits.length > _indexEnd ? _bits[_indexEnd] : null;

  bool addBit(TextBit bit) {
    if (parent != null) {
      if (_indexEnd != _bits.length) {
        throw new StateError('Cannot add TextBit in the middle of a block');
      }
      final added = parent.addBit(bit);
      if (added) _indexEnd++;
      return added;
    }

    if (bit.data == null) {
      if (_bits.isEmpty || _hasTrailingSpace) return false;
      _hasTrailingSpace = true;
    } else {
      _hasTrailingSpace = false;
    }

    _bits.add(bit);
    _indexEnd++;

    return true;
  }

  bool addSpace() => addBit(TextBit.space(this));

  bool addText(String data) => addBit(TextBit.text(this, data, style));

  void rebuildBits(TextBit f(TextBit bit), {int start, int end}) {
    start ??= _indexStart;
    end ??= _indexEnd;
    if (parent != null) return parent.rebuildBits(f, start: start, end: end);

    for (var i = start; i < end; i++) {
      final bit = _bits[i];
      _bits[i] = f(bit);
    }
  }

  TextBlock sub(TextStyle style) =>
      TextBlock(style ?? this.style, bits: this._bits, parent: this);
}
