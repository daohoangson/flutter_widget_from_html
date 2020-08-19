import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart'
    as enhanced;

class HtmlWidget extends StatelessWidget {
  final String html;
  final void Function(String) onTapUrl;

  const HtmlWidget(
    this.html, {
    Key key,
    this.onTapUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => enhanced.HtmlWidget(
        html,
        onTapUrl: onTapUrl,
        webView: !kIsWeb,
      );
}
