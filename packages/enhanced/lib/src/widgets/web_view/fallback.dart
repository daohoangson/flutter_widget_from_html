import 'package:flutter/widgets.dart';

import '../web_view.dart';

class WebViewState extends State<WebView> {
  @override
  Widget build(BuildContext context) =>
      AspectRatio(aspectRatio: widget.aspectRatio);
}
