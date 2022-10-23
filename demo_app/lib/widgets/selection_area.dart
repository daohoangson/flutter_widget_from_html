import 'package:demo_app/widgets/popup_menu.dart';
import 'package:flutter/material.dart';

class SelectionAreaScaffold extends StatelessWidget {
  final PreferredSizeWidget appBar;
  final Widget body;

  const SelectionAreaScaffold({
    @required this.appBar,
    @required this.body,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget built = Scaffold(
      appBar: appBar,
      body: body,
    );

    if (context.isSelectable) {
      built = SelectionArea(child: built);
    }

    return built;
  }
}
