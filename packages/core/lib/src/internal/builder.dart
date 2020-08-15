import 'package:flutter/widgets.dart';
import 'package:html/dom.dart' as dom;

import '../core_data.dart';
import '../core_helpers.dart';
import '../core_widget_factory.dart';

final _regExpSpaceLeading = RegExp(r'^[^\S\u{00A0}]+', unicode: true);
final _regExpSpaceTrailing = RegExp(r'[^\S\u{00A0}]+$', unicode: true);
final _regExpSpaces = RegExp(r'[^\S\u{00A0}]+', unicode: true);

class HtmlBuilder {
  final List<dom.Node> domNodes;
  final NodeMetadata parentMeta;
  final Iterable<BuildOp> parentOps;
  final TextBits parentText;
  final WidgetFactory wf;

  final _pieces = <BuiltPiece>[];

  BuiltPiece _textPiece;

  HtmlBuilder({
    @required this.domNodes,
    @required this.parentMeta,
    this.parentOps,
    this.parentText,
    @required this.wf,
  })  : assert(domNodes != null),
        assert(parentMeta != null),
        assert(wf != null);

  Iterable<Widget> build() {
    final list = <WidgetPlaceholder>[];

    for (final piece in process()) {
      if (piece.widgets != null) {
        for (final widget in piece.widgets) {
          if (widget != null) list.add(widget);
        }
      } else {
        final built = wf.buildText(parentMeta, piece.text);
        if (built != null) list.add(built);
      }
    }

    Iterable<WidgetPlaceholder> widgets = list;
    if (parentMeta?.buildOps != null) {
      final _makeSureWidgetIsPlaceholder = (Widget widget) =>
          widget is WidgetPlaceholder
              ? widget
              : WidgetPlaceholder<NodeMetadata>(
                  child: widget, generator: parentMeta);

      for (final op in parentMeta.buildOps) {
        widgets = op.onWidgets
                ?.call(parentMeta, widgets)
                ?.map(_makeSureWidgetIsPlaceholder)
                ?.toList(growable: false) ??
            widgets;
      }
    }

    return widgets;
  }

  NodeMetadata collectMetadata(dom.Element e) {
    final meta = NodeMetadata(parentMeta.tsb().sub(), parentOps);
    wf.parseTag(meta, e.localName, e.attributes);

    if (meta.parentOps != null) {
      for (final op in meta.parentOps) {
        op.onChild?.call(meta, e);
      }
    }

    // stylings, step 1: get default styles from tag-based build ops
    if (meta.buildOps != null) {
      for (final op in meta.buildOps) {
        final map = op.defaultStyles?.call(meta, e);
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
      meta.register(wf.styleDisplayBlock());
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
        parentOps: _prepareParentOps(parentOps, meta),
        parentText: isBlockElement ? null : _textPiece.text,
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
    if (parentMeta?.buildOps != null) {
      for (final op in parentMeta.buildOps) {
        output = op.onPieces?.call(parentMeta, output) ?? output;
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
      (_pieces.isEmpty ? parentText?.sub(parentMeta.tsb()) : null) ??
          TextBits(parentMeta.tsb()));

  void _saveTextPiece() {
    _pieces.add(_textPiece);
    _newTextPiece();
  }
}

Iterable<BuildOp> _prepareParentOps(Iterable<BuildOp> ops, NodeMetadata meta) {
  // try to reuse existing list if possible
  final withOnChild = meta?.buildOps
      ?.where((op) => op.onChild != null)
      ?.toList(growable: false);
  if (withOnChild?.isNotEmpty != true) return ops;
  return List.unmodifiable([if (ops != null) ...ops, ...withOnChild]);
}

final _spacingRegExp = RegExp(r'\s+');
Iterable<String> splitCssValues(String value) => value.split(_spacingRegExp);

final _attrStyleRegExp = RegExp(r'([a-zA-Z\-]+)\s*:\s*([^;]*)');
Iterable<MapEntry<String, String>> splitAttributeStyle(String value) =>
    _attrStyleRegExp
        .allMatches(value)
        .map((m) => MapEntry(m[1].trim(), m[2].trim()));
