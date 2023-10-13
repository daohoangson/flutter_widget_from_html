// TODO: remove ignore for file when our minimum core version >= 1.0
// ignore_for_file: deprecated_member_use

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import 'internal.dart';
import 'web_view/web_view.dart';

/// A mixin that can build [WebView] for IFRAME.
mixin WebViewFactory on WidgetFactory {
  BuildOp? _tagIframe;

  /// Controls whether IFRAME is rendered as [WebView].
  ///
  /// Default: `true`.
  bool get webView => true;

  /// {@macro web_view.debuggingEnabled}
  bool get webViewDebuggingEnabled => false;

  /// {@macro web_view.js}
  bool get webViewJs => true;

  /// {@macro web_view.mediaPlaybackAlwaysAllow}
  bool get webViewMediaPlaybackAlwaysAllow => false;

  /// {@macro web_view.onAndroidHideCustomWidget}
  void Function()? get webViewOnAndroidHideCustomWidget => null;

  /// {@macro web_view.onAndroidShowCustomWidget}
  void Function(Widget widget)? get webViewOnAndroidShowCustomWidget => null;

  /// {@macro web_view.userAgent}
  String? get webViewUserAgent => null;

  /// Builds [WebView].
  ///
  /// JavaScript is only enabled if [webViewJs] is turned on
  /// AND sandbox restrictions are unset (no `sandbox` attribute)
  /// or `allow-scripts` is explicitly allowed.
  Widget? buildWebView(
    BuildMetadata meta,
    String url, {
    double? height,
    Iterable<String>? sandbox,
    double? width,
  }) {
    if (!webView) {
      return buildWebViewLinkOnly(meta, url);
    }

    final dimensOk = height != null && height > 0 && width != null && width > 0;
    final js = webViewJs &&
        (sandbox == null ||
            sandbox.contains(kAttributeIframeSandboxAllowScripts));
    return WebView(
      url,
      aspectRatio: dimensOk ? width / height : 16 / 9,
      autoResize: !dimensOk && js,
      debuggingEnabled: webViewDebuggingEnabled,
      interceptNavigationRequest: (newUrl) {
        if (newUrl == url) {
          return false;
        }

        gestureTapCallback(newUrl)?.call();
        return true;
      },
      js: js,
      mediaPlaybackAlwaysAllow: webViewMediaPlaybackAlwaysAllow,
      onAndroidHideCustomWidget: webViewOnAndroidHideCustomWidget,
      onAndroidShowCustomWidget: webViewOnAndroidShowCustomWidget,
      userAgent: webViewUserAgent,
    );
  }

  /// Builds fallback link when [HtmlWidget.webView] is disabled.
  Widget? buildWebViewLinkOnly(BuildMetadata meta, String url) =>
      GestureDetector(
        onTap: gestureTapCallback(url),
        child: Text(url),
      );

  @override
  void parse(BuildMetadata meta) {
    switch (meta.element.localName) {
      case kTagIframe:
        meta.register(
          _tagIframe ??= BuildOp(
            // TODO: set debugLabel when our minimum core version >= 1.0
            onWidgets: (meta, widgets) {
              if (defaultTargetPlatform != TargetPlatform.android &&
                  defaultTargetPlatform != TargetPlatform.iOS &&
                  !kIsWeb) {
                // Android & iOS are the webview_flutter's supported platforms
                // Flutter web support is implemented by this package
                // https://pub.dev/packages/webview_flutter/versions/2.0.12
                return widgets;
              }

              final a = meta.element.attributes;
              final src = urlFull(a[kAttributeIframeSrc] ?? '');
              if (src == null) {
                return widgets;
              }

              final height = tryParseDoubleFromMap(a, kAttributeIframeHeight);
              final width = tryParseDoubleFromMap(a, kAttributeIframeWidth);
              final sandbox = a[kAttributeIframeSandbox]?.split(RegExp(r'\s+'));
              final built = buildWebView(
                meta,
                src,
                height: height,
                sandbox: sandbox,
                width: width,
              );
              return listOrNull(built) ?? widgets;
            },
          ),
        );
        break;
    }
    return super.parse(meta);
  }
}
