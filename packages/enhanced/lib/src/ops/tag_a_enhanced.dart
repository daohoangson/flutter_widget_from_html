part of '../widget_factory.dart';

class _TagAEnhanced {
  static TextStyleHtml setAccentColor(TextStyleHtml p, _) => p.copyWith(
      style: p.style.copyWith(color: p.deps.getValue<ThemeData>().accentColor));
}
