part of '../core_ops.dart';

const kAttributeDetailsOpen = 'open';

const kTagDetails = 'details';
const kTagSummary = 'summary';

class TagDetails {
  final WidgetFactory wf;

  TagDetails(this.wf);

  BuildOp get buildOp => BuildOp.v1(
        debugLabel: kTagDetails,
        onChild: (detailsTree, subTree) {
          final e = subTree.element;
          if (e.parent != detailsTree.element) {
            return;
          }
          if (e.localName != kTagSummary) {
            return;
          }

          subTree.register(
            BuildOp.v1(
              debugLabel: kTagSummary,
              onParsed: (summaryTree) {
                if (summaryTree.isEmpty) {
                  return summaryTree;
                }

                final marker = WidgetBit.inline(
                  summaryTree,
                  WidgetPlaceholder(
                    builder: (context, child) {
                      final style = summaryTree.styleBuilder.build(context);
                      return HtmlDetailsMarker(style: style.textStyle);
                    },
                    debugLabel: '$kTagSummary--inlineMarker',
                  ),
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
        onRenderBlock: (tree, placeholder) {
          final attrs = tree.element.attributes;
          final open = attrs.containsKey(kAttributeDetailsOpen);

          return placeholder.wrapWith(
            (context, child) {
              final style = tree.styleBuilder.build(context);
              final textStyle = style.textStyle;
              final summaries = tree.detailsData.summaries;
              final summary = summaries.isNotEmpty
                  ? summaries.first
                  : wf.buildText(
                      tree,
                      style,
                      TextSpan(
                        children: [
                          WidgetSpan(
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
                  dir: style.textDirection,
                ),
              );
            },
          );
        },
        priority: Priority.tagDetails,
      );
}

extension on BuildTree {
  _TagDetailsData get detailsData =>
      getNonInheritedProperty<_TagDetailsData>() ??
      setNonInheritedProperty<_TagDetailsData>(_TagDetailsData());
}

class _TagDetailsData {
  final summaries = <Widget>[];
}
