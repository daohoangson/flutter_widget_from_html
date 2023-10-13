part of '../core_ops.dart';

const kAttributeAHref = 'href';
const kAttributeAName = 'name';
const kTagA = 'a';

class TagA {
  final WidgetFactory wf;

  TagA(this.wf);

  BuildOp get buildOp => BuildOp(
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

          return tree..inherit(_builder, recognizer);
        },
        priority: Priority.tagA,
      );

  static InheritedProperties defaultColor(
    InheritedProperties resolving,
    BuildContext? context,
  ) =>
      resolving.copyWith(
        style: resolving.style.copyWith(
          color: Theme.of(context!).colorScheme.primary,
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

extension GestureRecognizerGetter on InheritedProperties {
  /// The [GestureRecognizer] for inline spans.
  GestureRecognizer? get gestureRecognizer => get();
}
