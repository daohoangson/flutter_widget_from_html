part of '../core_ops.dart';

const kAttributeAHref = 'href';
const kAttributeAName = 'name';
const kTagA = 'a';

class TagA {
  final WidgetFactory wf;

  TagA(this.wf);

  BuildOp get buildOp => BuildOp(
        defaultStyles: (_) => const {
          kCssTextDecoration: kCssTextDecorationUnderline,
        },
        onTree: (meta, tree) {
          final href = meta.element.attributes[kAttributeAHref];
          if (href == null) {
            return;
          }

          final url = wf.urlFull(href) ?? href;
          final recognizer = wf.buildGestureRecognizer(
            meta,
            onTap: () => wf.onTapUrl(url),
          );
          if (recognizer == null) {
            return;
          }

          tree.tsb.enqueue(_tsb, recognizer);
        },
      );

  static HtmlStyle _tsb(HtmlStyle tsh, GestureRecognizer value) {
    return tsh.copyWith(gestureRecognizer: value);
  }
}
