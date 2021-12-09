// ignore: avoid_web_libraries_in_flutter
import 'dart:html' show IFrameElement;

import 'package:flutter/widgets.dart';

import '../external/dart_ui.dart' as ui;
import 'web_view.dart';

class WebViewState extends State<WebView> {
  final _iframeElement = IFrameElement();
  late Widget _iframeWidget;

  @override
  void initState() {
    super.initState();

    // ignore: unsafe_html
    _iframeElement.src = widget.url;
    _iframeElement.style.border = 'none';

    if (widget.mediaPlaybackAlwaysAllow) {
      _iframeElement.allow = 'autoplay';
    }

    final viewType = '$this#$hashCode';

    ui.platformViewRegistry
        .registerViewFactory(viewType, (_) => _iframeElement);

    // TODO: switch to `webview_flutter_web` when it's endorsed
    _iframeWidget = HtmlElementView(viewType: viewType);
  }

  @override
  Widget build(BuildContext _) => AspectRatio(
        aspectRatio: widget.aspectRatio,
        child: _iframeWidget,
      );
}
