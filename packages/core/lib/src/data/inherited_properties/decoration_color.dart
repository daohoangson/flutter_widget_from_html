part of '../../core_data.dart';

TextStyle _prepareDecorationColor(
  TextStyle style,
  InheritedProperties resolved,
) {
  final property = resolved.get<TextStyleDecorationColor>();
  if (property == null) {
    return style;
  }

  final decorationColor = property.value.getValue(resolved);
  if (decorationColor == null) {
    return style;
  }

  return style.copyWith(
    debugLabel: 'fwfh: text-decoration-color',
    decorationColor: decorationColor,
  );
}
