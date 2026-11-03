import 'package:flutter/foundation.dart';
import 'package:webview_all/webview_all.dart';
import 'package:webview_all_linux/webview_all_linux.dart';
import 'package:webview_all_windows/webview_all_windows.dart';
import 'package:webview_all_wkwebview/webview_all_wkwebview.dart';

import 'web_view.dart';

PlatformWebViewControllerCreationParams controllerCreationParams(
  WebView widget,
) {
  if (defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS) {
    return WebKitWebViewControllerCreationParams(
      allowsInlineMediaPlayback: true,
      mediaTypesRequiringUserAction:
          widget.mediaPlaybackAlwaysAllow ? {} : {...PlaybackMediaTypes.values},
    );
  }

  if (defaultTargetPlatform == TargetPlatform.linux) {
    return LinuxWebViewControllerCreationParams(
      developerExtrasEnabled: widget.debuggingEnabled,
      mediaPlaybackRequiresUserGesture: !widget.mediaPlaybackAlwaysAllow,
      mediaPlaybackAllowsInline: true,
    );
  }

  if (defaultTargetPlatform == TargetPlatform.windows) {
    return WindowsWebViewControllerCreationParams(
      devToolsEnabled: widget.debuggingEnabled,
    );
  }

  return const PlatformWebViewControllerCreationParams();
}

Uri? parseUrl(String url) => Uri.tryParse(url);
