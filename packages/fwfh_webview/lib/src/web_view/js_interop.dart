import 'dart:ui_web';

import 'package:flutter/widgets.dart';
import 'package:web/web.dart';

import 'web_view.dart';

class WebViewState extends State<WebView> {
  final _iframeElement = document.createElement('iframe') as HTMLIFrameElement;
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

    platformViewRegistry.registerViewFactory(viewType, (_) => _iframeElement);

    // TODO: switch to `webview_flutter_web` when it's endorsed
    _iframeWidget = HtmlElementView(viewType: viewType);
  }

  @override
  Widget build(BuildContext _) => AspectRatio(
        aspectRatio: widget.aspectRatio,
        child: _iframeWidget,
      );
}
