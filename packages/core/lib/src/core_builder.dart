import 'package:flutter/widgets.dart';
import 'package:html/dom.dart' as dom;

import 'core_data.dart';
import 'core_helpers.dart';
import 'core_widget_factory.dart';

final _regExpSpaceLeading = RegExp(r'^[^\S\u{00A0}]+', unicode: true);
final _regExpSpaceTrailing = RegExp(r'[^\S\u{00A0}]+$', unicode: true);
final _regExpSpaces = RegExp(r'[^\S\u{00A0}]+', unicode: true);

class HtmlBuilder {
  final List<dom.Node> domNodes;
  final NodeMetadata parentMeta;
  final Iterable<BuildOp> parentOps;
  final TextBits parentText;
  final TextStyleBuilder parentTsb;
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
    final list = <WidgetPlaceholder>[];

    for (final piece in process()) {
      if (piece.hasWidgets) {
        for (final widget in piece.widgets) {
          if (widget != null) list.add(widget);
        }
      } else {
        final built = wf.buildText(piece.text);
        if (built != null) list.add(built);
      }
    }

    Iterable<WidgetPlaceholder> widgets = list;
    if (parentMeta?.hasOps == true) {
      for (final op in parentMeta.ops) {
        widgets = op.onWidgets(parentMeta, widgets).toList(growable: false);
      }
    }

    return widgets;
  }

  NodeMetadata collectMetadata(dom.Element e) {
    final meta = NodeMetadata(parentTsb.sub(), parentOps);
    wf.parseTag(meta, e.localName, e.attributes);

    if (meta.hasParents) {
      for (final op in meta.parents) {
        op.onChild(meta, e);
      }
    }

    // stylings, step 1: get default styles from tag-based build ops
    if (meta.hasOps) {
      for (final op in meta.ops) {
        final map = op.defaultStyles(meta, e);
        if (map == null) continue;
        for (final pair in map.entries) {
          meta.insertStyle(pair.key, pair.value);
        }
      }
    }

    // integration point: apply custom builders
    wf.customStyleBuilder(meta, e);
    wf.customWidgetBuilder(meta, e);

    // stylings, step 2: get styles from `style` attribute
    if (e.attributes.containsKey('style')) {
      for (final pair in splitAttributeStyle(e.attributes['style'])) {
        meta.addStyle(pair.key, pair.value);
      }
    }

    for (final style in meta.styleEntries) {
      wf.parseStyle(meta, style.key, style.value);
    }

    if (meta.isBlockElement) {
      meta.op = wf.styleDisplayBlock();
    }

    meta.domElement = e;

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
        parentTsb: meta?.tsb() ?? parentTsb,
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

final _spacingRegExp = RegExp(r'\s+');
Iterable<String> splitCssValues(String value) => value.split(_spacingRegExp);

final _attrStyleRegExp = RegExp(r'([a-zA-Z\-]+)\s*:\s*([^;]*)');
Iterable<MapEntry<String, String>> splitAttributeStyle(String value) =>
    _attrStyleRegExp
        .allMatches(value)
        .map((m) => MapEntry(m[1].trim(), m[2].trim()));
