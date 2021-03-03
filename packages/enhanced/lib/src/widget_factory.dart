import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart'
    as core show WidgetFactory;
import 'package:fwfh_chewie/fwfh_chewie.dart';
import 'package:fwfh_svg/fwfh_svg.dart';
import 'package:fwfh_url_launcher/fwfh_url_launcher.dart';
import 'package:fwfh_webview/fwfh_webview.dart';

import 'data.dart';
import 'html_widget.dart';

/// A factory to build widgets with [WebView], [VideoPlayer], etc.
class WidgetFactory extends core.WidgetFactory
    with ChewieFactory, SvgFactory, UrlLauncherFactory, WebViewFactory {
  TextStyleHtml Function(TextStyleHtml, dynamic) _tagA;
  HtmlWidget _widget;

  @override
  bool get webView => _widget?.webView == true;

  @override
  bool get webViewDebuggingEnabled => _widget?.webViewDebuggingEnabled == true;

  @override
  bool get webViewJs => _widget?.webViewJs == true;

  @override
  bool get webViewMediaPlaybackAlwaysAllow =>
      _widget?.webViewMediaPlaybackAlwaysAllow == true;

  @override
  String get webViewUserAgent => _widget?.webViewUserAgent;

  /// Builds [Divider].
  @override
  Widget buildDivider(BuildMetadata meta) => const Divider(height: 1);

  /// Builds [InkWell].
  @override
  Widget buildGestureDetector(
          BuildMetadata meta, Widget child, GestureTapCallback onTap) =>
      InkWell(onTap: onTap, child: child);

  @override
  Widget buildImage(BuildMetadata meta, ImageMetadata data) {
    var built = super.buildImage(meta, data);

    if (built != null && data.title != null) {
      built = Tooltip(message: data.title, child: built);
    }

    return built;
  }

  @override
  Iterable<dynamic> getDependencies(BuildContext context) =>
      [...super.getDependencies(context), Theme.of(context)];

  @override
  ImageProvider imageProviderFromNetwork(String url) =>
      url?.isNotEmpty == true ? CachedNetworkImageProvider(url) : null;

  @override
  void parse(BuildMetadata meta) {
    switch (meta.element.localName) {
      case 'a':
        _tagA ??= (tsh, _) => tsh.copyWith(
            style: tsh.style
                .copyWith(color: tsh.getDependency<ThemeData>().accentColor));
        meta.tsb.enqueue(_tagA);
        break;
    }

    return super.parse(meta);
  }

  @override
  void reset(State state) {
    final widget = state.widget;
    _widget = widget is HtmlWidget ? widget : null;

    super.reset(state);
  }
}
