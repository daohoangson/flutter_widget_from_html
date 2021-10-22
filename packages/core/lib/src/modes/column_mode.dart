part of 'render_mode.dart';

class ColumnMode extends RenderMode {
  const ColumnMode();

  @override
  Widget buildBodyWidget(
    WidgetFactory wf,
    BuildContext context,
    List<Widget> children,
  ) =>
      wf.buildColumnWidget(context, children);
}
