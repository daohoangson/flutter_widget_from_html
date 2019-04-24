part of '../core_wf.dart';

class TagHr {
  final WidgetFactory wf;

  TagHr(this.wf);

  BuildOp get buildOp => BuildOp(
        getInlineStyles: (e) => const [kCssMarginBottom, '1em'],
        onWidgets: (meta, widgets) => DecoratedBox(
              decoration: BoxDecoration(
                color: Theme.of(wf.context).dividerColor,
              ),
              child: SizedBox(height: 1),
            ),
      );
}
