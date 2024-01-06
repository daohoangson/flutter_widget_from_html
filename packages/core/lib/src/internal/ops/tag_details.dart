part of '../core_ops.dart';

const kAttributeDetailsOpen = 'open';

const kTagDetails = 'details';
const kTagSummary = 'summary';

// use middle alignment as an early optimization
// baseline alignment may cause issue with getDrySize, getMinIntrinsicWidth, etc.
const _markerMarkerAlignment = PlaceholderAlignment.middle;

class TagDetails {
  final WidgetFactory wf;

  TagDetails(this.wf);

  BuildOp get buildOp => BuildOp(
        alwaysRenderBlock: true,
        debugLabel: kTagDetails,
        onRenderedChildren: (tree, children) {
          Widget? summaryOrNull;
          final rest = <WidgetPlaceholder>[];
          for (final child in children) {
            if (summaryOrNull == null && child.isSummary == true) {
              summaryOrNull = child;
            } else {
              rest.add(child);
            }
          }
          final column = wf.buildColumnPlaceholder(tree, rest);
          if (column == null) {
            return null;
          }

          final attrs = tree.element.attributes;
          final open = attrs.containsKey(kAttributeDetailsOpen);

          return column
            ..wrapWith((context, child) {
              final resolved = tree.inheritanceResolvers.resolve(context);
              final textStyle = resolved.prepareTextStyle();
              final summary = summaryOrNull ??
                  wf.buildText(
                    tree,
                    resolved,
                    TextSpan(
                      children: [
                        WidgetSpan(
                          alignment: _markerMarkerAlignment,
                          child: HtmlDetailsMarker(style: textStyle),
                        ),
                        // TODO: i18n
                        TextSpan(text: 'Details', style: textStyle),
                      ],
                    ),
                  );

              return HtmlDetails(
                open: open,
                child: wf.buildColumnWidget(
                  context,
                  [
                    HtmlSummary(style: textStyle, child: summary),
                    HtmlDetailsContents(child: child),
                  ],
                  dir: resolved.directionOrLtr,
                ),
              );
            });
        },
        onVisitChild: (detailsTree, subTree) {
          final e = subTree.element;
          if (e.parent != detailsTree.element) {
            return;
          }
          if (e.localName != kTagSummary) {
            return;
          }

          subTree.register(
            const BuildOp.v2(
              alwaysRenderBlock: true,
              debugLabel: kTagSummary,
              onParsed: _onSummaryParsed,
              onRenderedBlock: _markBlockIsSummary,
              priority: Late.tagSummary,
            ),
          );
        },
        priority: Priority.tagDetails,
      );

  static BuildTree _onSummaryParsed(BuildTree summaryTree) {
    if (summaryTree.isEmpty) {
      return summaryTree;
    }

    final marker = WidgetBit.inline(
      summaryTree,
      WidgetPlaceholder(
        builder: (context, _) {
          final resolved = summaryTree.inheritanceResolvers.resolve(context);
          return HtmlDetailsMarker(style: resolved.prepareTextStyle());
        },
        debugLabel: '$kTagSummary--inlineMarker',
      ),
      alignment: _markerMarkerAlignment,
    );

    return summaryTree..prepend(marker);
  }

  static void _markBlockIsSummary(BuildTree _, Widget block) =>
      block.isSummary = true;
}

extension on Widget {
  static final _isSummary = Expando<bool>();

  bool get isSummary => _isSummary[this] ?? false;

  set isSummary(bool value) => _isSummary[this] = value;
}
