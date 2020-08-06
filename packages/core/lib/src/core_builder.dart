import 'package:flutter/widgets.dart';
import 'package:html/dom.dart' as dom;

import 'core_data.dart';
import 'core_helpers.dart';
import 'core_widget_factory.dart';

final _attrStyleRegExp = RegExp(r'([a-zA-Z\-]+)\s*:\s*([^;]*)');
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
    final meta = NodeMetadata._(parentTsb.sub(), parentOps);

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

        final list = List<String>(map.length * 2);
        var i = 0;
        for (final pair in map.entries) {
          list[i++] = pair.key;
          list[i++] = pair.value;
        }

        meta._styles ??= [];
        meta._styles.insertAll(0, list);
      }
    }

    // integration point: apply custom builders
    wf.customStyleBuilder(meta, e);
    wf.customWidgetBuilder(meta, e);

    // stylings, step 2: get styles from `style` attribute
    if (e.attributes.containsKey('style')) {
      for (final m in _attrStyleRegExp.allMatches(e.attributes['style'])) {
        meta.styles = [m[1].trim(), m[2].trim()];
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
        parentTsb: meta?._tsb ?? parentTsb,
        parentMeta: meta,
        parentParentOps: parentOps,
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
  List<BuildOp> _buildOps;
  dom.Element _domElement;
  final Iterable<BuildOp> _parentOps;
  final TextStyleBuilder _tsb;

  bool _isBlockElement;
  bool isNotRenderable;
  List<String> _styles;
  bool _stylesFrozen = false;

  NodeMetadata._(this._tsb, this._parentOps);

  dom.Element get domElement => _domElement;

  bool get hasOps => _buildOps != null;

  bool get hasParents => _parentOps != null;

  bool get isBlockElement {
    if (_isBlockElement == true) return true;
    return _buildOps?.where((o) => o.isBlockElement)?.length?.compareTo(0) == 1;
  }

  Iterable<BuildOp> get ops => _buildOps;

  Iterable<BuildOp> get parents => _parentOps;

  Iterable<MapEntry<String, String>> get styleEntries sync* {
    _stylesFrozen = true;
    if (_styles == null) return;

    final iterator = _styles.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current;
      if (!iterator.moveNext()) return;
      yield MapEntry(key, iterator.current);
    }
  }

  set domElement(dom.Element e) {
    assert(_domElement == null);
    _domElement = e;

    if (_buildOps != null) {
      _buildOps.sort((a, b) => a.priority.compareTo(b.priority));
      _buildOps = List.unmodifiable(_buildOps);
    }
  }

  set isBlockElement(bool v) => _isBlockElement = v;

  set op(BuildOp op) {
    if (op == null) return;
    _buildOps ??= [];
    if (!_buildOps.contains(op)) _buildOps.add(op);
  }

  set styles(Iterable<String> styles) {
    if (styles == null) return;
    assert(styles.length % 2 == 0);
    assert(!_stylesFrozen);
    _styles ??= [];
    _styles.addAll(styles);
  }

  TextStyleBuilder tsb<T>([
    TextStyleHtml Function(BuildContext, TextStyleHtml, T) builder,
    T input,
  ]) =>
      _tsb..enqueue(builder, input);

  String style(String key) {
    String value;
    for (final x in styleEntries) {
      if (x.key == key) value = x.value;
    }
    return value;
  }
}
