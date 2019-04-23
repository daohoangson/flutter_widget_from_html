import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart'
    show BuildOp, BuiltPieceSimple, NodeMetadata;

import '../widget_factory.dart';

class TagA {
  final WidgetFactory wf;
  final bool icon;

  TagA(this.wf, {this.icon = true});

  BuildOp get buildOp => BuildOp(
        collectMetadata: (m) => m.color ??= Theme.of(wf.context).accentColor,
        onPieces: (meta, pieces) {
          final tap = _buildGestureTapCallback(meta);
          final r = TapGestureRecognizer()..onTap = tap;

          return pieces.map(
            (p) => p.hasWidgets
                ? BuiltPieceSimple(widgets: <Widget>[_buildGd(p.widgets, tap)])
                : BuiltPieceSimple(textSpan: _buildTextSpan(p.textSpan, r)),
          );
        },
      );

  Widget _buildGd(List<Widget> widgets, GestureTapCallback onTap) {
    final w = wf.buildColumn(widgets);
    if (w == null) return null;

    final i = icon ? _buildPositionedIcon() : null;
    final child = i != null ? Stack(children: <Widget>[w, i]) : w;
    return GestureDetector(child: child, onTap: onTap);
  }

  GestureTapCallback _buildGestureTapCallback(NodeMetadata meta) {
    final attrs = meta.buildOpElement.attributes;
    final href = attrs.containsKey('href') ? attrs['href'] : '';
    final fullUrl = wf.constructFullUrl(href) ?? href;
    return wf.buildGestureTapCallbackForUrl(fullUrl);
  }

  Widget _buildPositionedIcon() => Positioned(
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
