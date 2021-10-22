part of 'render_mode.dart';

class ColumnRenderMode extends RenderMode {
  const ColumnRenderMode();

  @override
  Widget buildBodyWidget(
    WidgetFactory wf,
    BuildContext context,
    List<Widget> children,
  ) =>
      wf.buildColumnWidget(context, children);
}
