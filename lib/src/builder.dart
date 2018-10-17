import 'package:flutter/widgets.dart';
import 'package:html/dom.dart' as dom;

import '../config.dart';
import '../widget_factory.dart';
import 'styling.dart';

class Builder {
  final BuildContext context;
  final List<dom.Node> domNodes;
  final NodeMetadata parentMeta;
  final int textPrefixForList;
  final WidgetFactory wf;

  final TextStyle _parentStyle;
  _BuiltPiece _piece;
  final List<_BuiltPiece> _pieces = List();

  Builder({
    @required this.context,
    @required this.domNodes,
    this.parentMeta,
    TextStyle parentStyle,
    this.textPrefixForList,
    @required WidgetFactory widgetFactory,
  })  : wf = widgetFactory,
        _parentStyle = parentStyle ?? DefaultTextStyle.of(context).style;

  List<Widget> build() {
    final List<Widget> widgets = List();
    final addWidgetIfNotNull = (Widget w) => w != null ? widgets.add(w) : null;

    final image = parentMeta?.image;
    if (image != null) {
      addWidgetIfNotNull(wf.buildImageWidget(image));
    }

    for (final piece in process()) {
      if (piece.hasTextSpan) {
        addWidgetIfNotNull(wf.wrapTextWidget(wf.buildTextWidgetWithStyling(
          text: piece._buildTextSpan(trimLeft: true),
          textAlign: parentMeta?.textAlign,
        )));
      } else if (piece.hasText) {
        addWidgetIfNotNull(wf.wrapTextWidget(wf.buildTextWidgetSimple(
          text: piece.text,
          textAlign: parentMeta?.textAlign,
        )));
      } else if (piece.hasWidgets) {
        piece.widgets.forEach(addWidgetIfNotNull);
      }
    }

    if (parentMeta?.listType != null && widgets.isNotEmpty) {
      return <Widget>[
        wf.buildColumn(
          children: widgets,
          indent: true,
        )
      ];
    }

    return widgets;
  }

  List<_BuiltPiece> process() {
    _pieces.clear();
    _newPiece(
      textPrefix: textPrefixForList != null
          ? wf.config.getTextPrefixForList(textPrefixForList)
          : null,
    );

    for (final domNode in domNodes) {
      NodeMetadata meta;
      switch (domNode.nodeType) {
        case dom.Node.ELEMENT_NODE:
          meta = collectMetadata(wf.config, domNode);

          if (wf.config.parseElementCallback != null) {
            meta = wf.config.parseElementCallback(domNode, meta);
          }
          break;
        case dom.Node.TEXT_NODE:
          _piece._write(domNode.text);
          break;
      }

      if (meta?.isNotRenderable == true) continue;

      final style = buildTextStyle(meta, _parentStyle);
      final __builder = Builder(
        context: context,
        domNodes: meta?.domNodes ?? domNode.nodes,
        parentMeta: meta,
        parentStyle: style ?? _parentStyle,
        textPrefixForList: parentMeta?.listType == null
            ? null
            : parentMeta.listType == ListType.Ordered ? _pieces.length + 1 : 0,
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
            _pieces.add(_BuiltPiece(builder: this, widgets: <Widget>[
              wf.buildColumn(
                children: __piece.widgets,
                url: meta.href,
              )
            ]));
          } else {
            _pieces.add(__piece);
          }
        }
      }
    }

    _savePiece();

    return _pieces;
  }

  _newPiece({String textPrefix}) {
    _piece = _BuiltPiece(
      builder: this,
      style: metaHasStyling(parentMeta) ? _parentStyle : null,
      textPrefix: textPrefix,
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
  final String url;
  final String textPrefix;
  final List<Widget> widgets;

  final StringBuffer _texts;
  List<TextSpan> _spans;
  bool _textPrefixWritten = false;

  _BuiltPiece({
    @required Builder builder,
    this.style,
    this.textPrefix,
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
      context: b.context,
      children: _spans,
      style: style,
      text: trimLeft ? text.trimLeft() : text,
      url: url,
    );
  }

  void _write(String text) {
    writeTextPrefixIfNeeded();

    if (_spans == null) {
      _texts.write(text);
    } else {
      _addSpan(b.wf.buildTextSpan(context: b.context, text: text));
    }
  }

  void writeTextPrefixIfNeeded() {
    if (textPrefix != null && !_textPrefixWritten) {
      _textPrefixWritten = true;
      _write(textPrefix);
    }
  }
}
