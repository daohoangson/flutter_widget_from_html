import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart'
    show BuiltPiece, BuiltPieceSimple, NodeMetadata;
import 'package:url_launcher/url_launcher.dart';

import '../widget_factory.dart';

class TagA {
  final String fullUrl;
  final WidgetFactory wf;
  final bool icon;

  TagA(
    this.fullUrl,
    this.wf, {
    this.icon = true,
  });

  Widget buildGestureDetector(Widget child, GestureTapCallback onTap) =>
      child != null
          ? GestureDetector(
              onTap: onTap,
              child: icon
                  ? Stack(
                      children: <Widget>[
                        child,
                        buildGestureDetectorIcon(),
                      ],
                    )
                  : child,
            )
          : null;

  Widget buildGestureDetectorIcon() => Positioned(
        top: 0.0,
        right: 0.0,
        child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Icon(
              Icons.open_in_new,
              color: Theme.of(wf.context).accentColor.withOpacity(.8),
              size: 40.0,
            )),
      );

  List<BuiltPiece> onPieces(NodeMetadata meta, List<BuiltPiece> pieces) {
    List<BuiltPiece> newPieces = List();

    final onTap = prepareGestureTapCallback(fullUrl);
    final recognizer = TapGestureRecognizer()..onTap = onTap;

    for (final piece in pieces) {
      if (piece.hasTextSpan) {
        newPieces.add(BuiltPieceSimple(
          textSpan: rebuildTextSpanWithRecognizer(piece.textSpan, recognizer),
        ));
      } else if (piece.hasWidgets) {
        final gd = buildGestureDetector(wf.buildColumn(piece.widgets), onTap);
        if (gd != null) {
          newPieces.add(BuiltPieceSimple(widgets: <Widget>[gd]));
        }
      }
    }

    return newPieces;
  }

  GestureTapCallback prepareGestureTapCallback(String url) => () async {
        final fullUrl = buildFullUrl(url, wf.config.baseUrl);

        if (await canLaunch(fullUrl)) {
          await launch(fullUrl);
        }
      };

  // this is required because recognizer does not trigger for children
  // https://github.com/flutter/flutter/issues/10623
  TextSpan rebuildTextSpanWithRecognizer(TextSpan span, GestureRecognizer r) =>
      TextSpan(
        children: span?.children == null
            ? null
            : span.children
                .map((TextSpan subSpan) =>
                    rebuildTextSpanWithRecognizer(subSpan, r))
                .toList(),
        style: span?.style,
        recognizer: r,
        text: span?.text,
      );
}
