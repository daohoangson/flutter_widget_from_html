import 'package:flutter/widgets.dart';
import 'package:html/dom.dart' as dom;

NodeMetadata lazySet(
  NodeMetadata meta, {
  BuildOp buildOp,
  Color color,
  bool decorationLineThrough,
  bool decorationOverline,
  TextDecorationStyle decorationStyle,
  CssBorderStyle decorationStyleFromCssBorderStyle,
  bool decorationUnderline,
  String fontFamily,
  String fontSize,
  bool fontStyleItalic,
  FontWeight fontWeight,
  Iterable<String> inlineStyles,
  bool inlineStylesPrepend = false,
  bool isBlockElement,
  bool isNotRenderable,
  Key key,
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

  if (decorationLineThrough != null)
    meta.decorationLineThrough = decorationLineThrough;

  if (decorationOverline != null) meta.decorationOverline = decorationOverline;
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

  if (decorationUnderline != null)
    meta.decorationUnderline = decorationUnderline;

  if (fontFamily != null) meta.fontFamily = fontFamily;
  if (fontSize != null) meta.fontSize = fontSize;
  if (fontStyleItalic != null) meta.fontStyleItalic = fontStyleItalic;
  if (fontWeight != null) meta.fontWeight = fontWeight;

  if (inlineStyles != null) {
    if (inlineStyles.length % 2 != 0) {
      throw new ArgumentError('inlineStyles must have an even number of items');
    }
    if (meta._inlineStylesFrozen) {
      throw new StateError('inlineStyles has already been frozen');
    }
    meta._inlineStyles ??= [];
    if (inlineStylesPrepend) {
      meta._inlineStyles.insertAll(0, inlineStyles);
    } else {
      meta._inlineStyles.addAll(inlineStyles);
    }
  }

  if (isBlockElement != null) meta._isBlockElement = isBlockElement;
  if (isNotRenderable != null) meta.isNotRenderable = isNotRenderable;

  if (key != null) {
    meta._keys ??= [];
    meta._keys.add(key);
  }

  return meta;
}

class BuildOp {
  // op with lower priority will run first
  final int priority;

  final BuildOpCollectMetadata _collectMetadata;
  final BuildOpGetInlineStyles _getInlineStyles;
  final BuildOpOnPieces _onPieces;
  final BuildOpOnWidgets _onWidgets;

  BuildOp({
    BuildOpCollectMetadata collectMetadata,
    BuildOpGetInlineStyles getInlineStyles,
    BuildOpOnPieces onPieces,
    BuildOpOnWidgets onWidgets,
    this.priority = 10,
  })  : _collectMetadata = collectMetadata,
        _getInlineStyles = getInlineStyles,
        _onPieces = onPieces,
        _onWidgets = onWidgets;

  bool get isBlockElement => _onWidgets != null;

  void collectMetadata(NodeMetadata meta) =>
      _collectMetadata != null ? _collectMetadata(meta) : null;

  List<String> getInlineStyles(NodeMetadata meta, dom.Element e) =>
      _getInlineStyles != null ? _getInlineStyles(meta, e) : null;

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

typedef void BuildOpCollectMetadata(NodeMetadata meta);
typedef List<String> BuildOpGetInlineStyles(NodeMetadata meta, dom.Element e);
typedef Iterable<BuiltPiece> BuildOpOnPieces(
  NodeMetadata meta,
  Iterable<BuiltPiece> pieces,
);
typedef Widget BuildOpOnWidgets(NodeMetadata meta, Iterable<Widget> widgets);

abstract class BuiltPiece {
  bool get hasWidgets;

  TextBlock get block;
  TextStyle get style;
  Iterable<Widget> get widgets;
}

class BuiltPieceSimple extends BuiltPiece {
  final TextBlock block;
  final TextStyle style;
  final Iterable<Widget> widgets;

  BuiltPieceSimple({
    this.block,
    this.style,
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
  dom.Element _buildOpElement;
  TextStyle _buildOpTextStyle;
  Iterable<BuildOp> _buildOps;
  List<Key> _keys;
  Color color;
  bool decorationLineThrough;
  bool decorationOverline;
  TextDecorationStyle decorationStyle;
  bool decorationUnderline;
  String fontFamily;
  String fontSize;
  bool fontStyleItalic;
  FontWeight fontWeight;
  List<String> _inlineStyles;
  bool _inlineStylesFrozen = false;
  bool _isBlockElement;
  bool isNotRenderable;

  dom.Element get buildOpElement => _buildOpElement;

  TextStyle get buildOpTextStyle => _buildOpTextStyle;

  bool get hasStyling =>
      color != null ||
      fontFamily != null ||
      fontSize != null ||
      fontWeight != null ||
      hasDecoration ||
      hasFontStyle;

  bool get hasDecoration =>
      decorationLineThrough != null ||
      decorationOverline != null ||
      decorationUnderline != null;

  bool get hasFontStyle => fontStyleItalic != null;

  bool get isBlockElement {
    if (_isBlockElement == true) return true;
    return _buildOps?.where((o) => o.isBlockElement)?.length?.compareTo(0) == 1;
  }

  Iterable<BuildOp> freezeOps(dom.Element e) {
    if (_buildOps == null) return null;

    _buildOpElement = e;

    final ops = _buildOps as List;
    ops.sort((a, b) => a.priority.compareTo(b.priority));
    _buildOps = List.unmodifiable(ops);

    return _buildOps;
  }

  freezeTextStyle(TextStyle textStyle) {
    if (_buildOpTextStyle != null) {
      throw new StateError('TextStyle has already been set');
    }

    _buildOpTextStyle = textStyle;
  }

  void keys(void f(Key key)) => _keys?.forEach(f);

  void ops(void f(BuildOp element)) => _buildOps?.forEach(f);

  void styles(void f(String key, String value)) {
    _inlineStylesFrozen = true;
    if (_inlineStyles == null) return;

    final iterator = _inlineStyles.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current;
      if (!iterator.moveNext()) return;
      f(key, iterator.current);
    }
  }
}

class TextBit {
  final String data;
  final VoidCallback onTap;
  final TextStyle style;

  bool get isSpace => data == null;
  String get text => isSpace ? ' ' : data;

  const TextBit({this.data, this.onTap, this.style});

  TextBit rebuild({
    String data,
    VoidCallback onTap,
    TextStyle style,
  }) =>
      TextBit(
        data: data ?? this.data,
        onTap: onTap ?? this.onTap,
        style: style ?? this.style,
      );

  static TextBit space({TextStyle style}) =>
      style == null ? const TextBit() : TextBit(style: style);
}

class TextBlock {
  final List<TextBit> _bits;
  final TextBlock _parent;

  bool _hasStyle = false;
  bool _hasTrailingSpace = true;
  int _indexEnd;
  int _indexStart;

  TextBlock({List<TextBit> bits, TextBlock parent})
      : assert((bits == null) == (parent == null)),
        _bits = bits ?? [],
        _parent = parent {
    _indexStart = _bits.length;
    _indexEnd = _indexStart;
  }

  bool get hasStyle => _parent?.hasStyle ?? _hasStyle;
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

    if (bit.style != null) _hasStyle = true;

    _bits.add(bit);
    _indexEnd++;

    return true;
  }

  void addBits(Iterable<TextBit> bits) => bits.forEach((b) => addBit(b));

  bool addText(String text, [TextStyle style]) =>
      addBit(TextBit(data: text, style: style));

  bool isSubOf(TextBlock other) => _parent == other;

  void rebuildBits(TextBit f(TextBit bit), {int start, int end}) {
    start ??= _indexStart;
    end ??= _indexEnd;
    if (_parent != null) {
      return _parent.rebuildBits(f, start: start, end: end);
    }

    for (var i = start; i < end; i++) {
      final bit = _bits[i];

      final rebuilt = f(bit);
      if (rebuilt.style != null) _hasStyle = true;

      _bits[i] = f(bit);
    }
  }

  TextBlock sub() => TextBlock(bits: this._bits, parent: this);
}
