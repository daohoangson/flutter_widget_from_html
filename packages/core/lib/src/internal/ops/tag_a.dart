part of '../core_ops.dart';

const kAttributeAHref = 'href';
const kAttributeAName = 'name';
const kTagA = 'a';

class TagA {
  final WidgetFactory wf;

  TagA(this.wf);

  BuildOp get buildOp => BuildOp(
        alwaysRenderBlock: false,
        debugLabel: 'a[href]',
        defaultStyles: _defaultStyles,
        onParsed: (tree) {
          final href = tree.element.attributes[kAttributeAHref];
          if (href == null) {
            return tree;
          }

          final url = wf.urlFull(href) ?? href;
          final recognizer = wf.buildGestureRecognizer(
            tree,
            onTap: () => wf.onTapUrl(url),
          );
          if (recognizer == null) {
            return tree;
          }

          if (tree.isInline == true) {
            for (final bit in tree.bits) {
              if (bit is WidgetBit && bit.isInline == false) {
                bit.child.wrapWith((context, child) {
                  // for inline A tag: wrap inner blocks in gesture detectors
                  return wf.buildGestureDetector(tree, child, recognizer);
                });
              }
            }
          }

          return tree
            // for inline spans
            ..inherit(_builder, recognizer)
            // for onRenderBlock
            ..setNonInheritedRecognizer(recognizer);
        },
        onRenderBlock: (tree, placeholder) {
          final recognizer = tree.nonInheritedRecognizer;
          if (recognizer != null) {
            placeholder.wrapWith((context, child) {
              if (child == widget0) {
                return null;
              }

              // for block A tag: wrap itself in a gesture detector
              return wf.buildGestureDetector(tree, child, recognizer);
            });
          }
          return placeholder;
        },
        priority: Priority.tagA,
      );

  static InheritedProperties defaultColor(
    InheritedProperties resolving,
    BuildContext? context,
  ) =>
      context == null
          ? resolving
          : resolving.copyWith(
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                debugLabel: 'fwfh: a[href] default color',
              ),
            );

  static StylesMap _defaultStyles(dom.Element _) {
    return const {
      kCssTextDecoration: kCssTextDecorationUnderline,
    };
  }

  static InheritedProperties _builder(
    InheritedProperties resolving,
    GestureRecognizer value,
  ) =>
      resolving.copyWith<GestureRecognizer>(value: value);
}

extension on BuildTree {
  void setNonInheritedRecognizer(GestureRecognizer recognizer) =>
      setNonInherited<GestureRecognizer>(recognizer);

  GestureRecognizer? get nonInheritedRecognizer => getNonInherited();
}

extension GestureRecognizerGetter on InheritedProperties {
  /// The [GestureRecognizer] for inline spans.
  GestureRecognizer? get gestureRecognizer => get();
}
