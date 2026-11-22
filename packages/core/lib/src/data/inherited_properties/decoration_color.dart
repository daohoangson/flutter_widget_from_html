part of '../../core_data.dart';

TextStyle _prepareDecorationColor(
  TextStyle style,
  InheritedProperties resolved,
) {
  final property = resolved.get<TextStyleDecorationColor>();
  if (property == null &&
      (style.decoration ?? TextDecoration.none) == TextDecoration.none) {
    return style;
  }

  // the initial value is currentcolor, not the theme decorationColor
  final value = property?.value ?? CssColor.current();
  final decorationColor = value.getValue(resolved);
  if (decorationColor == null) {
    return style;
  }

  return style.copyWith(
    debugLabel: 'fwfh: text-decoration-color',
    decorationColor: decorationColor,
  );
}
