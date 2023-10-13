part of '../core_ops.dart';

const kAttributeDetailsOpen = 'open';

const kTagDetails = 'details';
const kTagSummary = 'summary';

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
              final style = tree.styleBuilder.build(context);
              final textStyle = style.textStyle;
              final summaries = tree.summaries;
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
                    HtmlSummary(style: style.textStyle, child: summary),
                    HtmlDetailsContents(child: child),
                  ],
                  dir: style.textDirection,
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
                final summaries = detailsTree.summaries;
                if (summaries.isNotEmpty) {
                  return placeholder;
                }

                summaries.add(placeholder);
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
  List<Widget> get summaries {
    final existing = value<_TagDetailsData>();
    if (existing != null) {
      return existing.summaries;
    }

    final newData = _TagDetailsData();
    value(newData);
    return newData.summaries;
  }
}

class _TagDetailsData {
  final summaries = <Widget>[];
}
