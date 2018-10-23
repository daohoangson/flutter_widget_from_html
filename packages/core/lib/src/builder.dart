import 'package:flutter/widgets.dart';
import 'package:html/dom.dart' as dom;

import 'metadata.dart';
import 'core_wf.dart';

final _attributeStyleRegExp = RegExp(r'([a-zA-Z\-]+)\s*:\s*([^;]*)');
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

  final TextStyle _parentStyle;
  _BuiltPiece _piece;
  final List<BuiltPiece> _pieces = List();

  Builder({
    @required this.domNodes,
    this.parentMeta,
    TextStyle parentStyle,
    @required WidgetFactory widgetFactory,
  })  : wf = widgetFactory,
        _parentStyle = parentStyle ?? widgetFactory.defaultTextStyle;

  List<Widget> build() {
    List<Widget> widgets = List();
    final addWidgetIfNotNull = (Widget w) => w != null ? widgets.add(w) : null;

    for (final piece in process()) {
      if (piece.hasTextSpan) {
        addWidgetIfNotNull(wf.buildTextWidget(piece.textSpanTrimmedLeft));
      } else if (piece.hasText) {
        addWidgetIfNotNull(wf.buildTextWidget(piece.text));
      } else if (piece.hasWidgets) {
        piece.widgets.forEach(addWidgetIfNotNull);
      }
    }

    final buildOpOnWidgets = parentMeta?.buildOp?.onWidgets;
    if (buildOpOnWidgets != null) widgets = buildOpOnWidgets(widgets);

    return widgets;
  }

  NodeMetadata collectMetadata(dom.Element e) {
    var meta = wf.parseElement(e);

    final attribs = e.attributes;
    if (attribs.containsKey('style')) {
      final styles = _attributeStyleRegExp.allMatches(attribs['style']);
      for (final style in styles) {
        final styleKey = style[1].trim();
        final styleValue = style[2].trim();

        meta = wf.parseElementStyle(meta, styleKey, styleValue);
      }
    }

    return meta;
  }

  List<BuiltPiece> process() {
    _pieces.clear();
    _newPiece();

    for (final domNode in domNodes) {
      if (domNode.nodeType == dom.Node.TEXT_NODE) {
        _piece._write(domNode.text);
        continue;
      }
      if (domNode.nodeType != dom.Node.ELEMENT_NODE) {
        continue;
      }
      final meta = collectMetadata(domNode);
      if (meta?.isNotRenderable == true) continue;

      final buildOpOnProcess = meta?.buildOp?.onProcess;
      if (buildOpOnProcess != null) {
        buildOpOnProcess(_piece._addSpan, _addWidgets, _piece._write);
        continue;
      }

      final style = wf.buildTextStyle(meta, _parentStyle);
      final __builder = Builder(
        domNodes: domNode.nodes,
        parentMeta: meta,
        parentStyle: style ?? _parentStyle,
        widgetFactory: wf,
      );

      if (meta?.isBlockElement == true) {
        _addWidgets(__builder.build());
        continue;
      }

      for (final __piece in __builder.process()) {
        if (__piece.hasTextSpan) {
          _piece._addSpan(__piece.textSpan);
        } else if (__piece.hasText) {
          _piece._write(__piece.text);
        } else if (__piece.hasWidgets) {
          _savePiece();
          _pieces.add(__piece);
        }
      }
    }

    _savePiece();

    final buildOpOnPieces = parentMeta?.buildOp?.onPieces;
    if (buildOpOnPieces != null) return buildOpOnPieces(_pieces);

    return _pieces;
  }

  void _addWidgets(List<Widget> widgets) {
    _savePiece();
    _pieces.add(_BuiltPiece(builder: this, widgets: widgets));
  }

  void _newPiece() {
    _piece = _BuiltPiece(
      builder: this,
      style: parentMeta?.hasStyling == true ? _parentStyle : null,
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
  final TextStyle style;
  final String textPrefix;
  final bool textSpaceCollapse;
  final List<Widget> widgets;

  final StringBuffer _texts;
  List<TextSpan> _spans;
  bool _textPrefixWritten = false;

  _BuiltPiece({
    @required Builder builder,
    this.style,
    this.textPrefix,
    this.textSpaceCollapse,
    this.widgets,
  })  : b = builder,
        _texts = widgets == null ? StringBuffer() : null;

  @override
  bool get hasText => _texts?.isNotEmpty == true;

  @override
  bool get hasTextSpan => style != null || _spans != null;

  @override
  bool get hasWidgets => widgets != null;

  @override
  String get text => _texts.toString();

  @override
  TextSpan get textSpan => _buildTextSpan();

  @override
  TextSpan get textSpanTrimmedLeft => _buildTextSpan(trimLeft: true);

  void _addSpan(TextSpan span) {
    writeTextPrefixIfNeeded();

    if (span == null) return;
    if (hasWidgets) throw ('Cannot add spans into piece with widgets');
    if (_spans == null) _spans = List();

    if (span.style != null || span.text?.isNotEmpty != false) {
      _spans.add(span);
    } else if (span.children != null) {
      for (final subSpan in span.children) {
        _spans.add(subSpan);
      }
    }
  }

  TextSpan _buildTextSpan({bool trimLeft = false}) {
    if (!hasText && style == null && _spans.length == 1) {
      return _spans[0];
    }

    return b.wf.buildTextSpan(
      trimLeft ? text.trimLeft() : text,
      children: _spans,
      style: style,
      textSpaceCollapse: textSpaceCollapse,
    );
  }

  void _write(String text) {
    writeTextPrefixIfNeeded();

    if (_spans == null) {
      _texts.write(text);
    } else {
      _addSpan(b.wf.buildTextSpan(text));
    }
  }

  void writeTextPrefixIfNeeded() {
    if (textPrefix != null && !_textPrefixWritten) {
      _textPrefixWritten = true;
      _write(textPrefix);
    }
  }
}
