import 'dart:html' show IFrameElement;
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

import '../web_view.dart';

class WebViewState extends State<WebView> {
  final _iframeElement = IFrameElement();

  Widget _iframeWidget;

  @override
  void initState() {
    super.initState();

    _iframeElement.src = widget.url;
    _iframeElement.style.border = 'none';

    final viewType = 'iframeElement#$hashCode';

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry
        .registerViewFactory(viewType, (_) => _iframeElement);

    _iframeWidget = HtmlElementView(viewType: viewType);
  }

  @override
  Widget build(BuildContext context) => AspectRatio(
        aspectRatio: widget.aspectRatio,
        child: _iframeWidget,
      );
}
