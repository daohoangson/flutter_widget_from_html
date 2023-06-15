part of '../core_data.dart';

/// The height of text, as a multiple of the font size.
///
/// Due to limitation in [TextStyle.copyWith] its height cannot be unset.
/// See https://github.com/flutter/flutter/issues/58765.
///
/// Line height is keep tracked as a separate value and
/// will be merged into [HtmlStyle.textStyle] in the final calculation.
@immutable
class LineHeight {
  /// The actual value.
  final double? value;

  /// Creates a line height.
  const LineHeight(this.value);
}
