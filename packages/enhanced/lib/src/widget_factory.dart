import 'package:fintel_fwfh_cached_network_image/fwfh_cached_network_image.dart';
import 'package:fintel_fwfh_chewie/fwfh_chewie.dart';
import 'package:fintel_fwfh_just_audio/fwfh_just_audio.dart';
import 'package:fintel_fwfh_svg/fwfh_svg.dart';
import 'package:fintel_fwfh_url_launcher/fwfh_url_launcher.dart';
import 'package:fintel_fwfh_webview/fwfh_webview.dart';
import 'package:fintel_widget_from_html_core/flutter_widget_from_html_core.dart'
    as core show WidgetFactory;

/// A factory to build widgets with [WebView], [VideoPlayer], etc.
class WidgetFactory extends core.WidgetFactory
    with
        CachedNetworkImageFactory,
        ChewieFactory,
        JustAudioFactory,
        SvgFactory,
        UrlLauncherFactory,
        WebViewFactory {}
