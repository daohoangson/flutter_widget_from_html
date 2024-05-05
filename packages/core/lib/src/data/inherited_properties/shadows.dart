part of '../../core_data.dart';

TextStyle _prepareShadows(TextStyle style, InheritedProperties resolved) {
  final property = resolved.get<TextStyleShadows>();
  if (property == null) {
    return style;
  }

  final shadows = property.value
      .map((shadow) => shadow.getValue(resolved))
      .whereType<Shadow>()
      .toList();
  if (shadows.isEmpty) {
    return style;
  }

  return style.copyWith(
    debugLabel: 'fwfh: text-shadow',
    shadows: shadows,
  );
}
