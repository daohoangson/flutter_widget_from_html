import 'package:flutter/widgets.dart';
import 'package:html/dom.dart' as dom;

import 'core_data.dart';
import 'core_helpers.dart';
import 'core_widget_factory.dart';

final _attrStyleRegExp = RegExp(r'([a-zA-Z\-]+)\s*:\s*([^;]*)');

// https://ecma-international.org/ecma-262/9.0/#table-32
// https://unicode.org/cldr/utility/character.jsp?a=200B
final _regExpSpaceLeading = RegExp(r'^[ \n\t\u{200B}]+', unicode: true);
final _regExpSpaceTrailing = RegExp(r'[ \n\t\u{200B}]+$', unicode: true);
final _regExpSpaces = RegExp(r'\s+');

class HtmlBuilder {
  final List<dom.Node> domNodes;
  final NodeMetadata parentMeta;
  final Iterable<BuildOp> parentOps;
  final TextBits parentText;
  final TextStyleBuilders parentTsb;
  final WidgetFactory wf;

  final _pieces = <BuiltPiece>[];

  BuiltPiece _textPiece;

  HtmlBuilder({
    @required this.domNodes,
    this.parentMeta,
    Iterable<BuildOp> parentParentOps,
    this.parentText,
    @required this.parentTsb,
    @required this.wf,
  })  : assert(domNodes != null),
        assert(parentTsb != null),
        assert(wf != null),
        parentOps = _prepareParentOps(parentParentOps, parentMeta);

  Iterable<Widget> build() {
    final list = <Widget>[];

    for (final piece in process()) {
      if (piece.hasWidgets) {
        for (final widget in piece.widgets) {
          if (widget != null) list.add(widget);
        }
      } else {
        final text = piece.text..trimRight();
        if (text.isNotEmpty) {
          list.add(WidgetPlaceholder(
            builder: wf.buildText,
            input: text,
          ));
        }
      }
    }

    Iterable<Widget> widgets = list;
    if (parentMeta?.hasOps == true) {
      for (final op in parentMeta.ops) {
        widgets = op.onWidgets(parentMeta, widgets);
      }
    }

    return widgets;
  }

  NodeMetadata collectMetadata(dom.Element e) {
    NodeMetadata meta;

    if (parentOps != null) meta = lazySet(meta, parentOps: parentOps);

    meta = wf.parseLocalName(meta, e.localName);

    if (meta?.hasParents == true) {
      for (final op in meta?.parents) {
        meta = op.onChild(meta, e);
      }
    }

    // stylings, step 1: get default styles from tag-based build ops
    if (meta?.hasOps == true) {
      for (final op in meta.ops) {
        final defaultStyles = op.defaultStyles(meta, e);
        if (defaultStyles != null) {
          assert(defaultStyles.length % 2 == 0);
          meta._styles ??= [];
          meta._styles.insertAll(0, defaultStyles);
        }
      }
    }

    // stylings, step 2: get styles from `style` attribute
    if (e.attributes.containsKey('style')) {
      for (final m in _attrStyleRegExp.allMatches(e.attributes['style'])) {
        meta = lazySet(meta, styles: [m[1].trim(), m[2].trim()]);
      }
    }

    if (meta != null) {
      for (final style in meta?.styles) {
        meta = wf.parseStyle(meta, style.key, style.value);
      }
    }

    meta = wf.parseElement(meta, e);

    if (meta != null) {
      meta.domElement = e;
      meta.tsb = parentTsb.sub()..enqueue(wf.buildTextStyle, meta);
    }

    return meta;
  }

