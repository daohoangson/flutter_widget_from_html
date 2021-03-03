import 'package:flutter/widgets.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import 'web_view/web_view.dart';
import 'internal.dart';

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
    BuildMetadata meta,
    String url, {
    double? height,
    Iterable<String>? sandbox,
    double? width,
  }) {
    if (!webView) return buildWebViewLinkOnly(meta, url);

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
        if (newUrl == url) return false;

        gestureTapCallback(newUrl)?.call();
        return true;
      },
      js: js,
      mediaPlaybackAlwaysAllow: webViewMediaPlaybackAlwaysAllow,
      userAgent: webViewUserAgent,
    );
  }

  /// Builds fallback link when [HtmlWidget.webView] is disabled.
  Widget? buildWebViewLinkOnly(BuildMetadata meta, String url) =>
      GestureDetector(
        child: Text(url),
        onTap: gestureTapCallback(url),
      );

  @override
  void parse(BuildMetadata meta) {
    switch (meta.element.localName) {
      case kTagIframe:
        final op = _tagIframe ??= BuildOp(onWidgets: (meta, _) {
          final attrs = meta.element.attributes;
          final src = urlFull(attrs[kAttributeIframeSrc] ?? '');
          if (src == null) return null;

          return listOrNull(buildWebView(
            meta,
            src,
            height: tryParseDoubleFromMap(attrs, kAttributeIframeHeight),
            sandbox: attrs[kAttributeIframeSandbox]?.split(RegExp(r'\s+')),
            width: tryParseDoubleFromMap(attrs, kAttributeIframeWidth),
          ));
        });
        meta.register(op);
        break;
    }
    return super.parse(meta);
  }
}
