import 'dart:math';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'css_sizing.dart';

/// A TABLE widget.
class HtmlTable extends MultiChildRenderObjectWidget {
  /// The table border sides.
  final Border? border;

  /// Controls whether to collapse borders.
  ///
  /// Default: `false`.
  final bool borderCollapse;

  /// The gap between borders.
  ///
  /// Default: `0.0`.
  final double borderSpacing;

  /// Determines the order to lay children out horizontally.
  ///
  /// Default: [TextDirection.ltr].
  final TextDirection textDirection;

  /// Creates a TABLE widget.
  HtmlTable({
    this.border,
    this.borderCollapse = false,
    this.borderSpacing = 0.0,
    required List<Widget> children,
    this.textDirection = TextDirection.ltr,
    Key? key,
  }) : super(children: children, key: key);

  @override
  RenderObject createRenderObject(BuildContext _) => _TableRenderObject(
        border,
        borderSpacing,
        textDirection,
        borderCollapse: borderCollapse,
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('border', border, defaultValue: null));
    properties.add(
      FlagProperty(
        'borderCollapse',
        value: borderCollapse,
        defaultValue: false,
        ifTrue: 'borderCollapse: true',
      ),
    );
    properties
        .add(DoubleProperty('borderSpacing', borderSpacing, defaultValue: 0.0));
    properties.add(
      DiagnosticsProperty(
        'textDirection',
        textDirection,
        defaultValue: TextDirection.ltr,
      ),
    );
  }

  @override
  void updateRenderObject(BuildContext _, RenderObject renderObject) {
    (renderObject as _TableRenderObject)
      ..setBorder(border)
      ..setBorderCollapse(borderCollapse)
      ..setBorderSpacing(borderSpacing)
      ..setTextDirection(textDirection);
  }
}

/// A table caption widget.
class HtmlTableCaption extends HtmlTableCell {
  /// Creates a table caption widget.
  const HtmlTableCaption({
    required Widget child,
    required int columnSpan,
    required int rowIndex,
    Key? key,
  }) : super._(
          columnStart: 0,
          columnSpan: columnSpan,
          isCaption: true,
          key: key,
          rowStart: rowIndex,
          child: child,
        );
}

/// A TD (table cell) widget.
class HtmlTableCell extends ParentDataWidget<_TableCellData> {
  /// The cell border sides.
  final Border? border;

  /// The number of columns this cell should span.
  final int columnSpan;

  /// The column index this cell should start.
  final int columnStart;

  /// The number of rows this cell should span.
  final int rowSpan;

  /// The row index this cell should start.
  final int rowStart;

  /// The cell width.
  final CssSizingValue? width;

  final bool _isCaption;

  /// Creates a TD (table cell) widget.
  const factory HtmlTableCell({
    Border? border,
    required Widget child,
    int columnSpan,
    required int columnStart,
    Key? key,
    int rowSpan,
    required int rowStart,
    CssSizingValue? width,
  }) = HtmlTableCell._;

  const HtmlTableCell._({
    this.border,
    required Widget child,
    this.columnSpan = 1,
    required this.columnStart,
    bool isCaption = false,
    Key? key,
    this.rowSpan = 1,
    required this.rowStart,
    this.width,
  })  : assert(columnSpan >= 1),
        assert(columnStart >= 0),
        assert(rowSpan >= 1),
        assert(rowStart >= 0),
        _isCaption = isCaption,
        super(child: child, key: key);

