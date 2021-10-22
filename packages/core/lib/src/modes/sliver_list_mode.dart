part of 'render_mode.dart';

/// A render mode that builds HTML into a [SliverList] widget.
class SliverListMode extends RenderMode {
  /// See [SliverChildBuilderDelegate.addAutomaticKeepAlives].
  ///
  /// Default: `false`.
  final bool addAutomaticKeepAlives;

  /// See [SliverChildBuilderDelegate.addRepaintBoundaries].
  ///
  /// Default: `true`.
  final bool addRepaintBoundaries;

  /// See [SliverChildBuilderDelegate.addSemanticIndexes].
  ///
  /// Default: `false`.
  final bool addSemanticIndexes;

  /// Creates a sliver list render mode.
  const SliverListMode({
    this.addAutomaticKeepAlives = false,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = false,
  });

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
        addAutomaticKeepAlives: addAutomaticKeepAlives,
        addRepaintBoundaries: addRepaintBoundaries,
        addSemanticIndexes: addSemanticIndexes,
        childCount: children.length,
      ),
    );
  }
}