  Iterable<BuiltPiece> process() {
    _newTextPiece();

    for (final domNode in domNodes) {
      if (domNode.nodeType == dom.Node.TEXT_NODE) {
        _addText(domNode.text);
        continue;
      }
      if (domNode.nodeType != dom.Node.ELEMENT_NODE) continue;

      final meta = collectMetadata(domNode);
      if (meta?.isNotRenderable == true) continue;

      final isBlockElement = meta?.isBlockElement == true;
      final __builder = HtmlBuilder(
        domNodes: domNode.nodes,
        parentMeta: meta,
        parentParentOps: parentOps,
        parentText: isBlockElement ? null : _textPiece.text,
        parentTsb: meta?.tsb ?? parentTsb,
        wf: wf,
      );

      if (isBlockElement) {
        _saveTextPiece();
        _pieces.add(BuiltPiece.widgets(__builder.build()));
        continue;
      }

      for (final __piece in __builder.process()) {
        if (__piece.text?.parent == _textPiece.text) {
          // same text, do nothing
          continue;
        }

        _saveTextPiece();
        _pieces.add(__piece);
      }
    }

    _saveTextPiece();

    Iterable<BuiltPiece> output = _pieces;
    if (parentMeta?.hasOps == true) {
      for (final op in parentMeta.ops) {
        output = op.onPieces(parentMeta, output);
      }
    }

    return output;
  }

  void _addText(String data) {
    final leading = _regExpSpaceLeading.firstMatch(data);
    final trailing = _regExpSpaceTrailing.firstMatch(data);
    final start = leading == null ? 0 : leading.end;
    final end = trailing == null ? data.length : trailing.start;

    final text = _textPiece.text;
    if (end <= start) {
      text.addWhitespace();
      return;
    }

    if (start > 0) text.addWhitespace();

    final substring = data.substring(start, end);
    final dedup = substring.replaceAll(_regExpSpaces, ' ');
    text.addText(dedup);

    if (end < data.length) text.addWhitespace();
  }

  void _newTextPiece() => _textPiece = BuiltPiece.text(
      (_pieces.isEmpty ? parentText?.sub(parentTsb) : null) ??
          TextBits(parentTsb));

  void _saveTextPiece() {
    _pieces.add(_textPiece);
    _newTextPiece();
  }
}

Iterable<BuildOp> _prepareParentOps(Iterable<BuildOp> ops, NodeMetadata meta) {
  // try to reuse existing list if possible
  final withOnChild =
      meta?.ops?.where((op) => op.hasOnChild)?.toList(growable: false);
  if (withOnChild?.isNotEmpty != true) return ops;

  return List.unmodifiable((ops?.toList() ?? <BuildOp>[])..addAll(withOnChild));
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

  bool get isBlockElement {
    if (_isBlockElement == true) return true;
    return _buildOps?.where((o) => o.isBlockElement)?.length?.compareTo(0) == 1;
  }

  Iterable<BuildOp> get ops => _buildOps;

  Iterable<BuildOp> get parents => _parentOps;

  Iterable<MapEntry<String, String>> get styles sync* {
    _stylesFrozen = true;
    if (_styles == null) return;

    final iterator = _styles.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current;
      if (!iterator.moveNext()) return;
      yield MapEntry(key, iterator.current);
    }
  }

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

  String style(String key) {
    for (final x in styles) {
      if (x.key == key) return x.value;
    }
    return null;
  }
}

NodeMetadata lazySet(
  NodeMetadata meta, {
  BuildOp buildOp,
  Color color,
  bool decoOver,
  bool decoStrike,
  bool decoUnder,
  TextDecorationStyle decorationStyle,
  String fontFamily,
  String fontSize,
  bool fontStyleItalic,
  FontWeight fontWeight,
  bool isBlockElement,
  bool isNotRenderable,
  Iterable<BuildOp> parentOps,
  Iterable<String> styles,
}) {
  meta ??= NodeMetadata();

  if (buildOp != null) {
    meta._buildOps ??= [];
    final ops = meta._buildOps as List<BuildOp>;
    if (!ops.contains(buildOp)) ops.add(buildOp);
  }

  if (color != null) meta.color = color;

  if (decoStrike != null) meta.decoStrike = decoStrike;
  if (decoOver != null) meta.decoOver = decoOver;
  if (decoUnder != null) meta.decoUnder = decoUnder;
  if (decorationStyle != null) meta.decorationStyle = decorationStyle;
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

  if (styles != null) {
    assert(styles.length % 2 == 0);
    assert(!meta._stylesFrozen);
    meta._styles ??= [];
    meta._styles.addAll(styles);
  }

  return meta;
}
