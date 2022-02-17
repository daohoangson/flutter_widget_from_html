part of '../core_ops.dart';

const kAttributeDetailsOpen = 'open';

const kTagDetails = 'details';
const kTagSummary = 'summary';

class TagDetails {
  final WidgetFactory wf;

  late final BuildOp _summaryOp;
  WidgetPlaceholder? _summary;

  TagDetails(this.wf) {
    _summaryOp = BuildOp(
      onTree: (tree) {
        if (tree.isEmpty) {
          return;
        }

        final marker = WidgetBit.inline(
          tree,
          WidgetPlaceholder(
            builder: (context, child) {
              final style = tree.styleBuilder.build(context);
              return HtmlDetailsMarker(style: style.textStyle);
            },
            localName: kTagDetails,
          ),
        );
        tree.prepend(marker);
      },
      onWidgets: (tree, widgets) {
        if (_summary != null) {
          return widgets;
        }

        _summary = wf.buildColumnPlaceholder(tree, widgets);
        if (_summary == null) {
          return widgets;
        }

        return const [];
      },
      priority: BuildOp.kPriorityMax,
    );
  }

  BuildOp get buildOp => BuildOp(
        onChild: (tree, subTree) {
          final e = subTree.element;
          if (e.parent != tree.element) {
            return;
          }
          if (e.localName != kTagSummary) {
            return;
          }

          subTree.register(_summaryOp);
        },
        onWidgets: (tree, widgets) {
          final attrs = tree.element.attributes;
          final open = attrs.containsKey(kAttributeDetailsOpen);
          final placeholder =
              wf.buildColumnPlaceholder(tree, widgets)?.wrapWith(
            (context, child) {
              final style = tree.styleBuilder.build(context);

              return HtmlDetails(
                open: open,
                child: wf.buildColumnWidget(
                  context,
                  [
                    HtmlSummary(style: style.textStyle, child: _summary),
                    HtmlDetailsContents(child: child),
                  ],
                  dir: style.getDependency(),
                ),
              );
            },
          );

          return listOrNull(placeholder) ?? widgets;
        },
      );
}
