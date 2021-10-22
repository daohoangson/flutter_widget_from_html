part of 'render_mode.dart';

class SliverListRenderMode extends RenderMode {
  const SliverListRenderMode();

  @override
  Widget buildBodyWidget(
    WidgetFactory wf,
    BuildContext context,
    List<Widget> children,
  ) {
    // ignore: invalid_use_of_protected_member
    final anchorRegistry = wf.anchorRegistry;
    anchorRegistry.prepareIndexByAnchor(children);

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (c, i) => anchorRegistry.buildBodyItem(c, i, children[i]),
        addAutomaticKeepAlives: false,
        addSemanticIndexes: false,
        childCount: children.length,
      ),
    );
  }
}
