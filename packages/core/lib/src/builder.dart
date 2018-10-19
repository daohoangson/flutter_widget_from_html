import 'package:flutter/widgets.dart';
import 'package:html/dom.dart' as dom;

import 'metadata.dart';
import 'widget_factory.dart';

class Builder {
  final List<dom.Node> domNodes;
  final NodeMetadata parentMeta;
  final WidgetFactory wf;

  final TextStyle _parentStyle;
  _BuiltPiece _piece;
  final List<_BuiltPiece> _pieces = List();

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

    final image = parentMeta?.image;
    if (image != null) {
      addWidgetIfNotNull(wf.buildImageWidget(image));
    }

    for (final piece in process()) {
      if (piece.hasTextSpan) {
        addWidgetIfNotNull(wf.buildTextWidget(
          piece._buildTextSpan(trimLeft: true),
          textAlign: parentMeta?.textAlign,
        ));
      } else if (piece.hasText) {
        addWidgetIfNotNull(wf.buildTextWidget(
          piece.text,
          textAlign: parentMeta?.textAlign,
        ));
      } else if (piece.hasWidgets) {
        piece.widgets.forEach(addWidgetIfNotNull);
      }
    }

    if (parentMeta?.listType != null && widgets.isNotEmpty) {
      widgets = <Widget>[wf.buildColumnForList(widgets, parentMeta.listType)];
    }

    if (parentMeta?.display == DisplayType.BlockScrollable) {
      widgets = <Widget>[wf.buildScrollView(widgets)];
    }

    return widgets;
  }

  List<_BuiltPiece> process() {
    _pieces.clear();
    _newPiece();

    for (final domNode in domNodes) {
      NodeMetadata meta;
      switch (domNode.nodeType) {
        case dom.Node.ELEMENT_NODE:
          meta = wf.collectMetadata(domNode);
          break;
        case dom.Node.TEXT_NODE:
          _piece._write(domNode.text);
          break;
      }

      if (meta?.isNotRenderable == true) continue;

      final style = wf.buildTextStyle(meta, _parentStyle);
      final __builder = Builder(
        domNodes: meta?.domNodes ?? domNode.nodes,
        parentMeta: meta,
        parentStyle: style ?? _parentStyle,
        widgetFactory: wf,
      );

      if (meta?.isBlockElement == true) {
        _savePiece();
        _pieces.add(_BuiltPiece(builder: this, widgets: __builder.build()));
        continue;
      }

      for (final __piece in __builder.process()) {
        if (__piece.hasTextSpan) {
          _piece._addSpan(__piece._buildTextSpan());
        } else if (__piece.hasText) {
          _piece._write(__piece.text);
        } else if (__piece.hasWidgets) {
          _savePiece();

          if (meta?.href?.isNotEmpty == true) {
            final gd = wf.buildGestureDetectorToLaunchUrl(
                wf.buildColumn(__piece.widgets), meta.href);
            if (gd != null) {
              _pieces.add(_BuiltPiece(builder: this, widgets: <Widget>[gd]));
            }
          } else {
            _pieces.add(__piece);
          }
        }
      }
    }

    _savePiece();

    return _pieces;
  }

  _newPiece() {
    _piece = _BuiltPiece(
      builder: this,
      style: parentMeta?.hasStyling == true ? _parentStyle : null,
      textSpaceCollapse: parentMeta?.textSpaceCollapse,
      url: parentMeta?.href,
    );
  }

  _savePiece() {
    if (_piece.hasText || _piece.hasTextSpan) {
      _pieces.add(_piece);
    }

    _newPiece();
  }
}

class _BuiltPiece {
  final Builder b;
  final TextStyle style;
  final String textPrefix;
  final bool textSpaceCollapse;
  final String url;
  final List<Widget> widgets;

  final StringBuffer _texts;
  List<TextSpan> _spans;
  bool _textPrefixWritten = false;

  _BuiltPiece({
    @required Builder builder,
    this.style,
    this.textPrefix,
    this.textSpaceCollapse,
    this.url,
    this.widgets,
  })  : b = builder,
        _texts = widgets == null ? StringBuffer() : null;

  bool get hasText => _texts?.isNotEmpty == true;
  bool get hasTextSpan => style != null || _spans != null;
  bool get hasWidgets => widgets != null;
  String get text => _texts.toString();

  void _addSpan(TextSpan span) {
    writeTextPrefixIfNeeded();

    if (span == null) return;
    if (hasWidgets) throw ('Cannot add spans into piece with widgets');
    if (_spans == null) _spans = List();

    if (span.style != null || span.text?.isNotEmpty != false) {
      _spans.add(span);
    } else {
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
      url: url,
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
