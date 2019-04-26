import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart'
    as core;

import '../packages/core/test/_.dart' as _coreTesting;

String _explainer(Widget widget) {
  if (widget is CachedNetworkImage)
    return "[CachedNetworkImage:${widget.imageUrl}]";

  if (widget is WebView) return widget.toString();

  return null;
}

Future<String> explain(WidgetTester tester, String html,
        {core.WidgetFactoryBuilder wf}) async =>
    _coreTesting.explain(
      tester,
      html,
      wf: wf ?? (c) => WidgetFactory(c),
      explainer: _explainer,
    );
