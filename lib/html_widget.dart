import 'package:flutter/material.dart';

import 'html_parser.dart';

class HtmlWidget extends StatelessWidget {
  final String baseUrl;
  final Color colorHyperlink;
  final String html;
  final List<double> sizeHeadings;

  HtmlWidget({
    this.baseUrl, 
    this.colorHyperlink = const Color(0xFF1965B5),
    @required this.html,
    this.sizeHeadings = const [32.0, 24.0, 20.8, 16.0, 12.8, 11.2],
    Key key
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    final p = HtmlParser(
      baseUrl: baseUrl,
      context: context,
      colorHyperlink: colorHyperlink,
      sizeHeadings: sizeHeadings,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: p.parse(html),
    );
  }
}
