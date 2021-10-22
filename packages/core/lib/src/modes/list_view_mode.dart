part of 'render_mode.dart';

class ListViewRenderMode extends RenderMode {
  const ListViewRenderMode();

  @override
  Widget buildBodyWidget(
    WidgetFactory wf,
    BuildContext context,
    List<Widget> children,
  ) {
    // ignore: invalid_use_of_protected_member
    final anchorRegistry = wf.anchorRegistry;
    anchorRegistry.prepareIndexByAnchor(children);

    return ListView.builder(
      addAutomaticKeepAlives: false,
      addSemanticIndexes: false,
      itemBuilder: (c, i) => anchorRegistry.buildBodyItem(c, i, children[i]),
      itemCount: children.length,
    );
  }
}
