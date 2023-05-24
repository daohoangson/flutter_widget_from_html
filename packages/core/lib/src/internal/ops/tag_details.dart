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
      debugLabel: kTagSummary,
      onParsed: (tree) {
        if (tree.isEmpty) {
          return tree;
        }

        final marker = WidgetBit.inline(
          tree,
          WidgetPlaceholder(
            builder: (context, child) {
              final style = tree.styleBuilder.build(context);
              return HtmlDetailsMarker(style: style.textStyle);
            },
            debugLabel: '$kTagSummary--inlineMarker',
          ),
        );
        return tree..prepend(marker);
      },
      onRenderBlock: (tree, placeholder) {
        if (_summary != null) {
          return null;
        }

        _summary = placeholder;
        return WidgetPlaceholder(debugLabel: '$kTagSummary--block');
      },
      priority: Late.tagSummary,
    );
  }

  BuildOp get buildOp => BuildOp(
        debugLabel: kTagDetails,
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
        onRenderBlock: (tree, placeholder) {
          final attrs = tree.element.attributes;
          final open = attrs.containsKey(kAttributeDetailsOpen);

          return placeholder.wrapWith(
            (context, child) {
              final style = tree.styleBuilder.build(context);
              final textStyle = style.textStyle;
              final summary = _summary ??
                  wf.buildText(
                    tree,
                    style,
                    TextSpan(
                      children: [
                        WidgetSpan(child: HtmlDetailsMarker(style: textStyle)),
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
                  dir: style.getDependency(),
                ),
              );
            },
          );
        },
        priority: Prioritiy.tagDetails,
      );
}
