import 'dart:html' show IFrameElement;
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

import 'web_view.dart';

class WebViewState extends State<WebView> {
  final _iframeElement = IFrameElement();
  late Widget _iframeWidget;

  @override
  void initState() {
    super.initState();

    _iframeElement.src = widget.url;
    _iframeElement.style.border = 'none';

    if (widget.mediaPlaybackAlwaysAllow) {
      _iframeElement.allow = 'autoplay';
    }

    final viewType = '$this#$hashCode';

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry
        .registerViewFactory(viewType, (_) => _iframeElement);

    _iframeWidget = HtmlElementView(viewType: viewType);
  }

  @override
  Widget build(BuildContext _) => AspectRatio(
        aspectRatio: widget.aspectRatio,
        child: _iframeWidget,
      );
}
