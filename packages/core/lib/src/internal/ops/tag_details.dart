part of '../core_ops.dart';

const kAttributeDetailsOpen = 'open';

const kTagDetails = 'details';
const kTagSummary = 'summary';

class TagDetails {
  late final BuildOp op;
  final WidgetFactory wf;

  late final BuildOp _summaryOp;
  static final _summaryDetailsMeta = Expando<BuildMetadata>();
  static final _summaryPlaceholder = Expando<WidgetPlaceholder>();

  TagDetails(this.wf) {
    op = BuildOp(onChild: _onChild, onWidgets: _onWidgets);

    _summaryOp = BuildOp(
      onTree: _onSummaryTree,
      onWidgets: _onSummaryWidgets,
      priority: BuildOp.kPriorityMax,
    );
  }

  void _onChild(BuildMetadata detailsMeta, BuildMetadata childMeta) {
    final e = childMeta.element;
    if (e.parent != detailsMeta.element) {
      return;
    }
    if (e.localName != kTagSummary) {
      return;
    }

    _summaryDetailsMeta[e] = detailsMeta;
    childMeta.register(_summaryOp);
  }

  void _onSummaryTree(BuildMetadata summaryMeta, BuildTree tree) {
    final children = tree.directChildren;
    if (children.isEmpty) {
      return;
    }

    final first = children.first;
    final marker = WidgetBit.inline(
      first.parent!,
      WidgetPlaceholder(summaryMeta).wrapWith((context, child) {
        final tsh = summaryMeta.tsb.build(context);
        return HtmlDetailsMarker(style: tsh.style);
      }),
    );
    marker.insertBefore(first);
  }

  Iterable<Widget>? _onSummaryWidgets(
    BuildMetadata summaryMeta,
    Iterable<WidgetPlaceholder> widgets,
  ) {
    final detailsMeta = _summaryDetailsMeta[summaryMeta.element];
    if (detailsMeta == null) {
      return widgets;
    }

    final existingSummary = _summaryPlaceholder[detailsMeta];
    if (existingSummary != null) {
      return widgets;
    }

    final placeholder = wf.buildColumnPlaceholder(summaryMeta, widgets);
    if (placeholder == null) {
      return widgets;
    }

    _summaryPlaceholder[detailsMeta] = placeholder;
    return const [];
  }

  Iterable<Widget>? _onWidgets(
    BuildMetadata detailsMeta,
    Iterable<WidgetPlaceholder> widgets,
  ) {
    final attrs = detailsMeta.element.attributes;
    final open = attrs.containsKey(kAttributeDetailsOpen);
    return listOrNull(
      wf.buildColumnPlaceholder(detailsMeta, widgets)?.wrapWith(
        (context, child) {
          final summary = _summaryPlaceholder[detailsMeta];
          final tsh = detailsMeta.tsb.build(context);

          return HtmlDetails(
            open: open,
            child: wf.buildColumnWidget(
              context,
              [
                HtmlSummary(style: tsh.style, child: summary),
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
