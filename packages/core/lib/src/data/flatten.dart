part of '../core_data.dart';

abstract class FlattenState {
  GestureRecognizer? get recognizer;

  bool get swallowWhitespace;

  void addInlineSpan(InlineSpan value);

  void addSpanBuilder(SpanBuilder value);

  void addText(String value);

  void addWhitespace(String value, {required bool shouldBeSwallowed});

  void addWidget(Widget value);

  void setRecognizer(GestureRecognizer? value, {bool autoDispose = true});
}

typedef SpanBuilder = InlineSpan? Function(
  BuildContext,
  CssWhitespace whitespace, {
  bool? isLast,
});
