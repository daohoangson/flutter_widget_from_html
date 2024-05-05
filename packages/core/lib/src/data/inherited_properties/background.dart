part of '../../core_data.dart';

TextStyle _prepareBackground(TextStyle style, InheritedProperties resolved) {
  final property = resolved.get<TextStyleBackground>();
  if (property == null) {
    return style;
  }

  final color = property.value.getValue(resolved);
  if (color == null) {
    return style;
  }

  return style.copyWith(
    background: Paint()..color = color,
    debugLabel: 'fwfh: background-color',
  );
}
