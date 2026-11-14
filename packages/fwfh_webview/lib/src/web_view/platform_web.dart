import 'package:web/web.dart' as web;
import 'package:webview_all/webview_all.dart';
import 'package:webview_all_web/webview_all_web.dart';

import 'web_view.dart';

PlatformWebViewControllerCreationParams controllerCreationParams(
  WebView widget,
) {
  final allowParts = <String>[
    if (widget.mediaPlaybackAlwaysAllow) 'autoplay',
    if (widget.allow?.isNotEmpty == true) widget.allow!,
  ];

  return WebWebViewControllerCreationParams(
    iFrameAllow: allowParts.isNotEmpty ? allowParts.join('; ') : null,
    iFrameAttributes: {if (widget.allowFullscreen) 'allowfullscreen': ''},
  );
}

Uri? parseUrl(String url) {
  try {
    return Uri.tryParse(web.URL(url, web.document.baseURI).href);
  } on Object {
    return null;
  }
}
