part of '../core_ops.dart';

final _isBody = Expando<bool>();

class ColumnPlaceholder extends WidgetPlaceholder<BuildMetadata> {
  final Iterable<WidgetPlaceholder> children;
  final BuildMetadata meta;
  final WidgetFactory wf;

  ColumnPlaceholder({
    required this.children,
    Key? key,
    required this.meta,
    required this.wf,
  }) : super(meta, key: key);

  bool get isBody => _isBody[this] == true;

  @override
  Widget build(BuildContext context) {
    final tsh = meta.tsb.build(context);
    final widgets = _buildWidgets(context);
    final built = wf.buildColumnWidget(
      context,
      widgets,
      dir: tsh.textDirection,
    );
    return isBody ? wf.buildBodyWidget(context, built) : built;
  }

  @override
  ColumnPlaceholder wrapWith(
      Widget? Function(BuildContext context, Widget child) builder) {
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

    for (final child in _getIterable(context)) {
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

    final tsh = meta.tsb.build(context);
    final column = contents.isNotEmpty
        ? wf.buildColumnWidget(context, contents, dir: tsh.textDirection)
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
