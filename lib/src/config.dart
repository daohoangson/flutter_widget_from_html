import 'package:flutter/material.dart';

class Config {
  final Uri baseUrl;
  final EdgeInsets imagePadding;
  final String listBullet;
  final double listPaddingLeft;
  final EdgeInsets textPadding;

  const Config({
    this.baseUrl,
    this.imagePadding = const EdgeInsets.only(top: 10.0),
    this.listPaddingLeft = 30.0,
    this.listBullet = '•',
    this.textPadding = const EdgeInsets.symmetric(
      horizontal: 10.0,
      vertical: 5.0,
    ),
  });
}
