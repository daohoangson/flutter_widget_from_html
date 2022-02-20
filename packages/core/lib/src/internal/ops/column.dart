part of '../core_ops.dart';

final _isBody = Expando<bool>();

class ColumnPlaceholder extends WidgetPlaceholder {
  final Iterable<WidgetPlaceholder> children;
  final BuildTree tree;
  final WidgetFactory wf;

  ColumnPlaceholder({
    required this.children,
    Key? key,
    required this.tree,
    required this.wf,
  }) : super(debugLabel: tree.element.localName, key: key);

  bool get isBody => _isBody[this] == true;

  @override
  Widget build(BuildContext context) {
    final style = tree.styleBuilder.build(context);
    final widgets = _buildWidgets(context);
    final built = wf.buildColumnWidget(
      context,
      widgets,
      dir: style.textDirection,
    );
    return isBody ? wf.buildBodyWidget(context, built) : built;
  }

  @override
  ColumnPlaceholder wrapWith(
    Widget? Function(BuildContext context, Widget child) builder,
  ) {
    if (builder == wf.buildBodyWidget) {
      _isBody[this] = true;
    } else {
      super.wrapWith(builder);
    }
    return this;
  }

  List<Widget> _buildWidgets(BuildContext context) {
    final contents = <Widget>[];

    HeightPlaceholder? marginBottom;
    HeightPlaceholder? marginTop;
    Widget? prev;
    var state = 0;

    final iterable = _getIterable(context)
        .map((child) => WidgetPlaceholder.unwrap(context, child))
        .where((child) => child != widget0);

    for (final child in iterable) {
      if (state == 0) {
        if (child is HeightPlaceholder) {
          if (marginTop != null) {
            marginTop.mergeWith(child);
          } else {
            marginTop = child;
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
        marginBottom = lastWidget;
      }
    }

    final style = tree.styleBuilder.build(context);
    final column = contents.isNotEmpty
        ? wf.buildColumnWidget(context, contents, dir: style.textDirection)
        : null;

    return [
      if (marginTop != null) marginTop,
      if (column != null) callBuilders(context, column),
      if (marginBottom != null) marginBottom,
    ];
  }

  Iterable<Widget> _getIterable(BuildContext context) sync* {
    for (final child in children) {
      if (child is ColumnPlaceholder) {
        for (final grandChild in child._buildWidgets(context)) {
          yield grandChild;
        }
        continue;
      }

      yield child;
    }
  }
}
