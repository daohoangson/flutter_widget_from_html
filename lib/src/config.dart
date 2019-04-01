import 'package:flutter/material.dart';

class Config {
  final Uri baseUrl;
  final EdgeInsets imagePadding;
  final EdgeInsets textPadding;
  final bool webView;
  final bool webViewJs;
  final EdgeInsets webViewPadding;

  const Config({
    this.baseUrl,
    this.imagePadding = const EdgeInsets.only(top: 5.0, bottom: 5.0),
    this.textPadding = const EdgeInsets.symmetric(
      horizontal: 10.0,
      vertical: 5.0,
    ),
    this.webView = false,
    this.webViewJs = true,
    this.webViewPadding = const EdgeInsets.only(top: 5.0, bottom: 5.0),
  });
}
