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

  // TODO: remove lint ignore when our minimum Flutter version >= 3.10
  // https://github.com/flutter/flutter/pull/119195
  // https://github.com/flutter/flutter/commit/6a5405925dffb5b4121e1fba898d3d2068dac77c

  /// Creates a TABLE widget.
  // ignore: prefer_const_constructors_in_immutables
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

extension _IterableDoubleList on List<double> {
  void setMaxColumnWidths(
    _TableRenderObject tro,
    _TableCellData data,
    double calculatedWidth,
  ) {
    final columnWidth =
        (calculatedWidth - tro._calculateColumnGaps(data)) / data.columnSpan;
    for (var c = 0; c < data.columnSpan; c++) {
      final column = data.columnStart + c;

      // make sure each column has enough width for the child
      // oversimplified: the colspan splits its columns evenly
      this[column] = max(this[column], columnWidth);
    }
  }

  double sumRange(_TableCellData data) =>
      getRange(data.columnStart, data.columnStart + data.columnSpan).sum;
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

class _TableRenderLayouter {
  final BoxConstraints constraints;
  final Size Function(RenderBox renderBox, BoxConstraints constraints) layouter;
  final _TableRenderObject tro;

  final List<_TableCellData> cells = [];
  final List<RenderBox> children = [];
  final List<Size> drySizes = [];

  double captionHeight = .0;
  int columnCount = 0;
  int rowCount = 0;

  _TableRenderLayouter(this.tro, this.constraints)
      : layouter = performLayoutLayout;

  _TableRenderLayouter.dry(this.tro, this.constraints)
      : layouter = performLayoutGetDryLayout;

  _TableRenderLayout layout(RenderBox firstChild) {
    step1GuessDrySizes(firstChild);

    final columnGapsSum = (columnCount + 1) * tro.columnGap;
    final gapsAndPaddings = tro.paddingLeft + columnGapsSum + tro.paddingRight;
    final availableWidth = constraints.maxWidth - gapsAndPaddings;
    final dryColumnWidths = step2DryColumnWidths();

    final columnWidths = step3ColumnWiths(availableWidth, dryColumnWidths);

    final childSizes = List.filled(children.length, Size.zero);
    final rowHeights = List.filled(rowCount, .0);
    step4ChildSizesAndRowHeights(columnWidths, childSizes, rowHeights);

    return step5CalculateChildrenOffsetMaybeRelayout(
      childSizes,
      columnWidths,
      rowHeights,
    );
  }

  void step1GuessDrySizes(RenderBox firstChild) {
    RenderBox? child = firstChild;
    while (child != null) {
      final data = child.parentData! as _TableCellData;
      children.add(child);
      cells.add(data);

      Size drySize;
      final width = data.width?.clamp(0, constraints.maxWidth);
      if (width != null) {
        drySize = Size(width, .0);
      } else {
        drySize =
            Size(constraints.hasBoundedWidth ? constraints.maxWidth : 100.0, 0);
        try {
          drySize = performLayoutGetDryLayout(child, const BoxConstraints());
        } catch (dryLayoutError, stackTrace) {
          debugPrint('Ignored _performLayoutDry error: '
              '$dryLayoutError\n$stackTrace');
        }
      }
      drySizes.add(drySize);

      columnCount = max(columnCount, data.columnStart + data.columnSpan);
      rowCount = max(rowCount, data.rowStart + data.rowSpan);

      child = data.nextSibling;
    }
  }

  List<double> step2DryColumnWidths() {
    final dryColumnWidths = List.filled(columnCount, .0);
    for (var i = 0; i < children.length; i++) {
      final data = children[i].parentData! as _TableCellData;
      final drySize = drySizes[i];
      dryColumnWidths.setMaxColumnWidths(tro, data, drySize.width);
    }

    return dryColumnWidths;
  }

  List<double> step3ColumnWiths(
    double availableWidth,
    List<double> dryColumnWidths,
  ) {
    // being naive: take dry widths as render widths
    var columnWidths = [...dryColumnWidths];
    if (availableWidth.isInfinite || dryColumnWidths.sum <= availableWidth) {
      return columnWidths;
    }

    final minColumnWidths = List.filled(columnCount, 0.0);
    var shouldLoop = true;
    var loopCount = 0;
    while (shouldLoop) {
      shouldLoop = false;

      columnWidths =
          redistributeValues(columnWidths, minColumnWidths, availableWidth);

      for (var i = 0; i < children.length; i++) {
        final child = children[i];
        final data = cells[i];
        final drySize = drySizes[i];

        final dataGaps = tro._calculateColumnGaps(data);
        final inCalculationWidth = columnWidths.sumRange(data) + dataGaps;
        if (drySize.width > inCalculationWidth) {
          double? minWidth;
          try {
            // this call is expensive, we try to avoid it as much as possible
            // width being smaller than dry size means the table is too crowded
            // calculating min to avoid breaking line in the middle of a word
            minWidth = child.getMinIntrinsicWidth(double.infinity);
          } catch (minWidthError, stackTrace) {
            minWidth = drySize.width;
            debugPrint('Ignored getMinIntrinsicWidth error: '
                '$minWidthError\n$stackTrace');
          }

          minColumnWidths.setMaxColumnWidths(tro, data, minWidth);

          // side effect
          // keep track of min width in the array to avoid
          // processing the same child more than once
          drySizes[i] = Size(minWidth, 0);

          // the loop should run at least one more time with new min-width
          shouldLoop = true;
        }
      }

      loopCount++;
      if (loopCount > columnCount) {
        // using column count to stop early, not a typo
        // we don't want to waste too much time in this loop
        // in case the table is extra long with many many rows
        debugPrint('Stopped to avoid infinite loops latest=$columnWidths');
        break;
      }
    }

    return columnWidths;
  }

