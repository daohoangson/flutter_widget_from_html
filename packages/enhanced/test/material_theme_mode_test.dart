import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:material_ui/material_ui.dart' as material_ui;

void main() {
  testWidgets('enhanced HtmlWidget forwards materialThemeMode', (tester) async {
    const primary = Color(0xFF123456);
    final theme = material_ui.ThemeData();
    await tester.pumpWidget(
      material_ui.MaterialApp(
        theme: theme.copyWith(
          colorScheme: theme.colorScheme.copyWith(primary: primary),
        ),
        home: const material_ui.Scaffold(
          body: HtmlWidget(
            '<a href="/">Link</a>',
            materialThemeMode: MaterialThemeMode.materialUi,
          ),
        ),
      ),
    );

    final richText = tester.widget<RichText>(find.byType(RichText));
    expect(_findColor(richText.text, 'Link'), primary);
  });
}

Color? _findColor(InlineSpan span, String text) {
  if (span is! TextSpan) {
    return null;
  }
  if (span.text == text) {
    return span.style?.color;
  }
  for (final child in span.children ?? const <InlineSpan>[]) {
    final color = _findColor(child, text);
    if (color != null) {
      return color;
    }
  }
  return null;
}
