part of '../../core_data.dart';

TextStyle _prepareLineHeight(TextStyle style, InheritedProperties resolved) {
  final property = resolved.get<TextStyleLineHeight>();
  if (property == null) {
    return style;
  }

  final length = property.value;
  if (length == null) {
    final normalValue = resolved.get<NormalLineHeight>()?.value;
    if (normalValue == null) {
      return style;
    } else {
      return style.copyWith(
        debugLabel: 'fwfh: line-height normal',
        height: normalValue,
      );
    }
  }

  final fontSize = style.fontSize;
  if (fontSize == null || fontSize == .0) {
    return style;
  }

  final lengthValue = length.getValue(
    resolved,
    baseValue: fontSize,
    scaleFactor: resolved.get<TextScaleFactor>()?.value,
  );
  if (lengthValue == null) {
    return style;
  }

  return style.copyWith(
    debugLabel: 'fwfh: line-height',
    height: lengthValue / fontSize,
  );
}