  void step4ChildSizesAndRowHeights(
    List<double> columnWidths,
    List<Size> childSizes,
    List<double> rowHeights,
  ) {
    for (var i = 0; i < children.length; i++) {
      final child = children[i];
      final data = cells[i];
      final drySize = drySizes[i];

      final childWidth = data.calculateWidth(tro, columnWidths);
      final canUseDrySize = childWidth == drySize.width &&
          drySize.height > 0 &&
          identical(layouter, performLayoutGetDryLayout);
      Size childSize;
      if (canUseDrySize) {
        childSize = drySize;
      } else {
        // side effect
        childSize = layouter(child, BoxConstraints.tightFor(width: childWidth));
      }
      childSizes[i] = childSize;

      // distribute cell height across spanned rows
      final rowHeight =
          (childSize.height - tro._calculateRowGaps(data)) / data.rowSpan;
      for (var r = 0; r < data.rowSpan; r++) {
        final row = data.rowStart + r;
        rowHeights[row] = max(rowHeights[row], rowHeight);
      }
    }
  }

  _TableRenderLayout step5CalculateChildrenOffsetMaybeRelayout(
    List<Size> childSizes,
    List<double> columnWidths,
    List<double> rowHeights,
  ) {
    final columnGapsSum = (columnCount + 1) * tro.columnGap;
    final rowGapsSum = (rowCount + 1) * tro.rowGap;
    final calculatedHeight =
        tro.paddingTop + rowHeights.sum + rowGapsSum + tro.paddingBottom;
    final constraintedHeight = constraints.constrainHeight(calculatedHeight);
    final deltaHeight =
        max(0, (constraintedHeight - calculatedHeight) / rowCount);
    final calculatedWidth =
        tro.paddingLeft + columnWidths.sum + columnGapsSum + tro.paddingRight;
    for (var i = 0; i < children.length; i++) {
      final child = children[i];
      final data = cells[i];
      var childSize = childSizes[i];

      var childHeight = data.calculateHeight(tro, rowHeights) + deltaHeight;
      var childWidth = data.calculateWidth(tro, columnWidths);
      if (childSize.height != childHeight) {
        final cc2 = BoxConstraints.tight(Size(childWidth, childHeight));
        // side effect
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

  static Size performLayoutGetDryLayout(
    RenderBox renderBox,
    BoxConstraints constraints,
  ) =>
      renderBox.getDryLayout(constraints);

  static Size performLayoutLayout(
    RenderBox renderBox,
    BoxConstraints constraints,
  ) {
    renderBox.layout(constraints, parentUsesSize: true);
    return renderBox.size;
  }

  static List<double> redistributeValues(
    List<double> values,
    List<double> calculatedMinValues,
    double available,
  ) {
    final effectiveMinValues = List.filled(values.length, .0);
    for (var i = 0; i < values.length; i++) {
      if (calculatedMinValues[i] > 0 && calculatedMinValues[i] >= values[i]) {
        // min value is smaller than in-calculation width
        // let's keep the current value as long as possible
        // we want the column to grow to its dry size naturally
        effectiveMinValues[i] = calculatedMinValues[i];
      }
    }

    final remaining = max(.0, available - effectiveMinValues.sum);
    var valuesSum = .0;
    for (var i = 0; i < values.length; i++) {
      if (effectiveMinValues[i] == 0) {
        valuesSum += values[i];
      }
    }

    final result = effectiveMinValues.toList(growable: false);
    if (valuesSum > .0) {
      for (var i = 0; i < values.length; i++) {
        if (result[i] == 0) {
          // calculate widths using weighted distribution
          // e.g. if a column has huge dry width, it will have bigger width
          result[i] = values[i] / valuesSum * remaining;
        }
      }
    }

    return result;
  }
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

  double get columnGap {
    final border = _border;
    return border != null && _borderCollapse
        ? (border.left.width * -1.0)
        : _borderSpacing;
  }

  double get paddingBottom => _border?.bottom.width ?? 0.0;

  double get paddingLeft => _border?.left.width ?? 0.0;

  double get paddingRight => _border?.right.width ?? 0.0;

  double get paddingTop => _border?.top.width ?? 0.0;

  double get rowGap {
    final border = _border;
    return border != null && _borderCollapse
        ? (border.top.width * -1.0)
        : _borderSpacing;
  }

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
  Size computeDryLayout(BoxConstraints constraints) {
    final child = firstChild;
    if (child == null) {
      return super.computeDryLayout(constraints);
    }

    final layouter = _TableRenderLayouter.dry(this, constraints);
    return layouter.layout(child).totalSize;
  }

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
    final child = firstChild;
    if (child == null) {
      size = constraints.smallest;
      return;
    }

    final layouter = _TableRenderLayouter(this, constraints);
    _layout = layouter.layout(child);
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
}
