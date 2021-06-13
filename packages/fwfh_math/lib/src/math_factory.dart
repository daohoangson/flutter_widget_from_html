import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

/// A mixin that can render math equation with `flutter_math` package.
mixin MathFactory on WidgetFactory {
  @override
  void parse(BuildMetadata meta) {
    if (meta.element.localName == 'math') {
      meta.register(BuildOp(
        onTree: (meta, tree) {
          tree.replaceWith(
              WidgetBit.inline(tree, Math.tex(meta.element.innerHtml)));
        },
      ));
    }

    super.parse(meta);
  }
}
