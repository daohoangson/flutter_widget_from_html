import 'package:flutter/widgets.dart';

import 'core_helpers.dart';
import 'data_classes.dart';

class HtmlConfig {
  /// The base url to resolve links and image urls.
  final Uri baseUrl;

  /// The amount of space by which to inset the built widget tree.
  final EdgeInsets bodyPadding;

  /// The callback to render custom elements.
  ///
  /// See also:
  ///
  ///  * [core.Builder]
  final NodeMetadataCollector builderCallback;

  /// The text color for link elements.
  final Color hyperlinkColor;

  /// The callback when user taps a link.
  final OnTapUrl onTapUrl;

  /// The amount of space by which to inset the table cell's contents.
  final EdgeInsets tableCellPadding;

  /// The default styling for text elements.
  final TextStyle textStyle;

  HtmlConfig({
    this.baseUrl,
    this.bodyPadding,
    this.builderCallback,
    this.hyperlinkColor,
    this.onTapUrl,
    this.tableCellPadding,
    this.textStyle,
  });
}
