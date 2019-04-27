import 'package:flutter/widgets.dart';

abstract class Config {
  Uri get baseUrl;
  EdgeInsets get bodyPadding;
  EdgeInsets get tableCellPadding;
  EdgeInsets get tablePadding;
  EdgeInsets get textPadding;
}
