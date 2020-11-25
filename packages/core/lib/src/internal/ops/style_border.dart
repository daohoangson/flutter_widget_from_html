import 'package:flutter/widgets.dart';

import '../../core_data.dart';
import '../../core_helpers.dart';
import '../../core_widget_factory.dart';
import '../core_parser.dart';

const kCssBoxSizing = 'box-sizing';
const kCssBoxSizingContentBox = 'content-box';
const kCssBoxSizingBorderBox = 'border-box';

class StyleBorder {
  final WidgetFactory wf;

  final _borderHasBeenBuiltFor = Expando<bool>();

  StyleBorder(this.wf);

  BuildOp get buildOp => BuildOp(
        onTree: (meta, tree) {
          if (meta.willBuildSubtree) return;
          final border = tryParseBorder(meta);
          if (border == null) return;

          _borderHasBeenBuiltFor[meta] = true;
          final copied = tree.copyWith() as BuildTree;
          final built = wf
              .buildColumnPlaceholder(meta, copied.build())
              ?.wrapWith((context, child) =>
                  _buildBorder(meta, context, child, border));
          if (built == null) return;

          tree.replaceWith(WidgetBit.inline(tree, built));
        },
        onWidgets: (meta, widgets) {
          if (_borderHasBeenBuiltFor[meta] == true) return widgets;
          if (widgets?.isNotEmpty != true) return null;
          final border = tryParseBorder(meta);
          if (border == null) return widgets;

          return listOrNull(wf.buildColumnPlaceholder(meta, widgets)?.wrapWith(
              (context, child) => _buildBorder(meta, context, child, border)));
        },
        onWidgetsIsOptional: true,
        priority: 88888,
      );

  Widget _buildBorder(
    BuildMetadata meta,
    BuildContext context,
    Widget child,
    CssBorder border,
  ) {
    final tsh = meta.tsb().build(context);
    return wf.buildBorder(
      meta,
      child,
      border.getValue(tsh),
      isBorderBox: meta[kCssBoxSizing] == kCssBoxSizingBorderBox,
    );
  }

  static Border getParsedBorder(BuildMetadata meta, BuildContext context) {
    final border = tryParseBorder(meta);
    if (border == null) return null;
    return border.getValue(meta.tsb().build(context));
  }
}
