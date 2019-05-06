part of '../core_helpers.dart';

class Wrapable extends StatelessWidget {
  final WidgetFactory wf;
  final Iterable<Widget> widgets;

  Wrapable(this.wf, this.widgets);

  @override
  Widget build(BuildContext context) => wf.buildWrap(widgets.toList());

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.debug}) =>
      '[Wrapable:$widgets]';
}
