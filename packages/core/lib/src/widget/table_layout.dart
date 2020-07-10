import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:meta/meta.dart';
import 'package:flutter/widgets.dart';

part 'table/collections.dart';
part 'table/placement.dart';
part 'table/rendering.dart';
part 'table/track.dart';

class TableLayout extends MultiChildRenderObjectWidget {
  TableLayout({
    @required int cols,
    this.gap = 0,
    Key key,
    @required int rows,
    this.textDirection,
    List<Widget> children = const [],
  })  : _templateColumnSizes =
            List.generate(cols, (_) => const _TrackSizeFlexible(1)),
        _templateRowSizes =
            List.generate(rows, (_) => const _TrackSizeIntrinsic()),
        super(key: key, children: children);

  final double gap;

  final List<_TrackSize> _templateColumnSizes;

  final List<_TrackSize> _templateRowSizes;

  final TextDirection textDirection;

  @override
  RenderBox createRenderObject(BuildContext context) => _TableRenderBox(
        gap: gap,
        templateColumnSizes: _templateColumnSizes,
        templateRowSizes: _templateRowSizes,
        textDirection: textDirection ?? Directionality.of(context),
      );

  @override
  void updateRenderObject(BuildContext context, _TableRenderBox renderObject) {
    renderObject
      ..gap = gap
      ..templateColumnSizes = _templateColumnSizes
      ..templateRowSizes = _templateRowSizes
      ..textDirection = textDirection ?? Directionality.of(context);
  }
}

class TablePlacement extends ParentDataWidget<_RenderingPlacementData> {
  const TablePlacement({
    Key key,
    @required Widget child,
    @required this.columnStart,
    this.columnSpan = 1,
    @required this.rowStart,
    this.rowSpan = 1,
  })  : assert(columnStart != null),
        assert(rowStart != null),
        super(key: key, child: child);

  final int columnStart;
  final int columnSpan;
  final int rowStart;
  final int rowSpan;

  @override
  void applyParentData(RenderObject renderObject) {
    assert(renderObject.parentData is _RenderingPlacementData);
    final parentData = renderObject.parentData as _RenderingPlacementData;
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
      if (targetParent is _TableRenderBox) targetParent.markNeedsPlacement();
    }
  }

  @override
  Type get debugTypicalAncestorWidgetClass => TableLayout;
}
