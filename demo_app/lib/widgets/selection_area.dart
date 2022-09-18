import 'package:demo_app/widgets/popup_menu.dart';
import 'package:flutter/material.dart';

class ContextualSelectionArea extends StatelessWidget {
  final Widget child;

  const ContextualSelectionArea({
    @required this.child,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget built = child;

    if (context.isSelectable) {
      built = SelectionArea(child: built);
    }

    return built;
  }
}