  @override
  void applyParentData(RenderObject renderObject) {
    final data = renderObject.parentData! as _TableCellData;
    var needsLayout = false;

    if (data.border != border) {
      data.border = border;
      needsLayout = true;
    }

    if (data.columnSpan != columnSpan) {
      data.columnSpan = columnSpan;
      needsLayout = true;
    }

    if (data.columnStart != columnStart) {
      data.columnStart = columnStart;
      needsLayout = true;
    }

    if (data.isCaption != _isCaption) {
      data.isCaption = _isCaption;
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

    if (data.width != width) {
      data.width = width;
      needsLayout = true;
    }

    if (needsLayout) {
      final parent = renderObject.parent;
      if (parent is RenderObject) {
        parent.markNeedsLayout();
      }
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('border', border, defaultValue: null));
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
  Border? border;
  int columnSpan = 1;
  int columnStart = 0;
  bool isCaption = false;
  int rowSpan = 1;
  int rowStart = 0;
  CssSizingValue? width;

  double calculateHeight(_TableRenderObject tro, List<double> heights) {
    final gaps = tro._calculateRowGaps(this);
    return heights.getRange(rowStart, rowStart + rowSpan).sum + gaps;
  }

  double calculateWidth(_TableRenderObject tro, List<double> widths) {
    final gaps = tro._calculateColumnGaps(this);
    return widths.getRange(columnStart, columnStart + columnSpan).sum + gaps;
  }

  double calculateX(_TableRenderObject tro, List<double> widths) {
    final padding = tro._border?.left.width ?? 0.0;
    final gaps = (columnStart + 1) * tro.columnGap;
    return padding + widths.getRange(0, columnStart).sum + gaps;
  }

  double calculateY(_TableRenderObject tro, List<double> heights) {
    final padding = isCaption ? .0 : (tro._border?.top.width ?? 0.0);
    final gaps = (rowStart + 1) * tro.rowGap;
    return padding + heights.getRange(0, rowStart).sum + gaps;
  }
}

class _TableRenderLayout {
  final Rect cellRect;
  final Size totalSize;

  const _TableRenderLayout(this.cellRect, this.totalSize);

  static const _TableRenderLayout zero =
      _TableRenderLayout(Rect.zero, Size.zero);
}

class _TableRenderObject extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _TableCellData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _TableCellData> {
  _TableRenderObject(
    this._border,
    this._borderSpacing,
    this._textDirection, {
    required bool borderCollapse,
  }) : _borderCollapse = borderCollapse;

  Border? _border;
  void setBorder(Border? v) {
    if (v != _border) {
      _border = v;
      markNeedsLayout();
    }
  }

  bool _borderCollapse;
  // ignore: avoid_positional_boolean_parameters
  void setBorderCollapse(bool v) {
    if (v != _borderCollapse) {
      _borderCollapse = v;
      markNeedsLayout();
    }
  }

  double _borderSpacing;
  void setBorderSpacing(double v) {
    if (v != _borderSpacing) {
      _borderSpacing = v;
      markNeedsLayout();
    }
  }

  var _layout = _TableRenderLayout.zero;

  TextDirection _textDirection;
  void setTextDirection(TextDirection v) {
    if (v != _textDirection) {
      _textDirection = v;
      markNeedsLayout();
    }
  }

  double get columnGap => _border != null && _borderCollapse
      ? (_border!.left.width * -1.0)
      : _borderSpacing;

  double get paddingBottom => _border?.bottom.width ?? 0.0;

  double get paddingLeft => _border?.left.width ?? 0.0;

  double get paddingRight => _border?.right.width ?? 0.0;

  double get paddingTop => _border?.top.width ?? 0.0;

  double get rowGap => _border != null && _borderCollapse
      ? (_border!.top.width * -1.0)
      : _borderSpacing;

  @override
  double? computeDistanceToActualBaseline(TextBaseline baseline) {
    assert(!debugNeedsLayout);
    double? result;

    var child = firstChild;
    while (child != null) {
      final data = child.parentData! as _TableCellData;

      if (data.rowStart == 0) {
        // only compute cells in the first row
        var candidate = child.getDistanceToActualBaseline(baseline);
        if (candidate != null) {
          candidate += data.offset.dy;
          if (result != null) {
            if (candidate < result) {
              result = candidate;
            }
          } else {
            result = candidate;
          }
        }
      }

      child = data.nextSibling;
    }

    return result;
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) =>
      _performLayout(this, firstChild!, constraints, _performLayoutDry)
          .totalSize;

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) =>
      defaultHitTestChildren(result, position: position);

  @override
  void paint(PaintingContext context, Offset offset) {
    final cellRect = _layout.cellRect;
    if (!cellRect.isEmpty) {
      _border?.paint(context.canvas, cellRect.shift(offset));
    }

    var child = firstChild;
    while (child != null) {
      final data = child.parentData! as _TableCellData;
      final o = data.offset + offset;
      final s = child.size;
      context.paintChild(child, o);

      final borderRect = Rect.fromLTWH(o.dx, o.dy, s.width, s.height);
      data.border?.paint(context.canvas, borderRect);

      child = data.nextSibling;
    }
  }

  @override
  void performLayout() {
    const layouter = _performLayoutLayouter;
    _layout = _performLayout(this, firstChild!, constraints, layouter);
    size = constraints.constrain(_layout.totalSize);
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _TableCellData) {
      child.parentData = _TableCellData();
    }
  }

