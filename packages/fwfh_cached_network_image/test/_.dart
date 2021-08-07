import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fwfh_cached_network_image/fwfh_cached_network_image.dart';

import '../../core/test/_.dart' as helper;

final kDataUri = helper.kDataUri;

String? cachedNetworkImageExplainer(helper.Explainer parent, Widget widget) {
  if (widget is CachedNetworkImage) {
    return '[CachedNetworkImage:imageUrl=${widget.imageUrl}]';
  }

  return null;
}

Future<String> explain(WidgetTester tester, String html) async =>
    helper.explain(
      tester,
      null,
      explainer: cachedNetworkImageExplainer,
      hw: HtmlWidget(
        html,
        key: helper.hwKey,
        factoryBuilder: () => _WidgetFactory(),
      ),
    );

class _WidgetFactory extends WidgetFactory with CachedNetworkImageFactory {}
