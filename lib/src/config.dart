import 'package:flutter/material.dart';

class Config {
  final Uri baseUrl;
  final EdgeInsetsGeometry imagePadding;
  final EdgeInsetsGeometry listPadding;
  final EdgeInsetsGeometry textPadding;

  const Config({
    this.baseUrl,
    this.imagePadding = const EdgeInsets.only(top: 10.0),
    this.listPadding = const EdgeInsets.only(left: 20.0),
    this.textPadding = const EdgeInsets.symmetric(
      horizontal: 10.0,
      vertical: 5.0,
    ),
  });
}
