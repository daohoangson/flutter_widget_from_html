part of '../core_data.dart';

/// The height of text.
///
/// See [TextStyle.height].
@immutable
class CssLineHeight {
  final CssLength? value;

  const CssLineHeight([this.value]);
}

/// The default height of text.
///
/// See [TextStyle.height].
@immutable
class NormalLineHeight {
  final double? value;

  const NormalLineHeight(this.value);
}
