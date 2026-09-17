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

    final allowParts = <String>[];
    if (widget.mediaPlaybackAlwaysAllow) {
      allowParts.add('autoplay');
    }
    final allow = widget.allow;
    if (allow != null && allow.isNotEmpty) {
      allowParts.add(allow);
    }
    if (allowParts.isNotEmpty) {
      _iframeElement.allow = allowParts.join('; ');
    }

    if (widget.allowFullscreen) {
      _iframeElement.allowFullscreen = true;
    }

    // https://docs.flutter.dev/release/breaking-changes/platform-views-using-html-slots-web
    _iframeElement.style
      ..height = '100%'
      ..width = '100%';

    final viewType = '$this#$hashCode';

    platformViewRegistry.registerViewFactory(viewType, (_) => _iframeElement);

    // TODO: switch to `webview_flutter_web` when it's endorsed
    _iframeWidget = HtmlElementView(viewType: viewType);
  }

  @override
  Widget build(BuildContext context) => AspectRatio(
        aspectRatio: widget.aspectRatio,
        child: _iframeWidget,
      );
}
