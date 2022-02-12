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

          final onTap = wf.gestureTapCallback(wf.urlFull(href) ?? href);
          if (onTap == null) {
            return;
          }

          tree.tsb.enqueue(_tsb, onTap);
        },
      );

  static HtmlStyle _tsb(HtmlStyle tsh, GestureTapCallback value) {
    return tsh.copyWith(onTap: value);
  }
}
