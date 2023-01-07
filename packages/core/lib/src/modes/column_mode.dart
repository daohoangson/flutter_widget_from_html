part of 'render_mode.dart';

/// A render mode that builds HTML into a [Column] widget.
class ColumnMode extends RenderMode {
  /// Creates a column render mode.
  const ColumnMode();

  @override
  Widget buildBodyWidget(
    WidgetFactory wf,
    BuildContext context,
    Iterable<Widget> children,
  ) =>
      wf.buildColumnWidget(context, children);
}
