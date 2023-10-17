import 'package:flutter/widgets.dart';

/// A custom inline [Widget].
class InlineCustomWidget extends StatelessWidget {
  /// How the placeholder aligns vertically with the text.
  ///
  /// See [ui.PlaceholderAlignment] for details on each mode.
  final PlaceholderAlignment alignment;

  /// The [TextBaseline] to align against when using [ui.PlaceholderAlignment.baseline],
  /// [ui.PlaceholderAlignment.aboveBaseline], and [ui.PlaceholderAlignment.belowBaseline].
  ///
  /// This is ignored when using other alignment modes.
  final TextBaseline baseline;

  /// The custom [Widget].
  final Widget child;

  /// Creates a custom inline [Widget].
  const InlineCustomWidget({
    this.alignment = PlaceholderAlignment.baseline,
    this.baseline = TextBaseline.alphabetic,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) => child;
}