  double _calculateColumnGaps(_TableCellData data) {
    return (data.columnSpan - 1) * columnGap;
  }

  double _calculateRowGaps(_TableCellData data) {
    return (data.rowSpan - 1) * rowGap;
  }

  static _TableRenderLayout _performLayout(
    _TableRenderObject tro,
    RenderBox firstChild,
    BoxConstraints constraints,
    Size Function(RenderBox renderBox, BoxConstraints constraints) layouter,
  ) {
    final children = <RenderBox>[];
    final cells = <_TableCellData>[];
    final drySizes = <Size>[];

    RenderBox? child = firstChild;
    var columnCount = 0;
    var rowCount = 0;
    while (child != null) {
      final data = child.parentData! as _TableCellData;
      children.add(child);
      cells.add(data);

      final width = data.width?.clamp(0, constraints.maxWidth);
      if (width != null) {
        drySizes.add(Size(width, .0));
      } else {
        drySizes.add(_performLayoutDry(child, const BoxConstraints()));
      }

      columnCount = max(columnCount, data.columnStart + data.columnSpan);
      rowCount = max(rowCount, data.rowStart + data.rowSpan);

      child = data.nextSibling;
    }

    final columnGaps = (columnCount + 1) * tro.columnGap;
    final dryColumnWidths = List.filled(columnCount, 0.0);
    for (var i = 0; i < children.length; i++) {
      final data = cells[i];
      final drySize = drySizes[i];

      final dryColumnWidth =
          (drySize.width - tro._calculateColumnGaps(data)) / data.columnSpan;

      // distribute cell width across spanned columns
      for (var c = 0; c < data.columnSpan; c++) {
        final column = data.columnStart + c;
        dryColumnWidths[column] = max(dryColumnWidths[column], dryColumnWidth);
      }
    }

    // being naive: take dry widths as render widths
    var columnWidths = [...dryColumnWidths];

    final drySum = dryColumnWidths.sum;
    final dryWidth = tro.paddingLeft + drySum + columnGaps + tro.paddingRight;
    if (constraints.hasBoundedWidth && dryWidth > constraints.maxWidth) {
      // viewport is too small: re-calculate widths using weighted distribution
      // e.g. if a column has huge dry width, it will have bigger width
      final availableWidth = constraints.maxWidth - (dryWidth - drySum);
      columnWidths = dryColumnWidths
          .map((dryColumnWidth) => dryColumnWidth / drySum * availableWidth)
          .toList(growable: false);

      // calculate minimum widths and make sure we allocate enough room
      for (var i = 0; i < children.length; i++) {
        final child = children[i];
        final data = cells[i];
        final drySize = drySizes[i];

        final columnGaps = tro._calculateColumnGaps(data);
        final dryColumnWidth = (drySize.width - columnGaps) / data.columnSpan;
        var columnWidthSmallerThanDry = false;
        for (var c = 0; c < data.columnSpan; c++) {
          final column = data.columnStart + c;
          if (columnWidths[column] < dryColumnWidth) {
            columnWidthSmallerThanDry = true;
            break;
          }
        }

        if (columnWidthSmallerThanDry) {
          // this call is expensive, we try to avoid it as much as possible
          final minWidth = child.getMinIntrinsicWidth(double.infinity);
          final minColumnWidth = (minWidth - columnGaps) / data.columnSpan;

          for (var c = 0; c < data.columnSpan; c++) {
            final column = data.columnStart + c;
            columnWidths[column] = max(columnWidths[column], minColumnWidth);
          }
        }
      }
    }

    final rowGaps = (rowCount + 1) * tro.rowGap;
    final childSizes = List.filled(children.length, Size.zero);
    final rowHeights = List.filled(rowCount, 0.0);
    for (var i = 0; i < children.length; i++) {
      final child = children[i];
      final data = cells[i];
      final drySize = drySizes[i];

      final childWidth = data.calculateWidth(tro, columnWidths);
      final childSize = childWidth == drySize.width &&
              drySize.height > 0 &&
              identical(layouter, _performLayoutDry)
          ? drySize
          : layouter(child, BoxConstraints.tightFor(width: childWidth));
      childSizes[i] = childSize;

      // distribute cell height across spanned rows
      final rowHeight =
          (childSize.height - tro._calculateRowGaps(data)) / data.rowSpan;
      for (var r = 0; r < data.rowSpan; r++) {
        final row = data.rowStart + r;
        rowHeights[row] = max(rowHeights[row], rowHeight);
      }
    }

    // we now know all the widths and heights, let's position cells
    // sometime we have to relayout child, e.g. stretch its height for rowspan
    var captionHeight = .0;
    final calculatedHeight =
        tro.paddingTop + rowHeights.sum + rowGaps + tro.paddingBottom;
    final constraintedHeight = constraints.constrainHeight(calculatedHeight);
    final deltaHeight =
        max(0, (constraintedHeight - calculatedHeight) / rowCount);
    final calculatedWidth =
        tro.paddingLeft + columnWidths.sum + columnGaps + tro.paddingRight;
    for (var i = 0; i < children.length; i++) {
      final child = children[i];
      final data = cells[i];
      var childSize = childSizes[i];

      var childHeight = data.calculateHeight(tro, rowHeights) + deltaHeight;
      var childWidth = data.calculateWidth(tro, columnWidths);
      if (childSize.height != childHeight) {
        final cc2 = BoxConstraints.tight(Size(childWidth, childHeight));
        childSize = layouter(child, cc2);
        childHeight = childSize.height;
        childWidth = childSize.width;
      }

      final calculatedY = data.calculateY(tro, rowHeights);
      if (child.hasSize) {
        final calculatedX = data.calculateX(tro, columnWidths);

        double x;
        switch (tro._textDirection) {
          case TextDirection.ltr:
            x = calculatedX;
            break;
          case TextDirection.rtl:
            x = calculatedWidth - childWidth - calculatedX;
            break;
        }

        data.offset = Offset(x, calculatedY);
      }

      if (data.isCaption) {
        captionHeight = max(captionHeight, calculatedY + childHeight);
      }
    }

    return _TableRenderLayout(
      Rect.fromLTWH(
        0,
        captionHeight,
        calculatedWidth,
        calculatedHeight - captionHeight,
      ),
      Size(calculatedWidth, calculatedHeight),
    );
  }

  static Size _performLayoutDry(
    RenderBox renderBox,
    BoxConstraints constraints,
  ) =>
      renderBox.getDryLayout(constraints);

  static Size _performLayoutLayouter(
    RenderBox renderBox,
    BoxConstraints constraints,
  ) {
    renderBox.layout(constraints, parentUsesSize: true);
    return renderBox.size;
  }
}
