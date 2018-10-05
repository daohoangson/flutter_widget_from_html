import 'package:flutter/widgets.dart';

class Config {
  final Uri baseUrl;
  final Color colorHyperlink;
  final List<double> sizeHeadings;

  const Config({
    this.baseUrl, 
    this.colorHyperlink = const Color(0xFF1965B5),
    this.sizeHeadings = const [32.0, 24.0, 20.8, 16.0, 12.8, 11.2],
  });
}