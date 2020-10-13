import 'dart:math';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// A TABLE widget.
class HtmlTable extends MultiChildRenderObjectWidget {
  /// The gap between columns.
  final double columnGap;

  /// The gap between rows.
  final double rowGap;

  /// Creates a TABLE widget.
  HtmlTable({
    List<Widget> children,
    this.columnGap = 0.0,
    Key key,
    this.rowGap = 0.0,
  }) : super(children: children, key: key);

  @override
  RenderObject createRenderObject(BuildContext _) => _TableRenderObject()
    ..columnGap = columnGap
    ..rowGap = rowGap;

  @override
  void updateRenderObject(BuildContext _, _TableRenderObject renderObject) {
    super.updateRenderObject(_, renderObject);

    renderObject
      ..columnGap = columnGap
      ..rowGap = rowGap;
  }
}

/// A TD (table cell) widget.
class HtmlTableCell extends ParentDataWidget<_TableCellData> {
  /// The number of columns this cell should span.
  final int columnSpan;

  /// The column index this cell should start.
  final int columnStart;

  /// The number of rows this cell should span.
  final int rowSpan;

  /// The row index this cell should start.
  final int rowStart;

  /// Creates a TD (table cell) widget.
  HtmlTableCell({
    @required Widget child,
    this.columnSpan = 1,
    @required this.columnStart,
    Key key,
    this.rowSpan = 1,
    @required this.rowStart,
  })  : assert(columnSpan >= 1),
        assert(columnStart >= 0),
        assert(rowSpan >= 1),
        assert(rowStart >= 0),
        super(child: child, key: key);

  @override
  void applyParentData(RenderObject renderObject) {
    final data = renderObject.parentData as _TableCellData;
    var needsLayout = false;

    if (data.columnSpan != columnSpan) {
      data.columnSpan = columnSpan;
      needsLayout = true;
    }

    if (data.columnStart != columnStart) {
      data.columnStart = columnStart;
      needsLayout = true;
    }

    if (data.rowStart != rowStart) {
      data.rowStart = rowStart;
      needsLayout = true;
    }

    if (data.rowSpan != rowSpan) {
      data.rowSpan = rowSpan;
      needsLayout = true;
    }

    if (needsLayout) {
      final parent = renderObject.parent;
      if (parent is RenderObject) parent.markNeedsLayout();
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('columnSpan', columnSpan));
    properties.add(IntProperty('columnStart', columnStart));
    properties.add(IntProperty('rowSpan', rowSpan));
    properties.add(IntProperty('rowStart', rowStart));
  }

  @override
  Type get debugTypicalAncestorWidgetClass => HtmlTable;
}

double _combineMax(double prev, double v) => max(prev, v);

double _combineSum(double prev, double v) => prev + v;

Set<double> _doubleSetGenerator(int _) => {};

class _TableCellData extends ContainerBoxParentData<RenderBox> {
  int columnSpan;
  int columnStart;
  int rowSpan;
  int rowStart;

  double calculateHeight(_TableRenderObject tro, List<double> heights) {
    final gap = max(0, rowSpan - 1) * tro._rowGap;
    return heights
            .getRange(rowStart, rowStart + rowSpan)
            .fold(0.0, _combineSum) +
        gap;
  }

  double calculateWidth(_TableRenderObject tro, double width0) {
    final gap = max(0, columnSpan - 1) * tro._columnGap;
    return width0 * columnSpan + gap;
  }

  double calculateX(_TableRenderObject tro, double width0) {
    final gap = (columnStart + 1) * tro._columnGap;
    return columnStart * width0 + gap;
  }

  double calculateY(_TableRenderObject tro, List<double> heights) {
    final gap = (rowStart + 1) * tro._rowGap;
    return heights.getRange(0, rowStart).fold(0.0, _combineSum) + gap;
  }
}

