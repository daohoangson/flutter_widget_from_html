import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:meta/meta.dart';
import 'package:quiver/core.dart';
import 'package:quiver/iterables.dart';
import 'package:flutter/widgets.dart';

part 'table/foundation/collections.dart';
part 'table/foundation/placement.dart';
part 'table/rendering/layout_grid.dart';
part 'table/rendering/placement.dart';
part 'table/rendering/track_size.dart';

class LayoutGrid extends MultiChildRenderObjectWidget {
  LayoutGrid({
    Key key,
    @required this.templateColumnSizes,
    @required this.templateRowSizes,
    this.gap = 0,
    this.textDirection,
    List<Widget> children = const [],
  })  : assert(templateRowSizes != null && templateRowSizes.isNotEmpty),
        assert(templateColumnSizes != null && templateColumnSizes.isNotEmpty),
        super(key: key, children: children);

  final double gap;

  /// Defines the track sizing functions of the grid's columns.
  final List<TrackSize> templateColumnSizes;

  /// Defines the track sizing functions of the grid's rows.
  final List<TrackSize> templateRowSizes;

  /// The text direction used to resolve column ordering.
  ///
  /// Defaults to the ambient [Directionality].
  final TextDirection textDirection;

  @override
  RenderLayoutGrid createRenderObject(BuildContext context) {
    return RenderLayoutGrid(
      gap: gap,
      templateColumnSizes: templateColumnSizes,
      templateRowSizes: templateRowSizes,
      textDirection: textDirection ?? Directionality.of(context),
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderLayoutGrid renderObject) {
    renderObject
      ..gap = gap
      ..templateColumnSizes = templateColumnSizes
      ..templateRowSizes = templateRowSizes
      ..textDirection = textDirection ?? Directionality.of(context);
  }
}

class GridPlacement extends ParentDataWidget<GridParentData> {
  const GridPlacement({
    Key key,
    @required Widget child,
    this.columnStart,
    int columnSpan = 1,
    this.rowStart,
    int rowSpan = 1,
  })  : columnSpan = columnSpan ?? 1,
        rowSpan = rowSpan ?? 1,
        name = null,
        super(key: key, child: child);

  const GridPlacement.areaNamed({
    Key key,
    @required Widget child,
    @required this.name,
  })  : columnStart = null,
        columnSpan = null,
        rowStart = null,
        rowSpan = null,
        super(key: key, child: child);

  /// The name of the area whose tracks will be used to place this widget's
  /// child.
  final String name;

  /// If `null`, the child will be auto-placed.
  final int columnStart;

  /// The number of columns spanned by the child. Defaults to `1`.
  final int columnSpan;

  /// If `null`, the child will be auto-placed.
  final int rowStart;

  /// The number of rows spanned by the child. Defaults to `1`.
  final int rowSpan;

  @override
  void applyParentData(RenderObject renderObject) {
    assert(renderObject.parentData is GridParentData);
    final parentData = renderObject.parentData as GridParentData;
    var needsLayout = false;

    if (parentData.columnStart != columnStart) {
      parentData.columnStart = columnStart;
      needsLayout = true;
    }

    if (parentData.columnSpan != columnSpan) {
      parentData.columnSpan = columnSpan;
      needsLayout = true;
    }

    if (parentData.rowStart != rowStart) {
      parentData.rowStart = rowStart;
      needsLayout = true;
    }

    if (parentData.rowSpan != rowSpan) {
      parentData.rowSpan = rowSpan;
      needsLayout = true;
    }

    if (needsLayout) {
      final targetParent = renderObject.parent;
      if (targetParent is RenderObject) targetParent.markNeedsLayout();
      if (targetParent is RenderLayoutGrid) targetParent.markNeedsPlacement();
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    if (columnStart != null) {
      properties.add(IntProperty('columnStart', columnStart));
    } else {
      properties.add(StringProperty('columnStart', 'auto'));
    }
    if (columnSpan != null) {
      properties.add(IntProperty('columnSpan', columnSpan));
    }
    if (rowStart != null) {
      properties.add(IntProperty('rowStart', rowStart));
    } else {
      properties.add(StringProperty('rowStart', 'auto'));
    }
    if (rowSpan != null) {
      properties.add(IntProperty('rowSpan', rowSpan));
    }
  }

  @override
  Type get debugTypicalAncestorWidgetClass => LayoutGrid;
}
