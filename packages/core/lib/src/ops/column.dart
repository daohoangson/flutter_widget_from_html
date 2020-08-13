part of '../core_widget_factory.dart';

class _ColumnPlaceholder extends WidgetPlaceholder<WidgetFactory> {
  final NodeMetadata meta;
  final bool trimMarginVertical;

  final Iterable<Widget> _children;

  _ColumnPlaceholder(
    this._children, {
    @required this.meta,
    @required this.trimMarginVertical,
    @required WidgetFactory wf,
  }) : super(generator: wf);

  List<Widget> get children {
    final contents = <Widget>[];

    _MarginVerticalPlaceholder marginBottom, marginTop;
    Widget prev;
    var state = 0;

    for (final child in _iterable) {
      if (state == 0) {
        if (child is _MarginVerticalPlaceholder) {
          if (!trimMarginVertical) {
            if (marginTop != null) {
              marginTop.mergeWith(child);
            } else {
              marginTop = child;
            }
          }
        } else {
          state++;
        }
      }

      if (state == 1) {
        if (child is _MarginVerticalPlaceholder &&
            prev is _MarginVerticalPlaceholder) {
          prev.mergeWith(child);
          continue;
        }

        contents.add(child);
        prev = child;
      }
    }

    if (contents.isNotEmpty) {
      final lastWidget = contents.last;
      if (lastWidget is _MarginVerticalPlaceholder) {
        contents.removeLast();

        if (!trimMarginVertical) marginBottom = lastWidget;
      }
    }

    final column = _buildColumn(contents);

    return [
      if (marginTop != null) marginTop,
      if (column != null) callBuilders(column),
      if (marginBottom != null) marginBottom,
    ];
  }

  WidgetFactory get wf => generator;

  Iterable<Widget> get _iterable sync* {
    for (var child in _children) {
      if (child == widget0) continue;

      if (child is _ColumnPlaceholder) {
        for (final grandChild in child.children) {
          yield grandChild;
        }
        continue;
      }

      yield child;
    }
  }

  @override
  Widget build(BuildContext _) => _buildColumn(children) ?? widget0;

  Widget _buildColumn(List<Widget> children) => wf.buildColumnWidget(
        children,
        textDirection: meta.tsb().build().textDirection,
      );
}
