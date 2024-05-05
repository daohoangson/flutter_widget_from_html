part of '../core_data.dart';

/// The default height of text.
///
/// See [TextStyle.height].
@immutable
class NormalLineHeight {
  final double? value;

  const NormalLineHeight(this.value);
}

/// The background of text.
///
/// See [TextStyle.background].
@immutable
class TextStyleBackground {
  final CssColor value;

  const TextStyleBackground(this.value);
}

/// The height of text.
///
/// See [TextStyle.height].
@immutable
class TextStyleLineHeight {
  final CssLength? value;

  const TextStyleLineHeight([this.value]);
}
