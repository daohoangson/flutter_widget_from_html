import 'package:flutter/widgets.dart';
import 'package:html/dom.dart' as dom;

import 'core_widget_factory.dart';
import 'data_classes.dart';

final _attrStyleRegExp = RegExp(r'([a-zA-Z\-]+)\s*:\s*([^;]*)');
final _textLeadingSpacingRegExp = RegExp(r'^\s+');
final _textTrailingSpacingRegExp = RegExp(r'\s+$');
final _whitespaceDuplicateRegExp = RegExp(r'\s+');

class Builder {
  final BuildContext context;
  final List<dom.Node> domNodes;
  final TextBlock parentBlock;
  final NodeMetadata parentMeta;
  final Iterable<BuildOp> parentOps;
  final TextStyle parentTextStyle;
  final WidgetFactory wf;

  final _pieces = <BuiltPiece>[];

  _Piece _textPiece;

  Builder({
    @required this.context,
    @required this.domNodes,
    this.parentBlock,
    this.parentMeta,
    Iterable<BuildOp> parentParentOps,
    @required this.parentTextStyle,
    @required this.wf,
  })  : assert(context != null),
        assert(domNodes != null),
        assert(parentTextStyle != null),
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
        final text = wf.buildText(piece.block);
        if (text != null) list.add(text);
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

    meta?.context = context;
    meta?.domElement = e;
    meta?.textStyle = wf.buildTextStyle(meta, parentTextStyle);

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
        context: context,
        domNodes: domNode.nodes,
        parentBlock: isBlockElement ? null : _textPiece.block,
        parentMeta: meta,
        parentParentOps: parentOps,
        parentTextStyle: meta?.textStyle ?? parentTextStyle,
        wf: wf,
      );

      if (isBlockElement) {
        _saveTextPiece();
        _pieces.add(_Piece(this, widgets: __builder.build()));
        continue;
      }

      for (final __piece in __builder.process()) {
        if (__piece.block?.parent == _textPiece.block) {
          // same text block, do nothing
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
        block: (_pieces.isEmpty ? parentBlock?.sub(parentTextStyle) : null) ??
            TextBlock(parentTextStyle),
      );

  void _saveTextPiece() {
    _pieces.add(_textPiece);
    _newTextPiece();
  }
}

class _Piece extends BuiltPiece {
  final Builder b;
  final TextBlock block;
  final Iterable<Widget> widgets;

  _Piece(
    this.b, {
    this.block,
    this.widgets,
  }) : assert((block == null) != (widgets == null));

  @override
  bool get hasWidgets => widgets != null;

  bool _write(String text) {
    final leading = _textLeadingSpacingRegExp.firstMatch(text);
    final trailing = _textTrailingSpacingRegExp.firstMatch(text);
    final start = leading == null ? 0 : leading.end;
    final end = trailing == null ? text.length : trailing.start;

    if (end <= start) return block.addSpace();

    if (start > 0) block.addSpace();

    final substring = text.substring(start, end);
    final dedup = substring.replaceAll(_whitespaceDuplicateRegExp, ' ');
    block.addText(dedup);

    if (end < text.length) block.addSpace();

    return true;
  }
}

Iterable<BuildOp> _prepareParentOps(
  Iterable<BuildOp> parentParentOps,
  NodeMetadata parentMeta,
) {
  // try to reuse existing list if possible
  final withOnChild = parentMeta?.ops?.where((op) => op.hasOnChild)?.toList();
  if (withOnChild?.isNotEmpty != true) return parentParentOps;

  return List.unmodifiable(
    (parentParentOps?.toList() ?? <BuildOp>[])..addAll(withOnChild),
  );
}
