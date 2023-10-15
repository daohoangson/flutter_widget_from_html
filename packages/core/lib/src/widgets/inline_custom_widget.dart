import 'package:flutter/widgets.dart';

class InlineCustomWidget extends StatelessWidget {
  final Widget child;

  const InlineCustomWidget({required this.child, super.key});

  @override
  Widget build(BuildContext context) => child;
}
