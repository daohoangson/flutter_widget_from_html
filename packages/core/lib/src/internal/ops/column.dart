part of '../ops.dart';

class ColumnPlaceholder extends WidgetPlaceholder<NodeMetadata> {
  final NodeMetadata meta;
  final bool trimMarginVertical;
  final WidgetFactory wf;

  final Iterable<Widget> _children;

  ColumnPlaceholder(
    this._children, {
    @required this.meta,
    @required this.trimMarginVertical,
    @required this.wf,
  }) : super(generator: meta);

  List<Widget> get children {
    final contents = <Widget>[];

    HeightPlaceholder marginBottom, marginTop;
    Widget prev;
    var state = 0;

    for (final child in _iterable) {
      if (state == 0) {
        if (child is HeightPlaceholder) {
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
        if (child is HeightPlaceholder && prev is HeightPlaceholder) {
          prev.mergeWith(child);
          continue;
        }

        contents.add(child);
        prev = child;
      }
    }

    if (contents.isNotEmpty) {
      final lastWidget = contents.last;
      if (lastWidget is HeightPlaceholder) {
        contents.removeLast();

        if (!trimMarginVertical) marginBottom = lastWidget;
      }
    }

    final column = wf.buildColumnWidget(meta, contents);

    return [
      if (marginTop != null) marginTop,
      if (column != null) callBuilders(column),
      if (marginBottom != null) marginBottom,
    ];
  }

  Iterable<Widget> get _iterable sync* {
    for (var child in _children) {
      if (child == widget0) continue;

      if (child is ColumnPlaceholder) {
        for (final grandChild in child.children) {
          yield grandChild;
        }
        continue;
      }

      yield child;
    }
  }

  @override
  Widget build(BuildContext _) =>
      wf.buildColumnWidget(meta, children) ?? widget0;
}
