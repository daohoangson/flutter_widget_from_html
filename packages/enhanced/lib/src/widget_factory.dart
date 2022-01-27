// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter/widgets.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart'
    as core show WidgetFactory;
import 'package:fwfh_cached_network_image/fwfh_cached_network_image.dart';
import 'package:fwfh_chewie/fwfh_chewie.dart';
import 'package:fwfh_just_audio/fwfh_just_audio.dart';
import 'package:fwfh_selectable_text/fwfh_selectable_text.dart';
import 'package:fwfh_svg/fwfh_svg.dart';
import 'package:fwfh_url_launcher/fwfh_url_launcher.dart';
import 'package:fwfh_webview/fwfh_webview.dart';

import 'html_widget.dart';

/// A factory to build widgets with [WebView], [VideoPlayer], etc.
class WidgetFactory extends core.WidgetFactory
    with
        CachedNetworkImageFactory,
        ChewieFactory,
        JustAudioFactory,
        SelectableTextFactory,
        SvgFactory,
        UrlLauncherFactory,
        WebViewFactory {
  HtmlWidget? _widget;

  @override
  bool get selectableText => _widget?.isSelectable == true;

  @override
  SelectionChangedCallback? get selectableTextOnChanged =>
      _widget?.onSelectionChanged;

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
  String? get webViewUserAgent => _widget?.webViewUserAgent;

  @override
  void reset(State state) {
    final widget = state.widget;
    _widget = widget is HtmlWidget ? widget : null;

    super.reset(state);
  }
}
