part of '../core_wf.dart';

class TagHr {
  final WidgetFactory wf;

  TagHr(this.wf);

  BuildOp get buildOp => BuildOp(
        getInlineStyles: (e) => const [kCssMarginBottom, '1em'],
        onWidgets: (meta, widgets) => wf.buildDivider(),
      );
}
