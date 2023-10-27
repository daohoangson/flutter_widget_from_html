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
        debugLabel: kTagDetails,
        onRenderBlock: (tree, placeholder) {
          final attrs = tree.element.attributes;
          final open = attrs.containsKey(kAttributeDetailsOpen);

          return placeholder.wrapWith(
            (context, child) {
              final resolved = tree.inheritanceResolvers.resolve(context);
              final textStyle = resolved.style;
              final summaries = tree.detailsData.summaries;
              final summary = summaries.isNotEmpty
                  ? summaries.first
                  : wf.buildText(
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
            },
          );
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
            BuildOp(
              debugLabel: kTagSummary,
              onParsed: (summaryTree) {
                if (summaryTree.isEmpty) {
                  return summaryTree;
                }

                final marker = WidgetBit.inline(
                  summaryTree,
                  WidgetPlaceholder(
                    builder: (context, _) {
                      final resolved =
                          summaryTree.inheritanceResolvers.resolve(context);
                      return HtmlDetailsMarker(style: resolved.style);
                    },
                    debugLabel: '$kTagSummary--inlineMarker',
                  ),
                  alignment: _markerMarkerAlignment,
                );
                return summaryTree..prepend(marker);
              },
              onRenderBlock: (_, placeholder) {
                final data = detailsTree.detailsData;
                if (data.summaries.isNotEmpty) {
                  return placeholder;
                }

                data.summaries.add(placeholder);
                return WidgetPlaceholder(debugLabel: '$kTagSummary--block');
              },
              priority: Late.tagSummary,
            ),
          );
        },
        priority: Priority.tagDetails,
      );
}

extension on BuildTree {
  _TagDetailsData get detailsData =>
      getNonInherited<_TagDetailsData>() ?? setNonInherited(_TagDetailsData());
}

class _TagDetailsData {
  final summaries = <Widget>[];
}
