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
  Key key,
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

  if (key != null) {
    meta._keys ??= [];
    meta._keys.add(key);
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
  // op with lower priority will run first
  final int priority;

  final BuildOpDefaultStyles _defaultStyles;
  final BuildOpOnMetadata _onMetadata;
  final BuildOpOnPieces _onPieces;
  final BuildOpOnWidgets _onWidgets;

  BuildOp({
    BuildOpDefaultStyles defaultStyles,
    BuildOpOnMetadata onMetadata,
    BuildOpOnPieces onPieces,
    BuildOpOnWidgets onWidgets,
    this.priority = 10,
  })  : _defaultStyles = defaultStyles,
        _onMetadata = onMetadata,
        _onPieces = onPieces,
        _onWidgets = onWidgets;

  bool get isBlockElement => _onWidgets != null;

  List<String> defaultStyles(NodeMetadata meta, dom.Element e) =>
      _defaultStyles != null ? _defaultStyles(meta, e) : null;

  void onMetadata(NodeMetadata meta) =>
      _onMetadata != null ? _onMetadata(meta) : null;

  Iterable<BuiltPiece> onPieces(
    NodeMetadata meta,
    Iterable<BuiltPiece> pieces,
  ) =>
      _onPieces != null ? _onPieces(meta, pieces) : pieces;

  Iterable<Widget> onWidgets(NodeMetadata meta, Iterable<Widget> widgets) {
    if (_onWidgets == null) return widgets;

    final widget = _onWidgets(meta, widgets);
    if (widget == null) return widgets;

    return <Widget>[widget];
  }
}

typedef Iterable<String> BuildOpDefaultStyles(NodeMetadata meta, dom.Element e);
typedef void BuildOpOnMetadata(NodeMetadata meta);
typedef Iterable<BuiltPiece> BuildOpOnPieces(
  NodeMetadata meta,
  Iterable<BuiltPiece> pieces,
);
typedef Widget BuildOpOnWidgets(NodeMetadata meta, Iterable<Widget> widgets);

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
  List<Key> _keys;
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

  void keys(void f(Key key)) => _keys?.forEach(f);

  void ops(void f(BuildOp element)) => _buildOps?.forEach(f);

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
  final String data;
  final VoidCallback onTap;
  final TextStyle style;

  bool get isSpace => data == null;
  String get text => isSpace ? ' ' : data;

  const TextBit(this.data, this.style, {this.onTap}) : assert(style != null);

  TextBit rebuild({
    String data,
    VoidCallback onTap,
    TextStyle style,
  }) =>
      TextBit(
        data ?? this.data,
        style ?? this.style,
        onTap: onTap ?? this.onTap,
      );

  static TextBit space(TextStyle style) => TextBit(null, style);
}

class TextBlock {
  final TextStyle style;
  final List<TextBit> _bits;
  final TextBlock _parent;

  bool _hasTrailingSpace = true;
  int _indexEnd;
  int _indexStart;

  TextBlock(this.style, {List<TextBit> bits, TextBlock parent})
      : assert(style != null),
        assert((bits == null) == (parent == null)),
        _bits = bits ?? [],
        _parent = parent {
    _indexStart = _bits.length;
    _indexEnd = _indexStart;
  }

  Iterable<TextBit> get iterable => _bits.getRange(_indexStart, _indexEnd);
  bool get hasTrailingSpace => _indexEnd == _bits.length
      ? _parent?.hasTrailingSpace ?? _hasTrailingSpace
      : false;
  bool get isEmpty => _indexEnd == _indexStart;
  bool get isNotEmpty => !isEmpty;

  bool addBit(TextBit bit) {
    if (_parent != null) {
      if (_indexEnd != _bits.length) {
        throw new StateError('Cannot add TextBit in the middle of a block');
      }
      final added = _parent.addBit(bit);
      if (added) _indexEnd++;
      return added;
    }

    if (bit.isSpace) {
      if (_bits.isEmpty || _hasTrailingSpace) return false;
      _hasTrailingSpace = true;
    } else {
      _hasTrailingSpace = false;
    }

    _bits.add(bit);
    _indexEnd++;

    return true;
  }

  void addBits(Iterable<TextBit> bits) => bits.forEach((b) => addBit(b));

  bool addText(String text, [TextStyle style]) =>
      addBit(TextBit(text, style ?? this.style));

  bool isSubOf(TextBlock other) => _parent == other;

  void rebuildBits(TextBit f(TextBit bit), {int start, int end}) {
    start ??= _indexStart;
    end ??= _indexEnd;
    if (_parent != null) {
      return _parent.rebuildBits(f, start: start, end: end);
    }

    for (var i = start; i < end; i++) {
      final bit = _bits[i];
      _bits[i] = f(bit);
    }
  }

  TextBlock sub(TextStyle style) =>
      TextBlock(style ?? this.style, bits: this._bits, parent: this);
}
