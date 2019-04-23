import 'package:flutter/widgets.dart';
import 'package:html/dom.dart' as dom;

import 'core_wf.dart';
import 'metadata.dart';
import 'parser.dart';

class Builder {
  final List<dom.Node> domNodes;
  final NodeMetadata parentMeta;
  final WidgetFactory wf;

  final _ParentStyle _parentStyle;
  final _pieces = <BuiltPiece>[];

  _Piece _piece;

  Builder(this.domNodes, this.wf, {this.parentMeta, _ParentStyle parentStyle})
      : _parentStyle = parentStyle ?? _ParentStyle(wf: wf);

  List<Widget> build() {
    var widgets = <Widget>[];

    final addWidget = (Widget w) => w != null ? widgets.add(w) : null;
    process().forEach((p) => p.hasWidgets
        ? p.widgets.forEach(addWidget)
        : addWidget(wf.buildTextWidget(p.hasTextSpan ? p.textSpan : p.text)));

    parentMeta?.forEachOp((o) => widgets = o.onWidgets(parentMeta, widgets));

    return widgets;
  }

  NodeMetadata collectMetadata(dom.Element e) {
    var meta = wf.parseElement(null, e);
    attrStyleLoop(e, (k, v) => meta = wf.parseElementStyle(meta, k, v));
    meta?.freezeOps(e)?.forEach((o) => o.collectMetadata(meta));

    return meta;
  }

  Iterable<BuiltPiece> process() {
    _newPiece();

    domNodes.forEach((domNode) {
      if (domNode.nodeType == dom.Node.TEXT_NODE) {
        return _piece._write(domNode.text, isLast: domNode == domNodes.last);
      }
      if (domNode.nodeType != dom.Node.ELEMENT_NODE) return;

      final meta = collectMetadata(domNode);
      if (meta?.isNotRenderable == true) return;

      final style = wf.buildTextStyle(meta, _parentStyle.textStyle);
      final __builder = Builder(
        domNode.nodes,
        wf,
        parentMeta: meta,
        parentStyle: style != null ? _ParentStyle(style: style) : _parentStyle,
      );

      if (meta?.isBlockElement == true) return _addWidgets(__builder.build());

      final __pieces = __builder.process();
      __pieces.forEach((__piece) {
        if (__piece.hasTextSpan) {
          _piece._addSpan(__piece.textSpan);
        } else if (__piece.hasText) {
          _piece._write(__piece.text, isLast: __piece == __pieces.last);
        } else if (__piece.hasWidgets) {
          _savePiece();
          _pieces.add(__piece);
        }
      });
    });

    _savePiece();

    Iterable<BuiltPiece> output = _pieces;
    parentMeta?.forEachOp((o) => output = o.onPieces(parentMeta, output));
    return output;
  }

  void _addWidgets(Iterable<Widget> widgets) {
    _savePiece();
    _pieces.add(_Piece(this, widgets: widgets));
  }

  void _newPiece() => _piece = _Piece(this, parentStyle: _parentStyle);

  void _savePiece() {
    if ((_piece.hasText && !checkTextIsUseless(_piece.text)) ||
        (_piece.hasTextSpan && !checkTextSpanIsUseless(_piece.textSpan))) {
      _pieces.add(_piece);
    }
    _newPiece();
  }
}

class _Piece extends BuiltPiece {
  final Builder b;
  final _ParentStyle parentStyle;
  final Iterable<Widget> widgets;

  final StringBuffer _texts;
  List<TextSpan> _spans;

  _Piece(
    this.b, {
    this.parentStyle,
    this.widgets,
  }) : _texts = widgets == null ? StringBuffer() : null;

  @override
  bool get hasText => _texts?.isNotEmpty == true;

  @override
  bool get hasTextSpan => parentStyle?.hasStyling == true || _spans != null;

  @override
  bool get hasWidgets => widgets != null;

  @override
  String get text => _texts.toString();

  @override
  TextSpan get textSpan => (!hasText && _spans?.length == 1)
      ? _spans[0]
      : _buildTextSpan(text, children: _spans);

  @override
  TextStyle get textStyle => parentStyle?.textStyle;

  void _addSpan(TextSpan span) {
    if (span == null || hasWidgets) return;
    _spans ??= List();
    _spans.add(span);
  }

  TextSpan _buildTextSpan(String text, {List<TextSpan> children}) =>
      b.wf.buildTextSpan(text, children: children, style: textStyle);

  void _write(String text, {bool isLast = false}) {
    final isFirst = _texts.isEmpty && _spans?.isEmpty != false;
    if (isFirst && !isLast) {
      text = text.trimLeft();
    } else if (isLast && !isFirst) {
      text = text.trimRight();
    }

    _spans == null ? _texts.write(text) : _addSpan(_buildTextSpan(text));
  }
}

class _ParentStyle {
  final bool hasStyling;
  final TextStyle textStyle;

  _ParentStyle({WidgetFactory wf, TextStyle style})
      : assert((wf == null) != (style == null)),
        hasStyling = style != null,
        textStyle = style ?? DefaultTextStyle.of(wf.context).style;
}
