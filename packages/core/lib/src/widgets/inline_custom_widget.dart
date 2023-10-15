import 'package:flutter/widgets.dart';

class InlineCustomWidget extends StatelessWidget {
  final PlaceholderAlignment alignment;
  final TextBaseline baseline;
  final Widget child;

  const InlineCustomWidget({
    this.alignment = PlaceholderAlignment.baseline,
    this.baseline = TextBaseline.alphabetic,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) => child;
}