class _TableRenderObject extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _TableCellData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _TableCellData> {
  double _columnGap;
  set columnGap(double v) {
    if (v == _columnGap) return;
    _columnGap = v;
    markNeedsLayout();
  }

  double _rowGap;
  set rowGap(double v) {
    if (v == _rowGap) return;
    _rowGap = v;
    markNeedsLayout();
  }

  @override
  double computeDistanceToActualBaseline(TextBaseline baseline) {
    assert(!debugNeedsLayout);
    double result;

    var child = firstChild;
    while (child != null) {
      final data = child.parentData as _TableCellData;
      // only compute cells in the first row
      if (data.rowStart != 0) continue;

      var candidate = child.getDistanceToActualBaseline(baseline);
      if (candidate != null) {
        candidate += data.offset.dy;
        if (result != null) {
          result = min(result, candidate);
        } else {
          result = candidate;
        }
      }

      child = data.nextSibling;
    }

    return result;
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {Offset position}) =>
      defaultHitTestChildren(result, position: position);

  @override
  void paint(PaintingContext context, Offset offset) =>
      defaultPaint(context, offset);

  @override
  void performLayout() {
    final c = constraints;
    final children = <RenderBox>[];
    final cells = <_TableCellData>[];

    var child = firstChild;
    var columnCount = 0;
    var rowCount = 0;
    while (child != null) {
      final data = child.parentData as _TableCellData;
      children.add(child);
      cells.add(data);

      columnCount = max(columnCount, data.columnStart + data.columnSpan);
      rowCount = max(rowCount, data.rowStart + data.rowSpan);

      child = data.nextSibling;
    }

    final columnGaps = (columnCount + 1) * _columnGap;
    final rowGaps = (rowCount + 1) * _rowGap;
    final width0 = (c.maxWidth - columnGaps) / columnCount;
    final childDistances = List<double>.filled(children.length, 0.0);
    final childSizes = List<Size>(children.length);
    final rowDistances =
        List<Set<double>>.generate(rowCount, _doubleSetGenerator);
    for (var i = 0; i < children.length; i++) {
      final child = children[i];
      final data = cells[i];
      final cc = c.tighten(width: data.calculateWidth(this, width0));
      child.layout(cc, parentUsesSize: true);
      childSizes[i] = child.size;

      final distance = child.getDistanceToBaseline(TextBaseline.alphabetic);
      childDistances[i] = distance;
      rowDistances[data.rowStart].add(distance);
    }

    final distances = rowDistances
        .map((values) => values.fold(0.0, _combineMax))
        .toList(growable: false);
    final rowHeights =
        List<Set<double>>.generate(rowCount, _doubleSetGenerator);
    for (var i = 0; i < children.length; i++) {
      final data = cells[i];
      final childSize = childSizes[i];
      final distanceDelta = distances[data.rowStart] - childDistances[i];
      final rowHeight = (distanceDelta + childSize.height) / data.rowSpan;

      for (var r = 0; r < data.rowSpan; r++) {
        rowHeights[data.rowStart + r].add(rowHeight);
      }
    }

    final heights = rowHeights
        .map((values) => values.fold(0.0, _combineMax))
        .toList(growable: false);
    for (var i = 0; i < children.length; i++) {
      final childSize = childSizes[i];
      final data = cells[i];

      final height = data.calculateHeight(this, heights);
      if (childSize.height != height) {
        final cc = c.tighten(width: childSize.width, height: height);
        children[i].layout(cc, parentUsesSize: true);
      }

      final distanceDelta = distances[data.rowStart] - childDistances[i];
      data.offset = Offset(
        data.calculateX(this, width0),
        distanceDelta + data.calculateY(this, heights),
      );
    }

    size = Size(
      width0 * columnCount + columnGaps,
      heights.fold<double>(0.0, _combineSum) + rowGaps,
    );
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _TableCellData) {
      child.parentData = _TableCellData();
    }
  }
}
