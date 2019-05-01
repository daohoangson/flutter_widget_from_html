import 'package:flutter/widgets.dart';

import 'data_classes.dart';

abstract class Config {
  Uri get baseUrl;
  EdgeInsets get bodyPadding;
  NodeMetadataCollector get builderCallback;
  Color get hyperlinkColor;
  EdgeInsets get tableCellPadding;
  EdgeInsets get tablePadding;
  EdgeInsets get textPadding;
}
