part of '../core_ops.dart';

const kAttributeAHref = 'href';
const kAttributeAName = 'name';
const kTagA = 'a';

class TagA {
  final WidgetFactory wf;

  TagA(this.wf);

  BuildOp get buildOp => BuildOp(
        debugLabel: 'a[href]',
        defaultStyles: (_) => const {
          kCssTextDecoration: kCssTextDecorationUnderline,
        },
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
        priority: Prioritiy.tagA,
      );

  static HtmlStyle defaultColor(HtmlStyle style, void _) => style.copyWith(
        textStyle: style.textStyle.copyWith(
          color: style.getDependency<ThemeData>().colorScheme.primary,
          debugLabel: 'fwfh: a[href] default color',
        ),
      );

  static HtmlStyle _builder(HtmlStyle style, GestureRecognizer value) =>
      style.copyWith(gestureRecognizer: value);
}
