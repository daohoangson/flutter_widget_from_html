part of '../core_widget_factory.dart';

const _kCssMargin = 'margin';

Widget _marginHorizontalBuilder(
  Widget child,
  CssLengthBox margin,
  TextStyleBuilder tsb,
) =>
    Builder(builder: (context) {
      final direction = Directionality.of(context);

      return Padding(
        child: child,
        padding: EdgeInsets.only(
          left: margin.left(direction)?.getValue(tsb.build()) ?? 0.0,
          right: margin.right(direction)?.getValue(tsb.build()) ?? 0.0,
        ),
      );
    });

class _MarginVerticalPlaceholder extends WidgetPlaceholder<CssLength> {
  final CssLength height;
  final TextStyleBuilder tsb;

  _MarginVerticalPlaceholder(this.height, this.tsb) : super(generator: height) {
    super.wrapWith((child) => _build(child, height, tsb));
  }

  void mergeWith(_MarginVerticalPlaceholder other) =>
      super.wrapWith((child) => _build(child, other.height, other.tsb));

  @override
  _MarginVerticalPlaceholder wrapWith(Widget Function(Widget) builder) => this;

  static Widget _build(Widget child, CssLength height, TextStyleBuilder tsb) {
    final existing = child is SizedBox ? child.height : 0.0;
    final value = height.getValue(tsb.build());
    if (value > existing) return SizedBox(height: value);
    return child;
  }
}

class _StyleMargin {
  final WidgetFactory wf;

  _StyleMargin(this.wf);

  BuildOp get buildOp => BuildOp(
        isBlockElement: false,
        onPieces: (meta, pieces) {
          if (meta.isBlockElement) return pieces;
          final m = wf.parseCssLengthBox(meta, _kCssMargin);
          if (m?.hasLeftOrRight != true) return pieces;

          return _wrapTextBits(
            pieces,
            appendBuilder: (parent) =>
                TextWidget(parent, _paddingInlineAfter(parent.tsb, m)),
            prependBuilder: (parent) =>
                TextWidget(parent, _paddingInlineBefore(parent.tsb, m)),
          );
        },
        onWidgets: (meta, widgets) {
          if (widgets?.isNotEmpty != true) return null;
          final m = wf.parseCssLengthBox(meta, _kCssMargin);
          if (m == null) return null;

          final t = m.top?.isNotEmpty == true;
          final b = m.bottom?.isNotEmpty == true;
          final ws = List<WidgetPlaceholder>(
              (t ? 1 : 0) + widgets.length + (b ? 1 : 0));
          final tsb = meta.tsb();

          var i = 0;
          if (t) ws[i++] = _MarginVerticalPlaceholder(m.top, tsb);

          for (final widget in widgets) {
            if (m.hasLeftOrRight) {
              widget.wrapWith(
                (child) => _marginHorizontalBuilder(child, m, tsb),
              );
            }

            ws[i++] = widget;
          }

          if (b) ws[i++] = _MarginVerticalPlaceholder(m.bottom, tsb);

          return ws;
        },
        priority: 99999,
      );
}
