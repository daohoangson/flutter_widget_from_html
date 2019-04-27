import 'package:flutter/widgets.dart';
import 'package:html/dom.dart' as dom;

import 'core_wf.dart';
import 'data_classes.dart';

final _attrStyleRegExp = RegExp(r'([a-zA-Z\-]+)\s*:\s*([^;]*)');
final _textLeadingSpacingRegExp = RegExp(r'^\s+');
final _textTrailingSpacingRegExp = RegExp(r'\s+$');
final _whitespaceDuplicateRegExp = RegExp(r'\s+');

class Builder {
  final List<dom.Node> domNodes;
  final TextBlock parentBlock;
  final NodeMetadata parentMeta;
  final WidgetFactory wf;

  final _ParentStyle _parentStyle;
  final _pieces = <BuiltPiece>[];

  _Piece _textPiece;

  Builder(
    this.domNodes,
    this.wf, {
    this.parentBlock,
    this.parentMeta,
    _ParentStyle parentStyle,
  }) : _parentStyle = parentStyle ?? _ParentStyle(wf: wf) {
    parentMeta?.freezeTextStyle(_parentStyle.textStyle);
  }

  List<Widget> build() {
    var widgets = <Widget>[];

    final addWidget = (Widget w) => w != null ? widgets.add(w) : null;
    process().forEach((p) => p.hasWidgets
        ? p.widgets.forEach(addWidget)
        : addWidget(wf.buildText(block: p.block)));

    parentMeta?.ops((o) => widgets = o.onWidgets(parentMeta, widgets));

    return widgets;
  }

  NodeMetadata collectMetadata(dom.Element e) {
    NodeMetadata meta;

    parentMeta?.keys((k) => meta = lazySet(meta, key: k));

    meta = wf.parseElement(meta, e);

    meta?.ops((o) => lazySet(
          meta,
          inlineStyles: o.getInlineStyles(meta, e),
          inlineStylesPrepend: true,
        ));
    if (e.attributes.containsKey('style')) {
      _attrStyleRegExp.allMatches(e.attributes['style']).forEach((m) =>
          meta = lazySet(meta, inlineStyles: [m[1].trim(), m[2].trim()]));
    }
    meta?.styles((k, v) => meta = wf.parseElementStyle(meta, k, v));

    meta?.freezeOps(e)?.forEach((o) => o.collectMetadata(meta));

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

      final style = wf.buildTextStyle(meta, _parentStyle.textStyle);
      final isBlockElement = meta?.isBlockElement == true;
      final __builder = Builder(
        domNode.nodes,
        wf,
        parentBlock: isBlockElement ? null : _textPiece.block,
        parentMeta: meta,
        parentStyle: style != null ? _ParentStyle(style: style) : _parentStyle,
      );

      if (isBlockElement) {
        _saveTextPiece();
        _pieces.add(_Piece(
          this,
          parentStyle: _parentStyle,
          widgets: __builder.build(),
        ));
        continue;
      }

      int i = 0;
      for (final __piece in __builder.process()) {
        i++;
        if (i == 1) {
          if (__piece.block?.isSubOf(_textPiece.block) == true) {
            continue;
          } else {
            // discard the active text piece
            // because sub builder somehow consumed it already
            _newTextPiece();
          }
        }

        _saveTextPiece();
        _pieces.add(__piece);
      }
    }

    _saveTextPiece();

    Iterable<BuiltPiece> output = _pieces;
    parentMeta?.ops((o) => output = o.onPieces(parentMeta, output));
    return output;
  }

  void _newTextPiece() => _textPiece = _Piece(
        this,
        block: (_pieces.isEmpty ? parentBlock?.sub() : null) ?? TextBlock(),
        parentStyle: _parentStyle,
      );

  void _saveTextPiece() {
    _pieces.add(_textPiece);
    _newTextPiece();
  }
}

class _Piece extends BuiltPiece {
  final Builder b;
  final _ParentStyle parentStyle;
  final Iterable<Widget> widgets;

  final TextBlock block;

  _Piece(
    this.b, {
    this.block,
    this.parentStyle,
    this.widgets,
  })  : assert((block == null) != (widgets == null)),
        assert(parentStyle != null);

  @override
  bool get hasWidgets => widgets != null;

  @override
  TextStyle get style => parentStyle.textStyle;

  void _write(String text) {
    final leading = _textLeadingSpacingRegExp.firstMatch(text);
    final trailing = _textTrailingSpacingRegExp.firstMatch(text);
    final start = leading == null ? 0 : leading.end;
    final end = trailing == null ? text.length : trailing.start;

    if (end <= start) return __addSpace();

    if (start > 0) __addSpace();
    __addText(text.substring(start, end));
    if (end < text.length) __addSpace();
  }

  void __addSpace() =>
      block.addBit(TextBit.space(style: parentStyle.textBitStyle));

  void __addText(String data) => block.addBit(TextBit(
        data: data..replaceAll(_whitespaceDuplicateRegExp, ' '),
        style: parentStyle.textBitStyle,
      ));
}

class _ParentStyle {
  final bool hasStyling;
  final TextStyle textStyle;

  _ParentStyle({WidgetFactory wf, TextStyle style})
      : assert((wf == null) != (style == null)),
        hasStyling = style != null,
        textStyle = style ?? DefaultTextStyle.of(wf.context).style;

  TextStyle get textBitStyle => hasStyling ? textStyle : null;
}
