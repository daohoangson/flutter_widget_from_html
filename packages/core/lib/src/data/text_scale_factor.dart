part of '../core_data.dart';

/// The number of font pixels for each logical pixel.
///
/// See [MediaQueryData.textScaleFactor].
@immutable
class TextScaleFactor {
  /// The actual value.
  final double value;

  /// Creates a text scale factor.
  const TextScaleFactor(this.value);
}
