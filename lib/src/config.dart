import 'package:flutter/material.dart';

class Config {
  final Uri baseUrl;
  final EdgeInsets imagePadding;
  final EdgeInsets textPadding;

  const Config({
    this.baseUrl,
    this.imagePadding = const EdgeInsets.only(top: 10.0),
    this.textPadding = const EdgeInsets.symmetric(
      horizontal: 10.0,
      vertical: 5.0,
    ),
  });
}
