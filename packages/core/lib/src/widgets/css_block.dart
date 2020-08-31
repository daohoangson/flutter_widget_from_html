import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// A CSS block.
///
/// [child] widget's width will be stretched to match parent's.
class CssBlock extends SingleChildRenderObjectWidget {
  /// Creates a CSS block.
  const CssBlock({@required Widget child, Key key})
      : assert(child != null),
        super(child: child, key: key);

  @override
  _RenderCssBlock createRenderObject(BuildContext _) => _RenderCssBlock();
}

class _RenderCssBlock extends RenderProxyBox {
  @override
  void performLayout() {
    final c = constraints;
    final cc = c.copyWith(
      // TODO: add support for `writing-mode`, assuming `horizontal-tb` for now
      // minHeight: c.maxHeight.isFinite ? c.maxHeight : null,
      minWidth: c.maxWidth.isFinite ? c.maxWidth : null,
    );

    child.layout(cc, parentUsesSize: true);
    size = child.size;
  }
}
