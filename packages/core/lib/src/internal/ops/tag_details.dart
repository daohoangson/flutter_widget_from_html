part of '../core_ops.dart';

const kAttributeDetailsOpen = 'open';

const kTagDetails = 'details';
const kTagSummary = 'summary';

class TagDetails {
  final BuildMetadata detailsMeta;
  late final BuildOp op;
  final WidgetFactory wf;

  late final BuildOp _summaryOp;
  WidgetPlaceholder? _summary;

  TagDetails(this.wf, this.detailsMeta) {
    op = BuildOp(onChild: onChild, onWidgets: onWidgets);

    _summaryOp = BuildOp(
      onTree: (meta, tree) {
        final children = tree.directChildren;
        if (children.isEmpty) {
          return;
        }

        final first = children.first;
        final marker = WidgetBit.inline(
          first.parent!,
          WidgetPlaceholder(
            builder: (context, child) {
              final tsh = meta.tsb.build(context);
              return HtmlDetailsMarker(style: tsh.styleWithHeight);
            },
            localName: kTagDetails,
          ),
        );
        marker.insertBefore(first);
      },
      onWidgets: (meta, widgets) {
        if (_summary != null) {
          return widgets;
        }

        _summary = wf.buildColumnPlaceholder(meta, widgets);
        if (_summary == null) {
          return widgets;
        }

        return const [];
      },
      priority: BuildOp.kPriorityMax,
    );
  }

  void onChild(BuildMetadata childMeta) {
    final e = childMeta.element;
    if (e.parent != detailsMeta.element) {
      return;
    }
    if (e.localName != kTagSummary) {
      return;
    }

    childMeta.register(_summaryOp);
  }

  Iterable<Widget>? onWidgets(
    BuildMetadata _,
    Iterable<WidgetPlaceholder> widgets,
  ) {
    final attrs = detailsMeta.element.attributes;
    final open = attrs.containsKey(kAttributeDetailsOpen);
    return listOrNull(
      wf.buildColumnPlaceholder(detailsMeta, widgets)?.wrapWith(
        (context, child) {
          final tsh = detailsMeta.tsb.build(context);

          return HtmlDetails(
            open: open,
            child: wf.buildColumnWidget(
              context,
              [
                HtmlSummary(style: tsh.styleWithHeight, child: _summary),
                HtmlDetailsContents(child: child),
              ],
              dir: tsh.getDependency(),
            ),
          );
        },
      ),
    );
  }
}
