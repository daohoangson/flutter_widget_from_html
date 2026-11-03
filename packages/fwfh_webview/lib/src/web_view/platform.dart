import 'package:flutter/foundation.dart';
import 'package:webview_all/webview_all.dart';
import 'package:webview_all_wkwebview/webview_all_wkwebview.dart';

import 'web_view.dart';

PlatformWebViewControllerCreationParams controllerCreationParams(
  WebView widget,
) {
  if (defaultTargetPlatform == TargetPlatform.iOS) {
    return WebKitWebViewControllerCreationParams(
      allowsInlineMediaPlayback: true,
      mediaTypesRequiringUserAction:
          widget.mediaPlaybackAlwaysAllow ? {} : {...PlaybackMediaTypes.values},
    );
  }

  return const PlatformWebViewControllerCreationParams();
}

Uri? parseUrl(String url) => Uri.tryParse(url);
