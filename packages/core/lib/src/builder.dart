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

  _BuiltPiece _piece;

  Builder(
    this.domNodes,
    this.wf, {
    this.parentMeta,
    _ParentStyle parentStyle,
  }) : _parentStyle = parentStyle ??
            _ParentStyle(false, DefaultTextStyle.of(wf.context).style);

  List<Widget> build() {
    var widgets = <Widget>[];
    final addWidgetIfNotNull = (Widget w) => w != null ? widgets.add(w) : null;

    for (final piece in process()) {
      if (piece.hasTextSpan) {
        addWidgetIfNotNull(wf.buildTextWidget(
          piece.textSpan,
          textAlign: piece.textAlign,
        ));
      } else if (piece.hasText) {
        addWidgetIfNotNull(wf.buildTextWidget(
          piece.text,
          textAlign: piece.textAlign,
        ));
      } else if (piece.hasWidgets) {
        piece.widgets.forEach(addWidgetIfNotNull);
      }
    }

    parentMeta?.forEachOp((o) => widgets = o.onWidgets(parentMeta, widgets));

    final margin = parentMeta?.margin;
    if (margin != null) widgets = [wf.buildMargin(widgets, margin)];

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

      if (meta?.buildOps != null) {
        final _as = _piece._addSpan;
        final _w = _piece._write;
        for (final buildOp in meta.buildOps.reversed) {
          if (buildOp.onProcess(meta, _as, _addWidgets, _w)) return;
        }
      }

      final style = wf.buildTextStyle(meta, _parentStyle.textStyle);
      final __builder = Builder(
        domNode.nodes,
        wf,
        parentMeta: meta,
        parentStyle: style != null ? _ParentStyle(true, style) : _parentStyle,
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

  void _addWidgets(List<Widget> widgets) {
    _savePiece();
    _pieces.add(_BuiltPiece(builder: this, widgets: widgets));
  }

  void _newPiece() => _piece = _BuiltPiece(
        builder: this,
        parentStyle: _parentStyle,
        textSpaceCollapse: parentMeta?.textSpaceCollapse,
      );

  void _savePiece() {
    if ((_piece.hasText && !checkTextIsUseless(_piece.text)) ||
        (_piece.hasTextSpan && !checkTextSpanIsUseless(_piece.textSpan))) {
      _pieces.add(_piece);
    }
    _newPiece();
  }
}

class _BuiltPiece extends BuiltPiece {
  final Builder b;
  final _ParentStyle parentStyle;
  TextAlign textAlign;
  final bool textSpaceCollapse;
  final List<Widget> widgets;

  final StringBuffer _texts;
  List<TextSpan> _spans;

  _BuiltPiece({
    @required Builder builder,
    this.parentStyle,
    this.textSpaceCollapse,
    this.widgets,
  })  : b = builder,
        _texts = widgets == null ? StringBuffer() : null;

  @override
  bool get hasText => _texts?.isNotEmpty == true;

  @override
  bool get hasTextSpan => parentStyle?.hasStyling == true || _spans != null;

  @override
  bool get hasWidgets => widgets != null;

  @override
  String get text => _texts.toString();

  @override
  TextSpan get textSpan {
    if (!hasText && _spans?.length == 1) {
      return _spans[0];
    }

    return _buildTextSpan(text, children: _spans);
  }

  void _addSpan(TextSpan span) {
    if (span == null || hasWidgets) return;
    _spans ??= List();
    _spans.add(span);
  }

  TextSpan _buildTextSpan(String text, {List<TextSpan> children}) =>
      b.wf.buildTextSpan(
        text,
        children: children,
        style: parentStyle?.textStyle,
        textSpaceCollapse: textSpaceCollapse,
      );

  void _write(String text, {bool isLast = false}) {
    final isFirst = _texts.isEmpty && _spans?.isEmpty != false;
    if (isFirst && !isLast) {
      text = text.trimLeft();
    } else if (isLast && !isFirst) {
      text = text.trimRight();
    }

    if (_spans == null) {
      _texts.write(text);
    } else {
      _addSpan(_buildTextSpan(text));
    }
  }
}

class _ParentStyle {
  final bool hasStyling;
  final TextStyle textStyle;

  _ParentStyle(this.hasStyling, this.textStyle);
}
