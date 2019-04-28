import 'package:flutter/widgets.dart';

abstract class Config {
  Uri get baseUrl;
  EdgeInsets get bodyPadding;
  Color get hyperlinkColor;
  EdgeInsets get tableCellPadding;
  EdgeInsets get tablePadding;
  EdgeInsets get textPadding;
}
