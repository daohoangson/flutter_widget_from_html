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
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('columnGap', columnGap, defaultValue: 0.0));
    properties.add(DoubleProperty('rowGap', rowGap, defaultValue: 0.0));
  }

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
    properties.add(IntProperty('columnSpan', columnSpan, defaultValue: 1));
    properties.add(IntProperty('columnStart', columnStart));
    properties.add(IntProperty('rowSpan', rowSpan, defaultValue: 1));
    properties.add(IntProperty('rowStart', rowStart));
  }

  @override
  Type get debugTypicalAncestorWidgetClass => HtmlTable;
}

extension _IterableDouble on Iterable<double> {
  double get sum => isEmpty ? 0.0 : reduce(_sum);

  static double _sum(double value, double element) => value + element;
}

class _TableCellData extends ContainerBoxParentData<RenderBox> {
  int columnSpan = 1;
  int columnStart;
  int rowSpan = 1;
  int rowStart;

  double calculateHeight(_TableRenderObject tro, List<double> heights) {
    final gap = (rowSpan - 1) * tro._rowGap;
    return heights.getRange(rowStart, rowStart + rowSpan).sum + gap;
  }

  double calculateWidth(_TableRenderObject tro, List<double> widths) {
    final gap = (columnSpan - 1) * tro._columnGap;
    return widths.getRange(columnStart, columnStart + columnSpan).sum + gap;
  }

  double calculateX(_TableRenderObject tro, List<double> widths) {
    final gap = (columnStart + 1) * tro._columnGap;
    return widths.getRange(0, columnStart).sum + gap;
  }

  double calculateY(_TableRenderObject tro, List<double> heights) {
    final gap = (rowStart + 1) * tro._rowGap;
    return heights.getRange(0, rowStart).sum + gap;
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
    final childSizes = List<Size>(children.length);
    final columnWidths = List.filled(columnCount, 0.0);
    final rowHeights = List.filled(rowCount, 0.0);
    for (var i = 0; i < children.length; i++) {
      final child = children[i];
      final data = cells[i];

      // assume even distribution of column widths if width is finite
      final childColumnGap = (data.columnSpan - 1) * _columnGap;
      final childWidth =
          width0.isFinite ? width0 * data.columnSpan + childColumnGap : null;
      final cc = c.copyWith(
        maxHeight: double.infinity,
        maxWidth: childWidth ?? double.infinity,
        minWidth: childWidth,
      );
      child.layout(cc, parentUsesSize: true);
      final childSize = childSizes[i] = child.size;

      // distribute cell width across spanned columns
      final columnWidth = (childSize.width - childColumnGap) / data.columnSpan;
      for (var c = 0; c < data.columnSpan; c++) {
        final column = data.columnStart + c;
        columnWidths[column] = max(columnWidths[column], columnWidth);
      }

      // distribute cell height across spanned rows
      final childRowGap = (data.rowSpan - 1) * _rowGap;
      final rowHeight = (childSize.height - childRowGap) / data.rowSpan;
      for (var r = 0; r < data.rowSpan; r++) {
        final row = data.rowStart + r;
        rowHeights[row] = max(rowHeights[row], rowHeight);
      }
    }

    // we now know all the widths and heights, let's position cells
    // sometime we have to relayout child, e.g. stretch its height for rowspan
    final calculatedHeight = rowHeights.sum + rowGaps;
    final constraintedHeight = c.constrainHeight(calculatedHeight);
    final deltaHeight = (constraintedHeight - calculatedHeight) / rowCount;
    final calculatedWidth = columnWidths.sum + columnGaps;
    final constraintedWidth = c.constrainWidth(calculatedWidth);
    final deltaWidth = (constraintedWidth - calculatedWidth) / columnCount;
    for (var i = 0; i < children.length; i++) {
      final data = cells[i];
      final childSize = childSizes[i];

      final childHeight = data.calculateHeight(this, rowHeights) + deltaHeight;
      final childWidth = data.calculateWidth(this, columnWidths) + deltaWidth;
      if (childSize.height != childHeight || childSize.width != childWidth) {
        final cc2 = BoxConstraints.tight(Size(childWidth, childHeight));
        children[i].layout(cc2, parentUsesSize: true);
      }

      data.offset = Offset(
        data.calculateX(this, columnWidths),
        data.calculateY(this, rowHeights),
      );
    }

    size = Size(constraintedWidth, constraintedHeight);
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _TableCellData) {
      child.parentData = _TableCellData();
    }
  }
}
