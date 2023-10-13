part of '../core_ops.dart';

final _isBody = Expando<bool>();

class ColumnPlaceholder extends WidgetPlaceholder {
  final Iterable<WidgetPlaceholder> children;
  final BuildTree tree;
  final WidgetFactory wf;

  ColumnPlaceholder({
    required this.children,
    super.key,
    required this.tree,
    required this.wf,
  }) : super(debugLabel: '${tree.element.localName}--column');

  bool get isBody => _isBody[this] == true;

  @override
  bool get isEmpty => children.isEmpty;

  @override
  Widget build(BuildContext context) {
    context.skipBuildHeightPlaceholder = true;

    try {
      final resolved = tree.inheritanceResolvers.resolve(context);
      final widgets = _buildWidgets(context);
      final built = wf.buildColumnWidget(
        context,
        widgets,
        crossAxisAlignment: resolved.columnCrossAxisAlignment,
        dir: resolved.directionOrLtr,
      );
      return isBody ? wf.buildBodyWidget(context, built) : built;
    } finally {
      context.skipBuildHeightPlaceholder = false;
    }
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

    final resolved = tree.inheritanceResolvers.resolve(context);
    final column = contents.isNotEmpty
        ? wf.buildColumnWidget(
            context,
            contents,
            crossAxisAlignment: resolved.columnCrossAxisAlignment,
            dir: resolved.directionOrLtr,
          )
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

extension on InheritedProperties {
  CrossAxisAlignment get columnCrossAxisAlignment {
    final isRtl = get<TextDirection>() == TextDirection.rtl;
    final textAlign = get<TextAlign>() ?? TextAlign.start;
    switch (textAlign) {
      case TextAlign.center:
        return CrossAxisAlignment.center;
      case TextAlign.end:
        return CrossAxisAlignment.end;
      case TextAlign.justify:
        return CrossAxisAlignment.stretch;
      case TextAlign.left:
        return isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start;
      case TextAlign.right:
        return isRtl ? CrossAxisAlignment.start : CrossAxisAlignment.end;
      case TextAlign.start:
        return CrossAxisAlignment.start;
    }
  }
}
