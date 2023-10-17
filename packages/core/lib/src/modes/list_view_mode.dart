part of 'render_mode.dart';

/// A render mode that builds HTML into a [ListView] widget.
class ListViewMode extends RenderMode {
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

  /// See [ScrollView.clipBehavior].
  ///
  /// Default: [Clip.hardEdge].
  final Clip clipBehavior;

  /// See [ScrollView.controller].
  final ScrollController? controller;

  /// See [ScrollView.dragStartBehavior].
  ///
  /// Default: [DragStartBehavior.start].
  final DragStartBehavior dragStartBehavior;

  /// See [ScrollView.keyboardDismissBehavior].
  ///
  /// Default: [ScrollViewKeyboardDismissBehavior.manual].
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  /// See [BoxScrollView.padding].
  final EdgeInsetsGeometry? padding;

  /// See [ScrollView.primary].
  final bool? primary;

  /// See [ScrollView.physics].
  final ScrollPhysics? physics;

  /// See [ScrollView.restorationId].
  final String? restorationId;

  /// See [ScrollView.shrinkWrap].
  final bool shrinkWrap;

  /// Creates a list view render mode.
  const ListViewMode({
    this.addAutomaticKeepAlives = false,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = false,
    this.clipBehavior = Clip.hardEdge,
    this.controller,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.padding,
    this.primary,
    this.physics,
    this.restorationId,
    this.shrinkWrap = false,
  });

  @override
  Widget buildBodyWidget(
    WidgetFactory wf,
    BuildContext context,
    List<Widget> children,
  ) {
    wf.prepareAnchorIndexByAnchor(children);

    return ListView.builder(
      addAutomaticKeepAlives: addAutomaticKeepAlives,
      addRepaintBoundaries: addRepaintBoundaries,
      addSemanticIndexes: addSemanticIndexes,
      clipBehavior: clipBehavior,
      controller: controller,
      dragStartBehavior: dragStartBehavior,
      itemBuilder: (c, i) => wf.buildAnchorBodyItem(c, i, children[i]),
      itemCount: children.length,
      keyboardDismissBehavior: keyboardDismissBehavior,
      padding: padding,
      primary: primary,
      physics: physics,
      restorationId: restorationId,
      shrinkWrap: shrinkWrap,
    );
  }
}
