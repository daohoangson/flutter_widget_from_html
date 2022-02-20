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

  /// {@macro web_view.userAgent}
  String? get webViewUserAgent => null;

  /// Builds [WebView].
  ///
  /// JavaScript is only enabled if [webViewJs] is turned on
  /// AND sandbox restrictions are unset (no `sandbox` attribute)
  /// or `allow-scripts` is explicitly allowed.
  Widget? buildWebView(
    BuildTree tree,
    String url, {
    double? height,
    Iterable<String>? sandbox,
    double? width,
  }) {
    if (!webView) {
      return buildWebViewLinkOnly(tree, url);
    }

    final dimensOk = height != null && height > 0 && width != null && width > 0;
    final js = webViewJs &&
        (sandbox == null ||
            sandbox.contains(kAttributeIframeSandboxAllowScripts));
    return WebView(
      url,
      aspectRatio: dimensOk ? width! / height! : 16 / 9,
      autoResize: !dimensOk && js,
      debuggingEnabled: webViewDebuggingEnabled,
      interceptNavigationRequest: (newUrl) {
        if (newUrl == url) {
          return false;
        }

        onTapUrl(newUrl);
        return true;
      },
      js: js,
      mediaPlaybackAlwaysAllow: webViewMediaPlaybackAlwaysAllow,
      userAgent: webViewUserAgent,
    );
  }

  /// Builds fallback link when [HtmlWidget.webView] is disabled.
  Widget? buildWebViewLinkOnly(BuildTree tree, String url) => GestureDetector(
        onTap: () => onTapUrl(url),
        child: Text(url),
      );

  @override
  void parse(BuildTree tree) {
    switch (tree.element.localName) {
      case kTagIframe:
        tree.register(
          _tagIframe ??= BuildOp(
            debugLabel: kTagIframe,
            onBuilt: (tree, _) {
              if (defaultTargetPlatform != TargetPlatform.android &&
                  defaultTargetPlatform != TargetPlatform.iOS &&
                  !kIsWeb) {
                // Android & iOS are the webview_flutter's supported platforms
                // Flutter web support is implemented by this package
                // https://pub.dev/packages/webview_flutter/versions/2.0.12
                return null;
              }

              final a = tree.element.attributes;
              final src = urlFull(a[kAttributeIframeSrc] ?? '');
              if (src == null) {
                return null;
              }

              final height = tryParseDoubleFromMap(a, kAttributeIframeHeight);
              final width = tryParseDoubleFromMap(a, kAttributeIframeWidth);
              final sandbox = a[kAttributeIframeSandbox]?.split(RegExp(r'\s+'));

              return buildWebView(
                tree,
                src,
                height: height,
                sandbox: sandbox,
                width: width,
              );
            },
          ),
        );
        break;
    }
    return super.parse(tree);
  }
}
