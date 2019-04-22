import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart'
    show BuildOp, BuiltPieceSimple, NodeMetadata, loopElementStyle;

import '../widget_factory.dart';

// this is required because recognizer does not trigger for children
// https://github.com/flutter/flutter/issues/10623
TextSpan _buildTextSpan(TextSpan span, GestureRecognizer r) => TextSpan(
      children: span?.children == null
          ? null
          : span.children.map((s) => _buildTextSpan(s, r)).toList(),
      style: span?.style,
      recognizer: r,
      text: span?.text,
    );

class TagA {
  final WidgetFactory wf;
  final bool icon;

  BuildOp _buildOp;

  TagA(
    this.wf, {
    this.icon = true,
  });

  BuildOp get buildOp {
    _buildOp ??= BuildOp(
      onPieces: (meta, pieces) {
        final onTap = _buildGestureTapCallback(meta);

        return pieces.map(
          (piece) => piece.hasWidgets
              ? BuiltPieceSimple(
                  widgets: <Widget>[
                    _buildGestureDetector(wf.buildColumn(piece.widgets), onTap),
                  ],
                )
              : BuiltPieceSimple(
                  textSpan: _buildTextSpan(
                    piece.textSpan,
                    TapGestureRecognizer()..onTap = onTap,
                  ),
                ),
        );
      },
    );

    return _buildOp;
  }

  Widget _buildGestureDetector(Widget child, GestureTapCallback onTap) =>
      child != null
          ? GestureDetector(
              child: icon
                  ? Stack(children: <Widget>[child, _buildIconOpenInNew()])
                  : child,
              onTap: onTap,
            )
          : null;

  GestureTapCallback _buildGestureTapCallback(NodeMetadata meta) {
    final attrs = meta.buildOpElement.attributes;
    final href = attrs.containsKey('href') ? attrs['href'] : '';
    final fullUrl = buildFullUrl(href, wf.config.baseUrl) ?? href;
    return wf.buildGestureTapCallbackForUrl(fullUrl);
  }

  Widget _buildIconOpenInNew() => Positioned(
        top: 0.0,
        right: 0.0,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Icon(
            Icons.open_in_new,
            color: Theme.of(wf.context).accentColor.withOpacity(.8),
            size: 40.0,
          ),
        ),
      );
}
