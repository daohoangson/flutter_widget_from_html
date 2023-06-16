part of '../core_ops.dart';

const kAttributeAHref = 'href';
const kAttributeAName = 'name';
const kTagA = 'a';

class TagA {
  final WidgetFactory wf;

  TagA(this.wf);

  BuildOp get buildOp => BuildOp.v1(
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

          return tree..apply(_builder, recognizer);
        },
        priority: Priority.tagA,
      );

  static StylesMap _defaultStyles(BuildTree _) {
    return const {
      kCssTextDecoration: kCssTextDecorationUnderline,
    };
  }

  static HtmlStyle _builder(HtmlStyle style, GestureRecognizer value) =>
      style.copyWith<GestureRecognizer>(value: value);
}

extension GestureRecognizerGetter on HtmlStyle {
  /// The [GestureRecognizer] for inline spans.
  GestureRecognizer? get gestureRecognizer => value();
}
