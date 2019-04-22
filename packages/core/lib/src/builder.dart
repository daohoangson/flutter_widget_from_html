import 'package:flutter/widgets.dart';
import 'package:html/dom.dart' as dom;

import 'core_wf.dart';
import 'metadata.dart';
import 'parser.dart';

final _textIsUselessRegExp = RegExp(r'^\s*$');

bool checkTextIsUseless(String text) =>
    text != null && _textIsUselessRegExp.firstMatch(text) != null;

bool checkTextSpanIsUseless(TextSpan span) {
  if (span == null) return true;
  if (span.children?.isNotEmpty == true) return false;

  return checkTextIsUseless(span.text);
}

class Builder {
  final List<dom.Node> domNodes;
  final NodeMetadata parentMeta;
  final WidgetFactory wf;

  final _ParentStyle _parentStyle;
  _BuiltPiece _piece;
  final List<BuiltPiece> _pieces = List();

  Builder({
    @required this.domNodes,
    this.parentMeta,
    _ParentStyle parentStyle,
    @required WidgetFactory widgetFactory,
  })  : wf = widgetFactory,
        _parentStyle = parentStyle ??
            _ParentStyle(
              false,
              DefaultTextStyle.of(widgetFactory.context).style,
            );

  List<Widget> build() {
    List<Widget> widgets = List();
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

    if (parentMeta?.buildOps != null) {
      parentMeta.buildOps.forEach((buildOp) {
        final f = buildOp.onWidgets;
        if (f != null) {
          final widget = f(parentMeta, widgets);
          if (widget != null) widgets = <Widget>[widget];
        }
      });
    }

    final margin = parentMeta?.margin;
    if (margin != null) widgets = [wf.buildMargin(widgets, margin)];

    return widgets;
  }

  NodeMetadata collectMetadata(dom.Element e) {
    var meta = wf.parseElement(null, e);
    attrStyleLoop(e, (k, v) => meta = wf.parseElementStyle(meta, k, v));

    if (meta?.buildOps != null) {
      meta.buildOpElement = e;
      meta.buildOps.sort((a, b) => a.priority.compareTo(b.priority));
      meta.buildOps = List.unmodifiable(meta.buildOps);

      meta.buildOps.forEach((buildOp) {
        final f = buildOp.collectMetadata;
        if (f != null) f(meta);
      });
    }

    return meta;
  }

  Iterable<BuiltPiece> process() {
    _pieces.clear();
    _newPiece();

    final domNodesLength = domNodes.length;
    for (var domNodeId = 0; domNodeId < domNodesLength; domNodeId++) {
      final domNode = domNodes[domNodeId];
      if (domNode.nodeType == dom.Node.TEXT_NODE) {
        _piece._write(
          domNode.text,
          isLast: domNodeId == domNodesLength - 1,
        );
        continue;
      }
      if (domNode.nodeType != dom.Node.ELEMENT_NODE) {
        continue;
      }
      final meta = collectMetadata(domNode);
      if (meta?.isNotRenderable == true) continue;

      if (meta?.buildOps != null) {
        var buildOpProcessed = false;
        meta.buildOps.forEach((buildOp) {
          final f = buildOp.onProcess;
          if (f != null) {
            f(meta, _piece._addSpan, _addWidgets, _piece._write);
            buildOpProcessed = true;
          }
        });
        if (buildOpProcessed) continue;
      }

      final style = wf.buildTextStyle(meta, _parentStyle.textStyle);
      final __builder = Builder(
        domNodes: domNode.nodes,
        parentMeta: meta,
        parentStyle: style != null ? _ParentStyle(true, style) : _parentStyle,
        widgetFactory: wf,
      );

      if (meta?.isBlockElement == true) {
        _addWidgets(__builder.build());
        continue;
      }

      final __pieces = __builder.process();
      final __lastPiece = __pieces.last;
      __pieces.forEach((__piece) {
        if (__piece.hasTextSpan) {
          _piece._addSpan(__piece.textSpan);
        } else if (__piece.hasText) {
          _piece._write(__piece.text, isLast: __piece == __lastPiece);
        } else if (__piece.hasWidgets) {
          _savePiece();
          _pieces.add(__piece);
        }
      });
    }

    _savePiece();

    if (parentMeta?.buildOps != null) {
      Iterable<BuiltPiece> buildOpPieces = _pieces;
      parentMeta.buildOps.forEach((buildOp) {
        final f = buildOp.onPieces;
        if (f != null) {
          buildOpPieces = f(parentMeta, buildOpPieces);
        }
      });
      if (buildOpPieces != _pieces) return buildOpPieces;
    }

    return _pieces;
  }

  void _addWidgets(List<Widget> widgets) {
    _savePiece();
    _pieces.add(_BuiltPiece(builder: this, widgets: widgets));
  }

  void _newPiece() {
    _piece = _BuiltPiece(
      builder: this,
      parentStyle: _parentStyle,
      textSpaceCollapse: parentMeta?.textSpaceCollapse,
    );
  }

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
    if (span == null) return;
    if (hasWidgets) throw ('Cannot add spans into piece with widgets');
    if (_spans == null) _spans = List();

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
