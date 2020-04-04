import 'package:flutter/widgets.dart';
import 'package:html/dom.dart' as dom;

import 'core_helpers.dart';
import 'core_widget_factory.dart';
import 'data_classes.dart';

final _attrStyleRegExp = RegExp(r'([a-zA-Z\-]+)\s*:\s*([^;]*)');

// https://ecma-international.org/ecma-262/9.0/#table-32
// https://unicode.org/cldr/utility/character.jsp?a=200B
final _regExpSpaceLeading = RegExp(r'^[ \n\t\u{200B}]+', unicode: true);
final _regExpSpaceTrailing = RegExp(r'[ \n\t\u{200B}]+$', unicode: true);
final _regExpSpaces = RegExp(r'\s+');

class Builder {
  final List<dom.Node> domNodes;
  final NodeMetadata parentMeta;
  final Iterable<BuildOp> parentOps;
  final TextBits parentText;
  final TextStyleBuilders parentTsb;
  final WidgetFactory wf;

  final _pieces = <BuiltPiece>[];

  _Piece _textPiece;

  Builder({
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
        lazySet(meta, stylesPrepend: op.defaultStyles(meta, e));
      }
    }

    // stylings, step 2: get styles from `style` attribute
    if (e.attributes.containsKey('style')) {
      for (final m in _attrStyleRegExp.allMatches(e.attributes['style'])) {
        meta = lazySet(meta, styles: [m[1].trim(), m[2].trim()]);
      }
    }

    meta?.styles((k, v) => meta = wf.parseStyle(meta, k, v));

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
        _textPiece._write(domNode.text);
        continue;
      }
      if (domNode.nodeType != dom.Node.ELEMENT_NODE) continue;

      final meta = collectMetadata(domNode);
      if (meta?.isNotRenderable == true) continue;

      final isBlockElement = meta?.isBlockElement == true;
      final __builder = Builder(
        domNodes: domNode.nodes,
        parentMeta: meta,
        parentParentOps: parentOps,
        parentText: isBlockElement ? null : _textPiece.text,
        parentTsb: meta?.tsb ?? parentTsb,
        wf: wf,
      );

      if (isBlockElement) {
        _saveTextPiece();
        _pieces.add(_Piece(this, widgets: __builder.build()));
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

  void _newTextPiece() => _textPiece = _Piece(
        this,
        text: (_pieces.isEmpty ? parentText?.sub(parentTsb) : null) ??
            TextBits(parentTsb),
      );

  void _saveTextPiece() {
    _pieces.add(_textPiece);
    _newTextPiece();
  }
}

class _Piece extends BuiltPiece {
  final Builder b;
  final TextBits text;
  final Iterable<Widget> widgets;

  _Piece(
    this.b, {
    this.text,
    this.widgets,
  }) : assert((text == null) != (widgets == null));

  @override
  bool get hasWidgets => widgets != null;

  TextBit _write(String data) {
    final leading = _regExpSpaceLeading.firstMatch(data);
    final trailing = _regExpSpaceTrailing.firstMatch(data);
    final start = leading == null ? 0 : leading.end;
    final end = trailing == null ? data.length : trailing.start;

    if (end <= start) return text.addSpace();

    TextBit bit;
    if (start > 0) bit = text.addSpace();

    final substring = data.substring(start, end);
    final dedup = substring.replaceAll(_regExpSpaces, ' ');
    bit = text.addText(dedup);

    if (end < data.length) bit = text.addSpace();

    return bit;
  }
}

Iterable<BuildOp> _prepareParentOps(
  Iterable<BuildOp> parentParentOps,
  NodeMetadata parentMeta,
) {
  // try to reuse existing list if possible
  final withOnChild =
      parentMeta?.ops?.where((op) => op.hasOnChild)?.toList(growable: false);
  if (withOnChild?.isNotEmpty != true) return parentParentOps;

  return List.unmodifiable(
    (parentParentOps?.toList() ?? <BuildOp>[])..addAll(withOnChild),
  );
}
