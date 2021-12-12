import 'package:flutter/material.dart';
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
  void reset(State state) {
    final widget = state.widget;
    _widget = widget is HtmlWidget ? widget : null;

    super.reset(state);
  }
}
