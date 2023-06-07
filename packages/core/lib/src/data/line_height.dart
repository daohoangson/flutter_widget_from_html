part of '../core_data.dart';

/// The height of text, as a multiple of the font size.
@immutable
class LineHeight {
  /// The actual value.
  final double? value;

  /// Creates a line height.
  const LineHeight(this.value);
}
