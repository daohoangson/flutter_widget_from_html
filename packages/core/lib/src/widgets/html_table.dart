import 'dart:math';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';

import 'css_sizing.dart';

final _logger = Logger('fwfh.HtmlTable');

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
  // TODO: remove lint ignore when our minimum Flutter version >= 3.10
  // ignore: prefer_const_constructors_in_immutables
  HtmlTable({
    this.border,
    this.borderCollapse = false,
    this.borderSpacing = 0.0,
    required super.children,
    this.textDirection = TextDirection.ltr,
    super.key,
  });

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
    required super.child,
    required super.columnSpan,
    required int rowIndex,
    super.key,
  }) : super._(
          columnStart: 0,
          isCaption: true,
          rowStart: rowIndex,
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
    required super.child,
    this.columnSpan = 1,
    required this.columnStart,
    bool isCaption = false,
    super.key,
    this.rowSpan = 1,
    required this.rowStart,
    this.width,
  })  : assert(columnSpan >= 1),
        assert(columnStart >= 0),
        assert(rowSpan >= 1),
        assert(rowStart >= 0),
        _isCaption = isCaption;

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
    properties.add(DiagnosticsProperty('width', width, defaultValue: null));
  }

  @override
  Type get debugTypicalAncestorWidgetClass => HtmlTable;
}

extension on Iterable<double> {
  double get sum => isEmpty ? 0.0 : reduce(_sum);

  Iterable<double> get zeros => where((v) => v.isZero);

  static double _sum(double value, double element) => value + element;
}

extension on double {
  bool get isZero {
    const epsilon = .01;
    return this <= epsilon;
  }
}

extension on List<double> {
  void setMaxColumnWidths(
    _TableRenderObject tro,
    _TableCellData data,
    double calculatedWidth,
  ) {
    final columnWidth = calculatedWidth.isNaN
        ? double.nan
        : ((calculatedWidth - tro._calculateColumnGaps(data)) /
            data.columnSpan);
    for (var c = 0; c < data.columnSpan; c++) {
      final column = data.columnStart + c;

      if (columnWidth.isNaN) {
        if (this[column].isZero) {
          this[column] = columnWidth;
        }
      } else {
        // make sure each column has enough width for the child
        // oversimplified: the colspan splits its columns evenly
        this[column] = max(this[column], columnWidth);
      }
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
  final ChildLayouter layouter;
  final _TableRenderObject tro;

  _TableRenderLayouter(this.tro, this.constraints)
      : layouter = ChildLayoutHelper.layoutChild;

  _TableRenderLayouter.dry(this.tro, this.constraints)
      : layouter = ChildLayoutHelper.dryLayoutChild;

  _TableRenderLayout compute(RenderBox? firstChild) {
    if (firstChild == null) {
      return _TableRenderLayout(Rect.zero, constraints.smallest);
    }

    final step1 = step1Prepare(firstChild);
    final step2 = step2NaiveColumnWidths(step1);
    final step3 = step3MinIntrinsicWidth(step2);
    final step4 = step4ChildSizesAndRowHeights(step3);
    return step5CalculateChildrenOffsetMaybeRelayout(step4);
  }

  _TableDataStep1 step1Prepare(RenderBox firstChild) {
    final cells = <_TableCellData>[];
    final children = <RenderBox>[];
    int columnCount = 0;
    int rowCount = 0;
    RenderBox? child = firstChild;
    while (child != null) {
      final data = child.parentData! as _TableCellData;
      children.add(child);
      cells.add(data);

      columnCount = max(columnCount, data.columnStart + data.columnSpan);
      rowCount = max(rowCount, data.rowStart + data.rowSpan);

      child = data.nextSibling;
    }

    // calculate the available width if possible
    // this may be null if table is inside a horizontal scroll view
    double? availableWidth;
    if (constraints.hasBoundedWidth) {
      final columnGapsSum = (columnCount + 1) * tro.columnGap;
      final gapsAndPaddings =
          tro.paddingLeft + columnGapsSum + tro.paddingRight;
      availableWidth = constraints.maxWidth - gapsAndPaddings;
    }

    return _TableDataStep1(
      availableWidth: availableWidth,
      cells: cells,
      children: children,
      columnCount: columnCount,
      rowCount: rowCount,
    );
  }

  _TableDataStep2 step2NaiveColumnWidths(_TableDataStep1 step1) {
    final cells = step1.cells;
    final cellWidths = cells.map((cell) {
      // use width from cell attribute if it is some sensible value
      // otherwise, ignore and measure via layouter for real
      final cellWidth = cell.width?.clamp(0, constraints.maxWidth);
      return cellWidth?.isFinite == true ? cellWidth : null;
    }).toList(growable: false);

    final naiveColumnWidths = List.filled(step1.columnCount, .0);
    for (var i = 0; i < cells.length; i++) {
      final data = cells[i];
      final cellWidth = cellWidths[i];
      if (cellWidth != null) {
        naiveColumnWidths.setMaxColumnWidths(tro, data, cellWidth);
      }
    }

    return _TableDataStep2(
      step1,
      cellWidths: cellWidths,
      naiveColumnWidths: naiveColumnWidths
          .map<double?>((v) => !v.isZero ? v : null)
          .toList(growable: false),
    );
  }

  _TableDataStep3 step3MinIntrinsicWidth(_TableDataStep2 step2) {
    final step1 = step2.step1;
    final availableWidth = step1.availableWidth;
    final cells = step1.cells;
    final children = step1.children;
    final naiveColumnWidths = step2.naiveColumnWidths;

    final childMinWidths = List<double?>.filled(children.length, null);
    final cellSizes = List<Size?>.filled(children.length, null);
    final maxColumnWidths = naiveColumnWidths.map((v) => v ?? .0).toList();
    final minColumnWidths = List.filled(step1.columnCount, .0);

    // prioritize naive value, then layouter value as column width
    var columnWidths = maxColumnWidths;
    if (columnWidths.zeros.isEmpty &&
        (availableWidth == null || columnWidths.sum <= availableWidth)) {
      return _TableDataStep3(
        step2,
        cellSizes: cellSizes,
        columnWidths: columnWidths,
      );
    }

    var shouldLoop = true;
    var loopCount = 0;
    while (shouldLoop) {
      shouldLoop = false;

      if (availableWidth != null) {
        columnWidths = redistributeValues(
          available: availableWidth,
          maxValues: maxColumnWidths,
          minValues: minColumnWidths,
        );
      }

      for (var i = 0; i < children.length; i++) {
        if (childMinWidths[i] != null) {
          // this child has been measured already
          continue;
        }

        final child = children[i];
        final data = cells[i];

        var childWidth = step2.cellWidths[i] ?? cellSizes[i]?.width;
        if (childWidth == null) {
          // side effect
          // no pre-configured width to use
          // have to layout cells without constraints for the initial width
          final layoutSize = layouter(child, const BoxConstraints());
          cellSizes[i] = layoutSize;
          childWidth = layoutSize.width;
          maxColumnWidths.setMaxColumnWidths(tro, data, childWidth);
          _logger.fine('Got child#$i size without contraints: $layoutSize');
        }

        final childMinWidth = step3GetMinIntrinsicWidth(
          step2,
          child: child,
          data: data,
          columnWidths: columnWidths,
          maxColumnWidths: maxColumnWidths,
        );
        if (childMinWidth != null) {
          childMinWidths[i] = childMinWidth;
          minColumnWidths.setMaxColumnWidths(tro, data, childMinWidth);
          _logger.info('Got child#$i min width: $childMinWidth');

          // the loop should run at least one more time with new min-width
          shouldLoop = true;
        }
      }

      loopCount++;
      if (loopCount > step1.columnCount) {
        // using column count to stop early, not a typo
        // we don't want to waste too much time in this loop
        // in case the table is extra long with many many rows
        _logger.info('Finished measuring children x$loopCount');
        break;
      }
    }

    return _TableDataStep3(
      step2,
      cellSizes: cellSizes,
      columnWidths: columnWidths,
    );
  }

  double? step3GetMinIntrinsicWidth(
    _TableDataStep2 step2, {
    required RenderBox child,
    required _TableCellData data,
    required List<double> columnWidths,
    required List<double> maxColumnWidths,
  }) {
    final step1 = step2.step1;
    final availableWidth = step1.availableWidth;

    final widthSum = columnWidths.sumRange(data);
    final maxWidthSum = maxColumnWidths.sumRange(data);
    if (widthSum >= maxWidthSum) {
      // cell has more than requested width
      // skip measuring if not absolutely needed because it's expensive

      if (availableWidth == null) {
        // unlimited available space
        return null;
      }

      if (columnWidths.sum <= availableWidth) {
        // current widths are good enough
        return null;
      }
    }

    try {
      // table is too crowded
      // get min width to avoid breaking line in the middle of a word
      return child.getMinIntrinsicWidth(double.infinity);
    } catch (error, stackTrace) {
      // TODO: render horizontal scroll view
      const message = "Could not measure child's min intrinsic width";
      _logger.warning(message, error, stackTrace);
      return double.nan;
    }
  }

  _TableDataStep4 step4ChildSizesAndRowHeights(_TableDataStep3 step3) {
    final step2 = step3.step2;
    final step1 = step2.step1;
    final cellSizes = step3.cellSizes;
    final cells = step1.cells;
    final children = step1.children;

    final childSizes = List.generate(
      cellSizes.length,
      (i) => cellSizes[i] ?? Size.zero,
    );
    final rowHeights = List.filled(step1.rowCount, .0);

    for (var i = 0; i < children.length; i++) {
      final child = children[i];
      final data = cells[i];
      final cellSize = cellSizes[i];

      final childWidth = data.calculateWidth(tro, step3.columnWidths);
      Size childSize;
      if (cellSize != null && cellSize.width == childWidth) {
        childSize = cellSize;
      } else {
        // side effect
        // layout with tight constraints to get the expected width
        childSize = layouter(child, BoxConstraints.tightFor(width: childWidth));
        _logger.fine('Got child#$i size with width=$childWidth: $childSize');
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

    return _TableDataStep4(
      step3,
      childSizes: childSizes,
      rowHeights: rowHeights,
    );
  }

  _TableRenderLayout step5CalculateChildrenOffsetMaybeRelayout(
    _TableDataStep4 step4,
  ) {
    final step3 = step4.step3;
    final step2 = step3.step2;
    final step1 = step2.step1;
    final cells = step1.cells;
    final children = step1.children;

    final columnGapsSum = (step1.columnCount + 1) * tro.columnGap;
    final rowGapsSum = (step1.rowCount + 1) * tro.rowGap;
    final calculatedHeight =
        tro.paddingTop + step4.rowHeights.sum + rowGapsSum + tro.paddingBottom;
    final constraintedHeight = constraints.constrainHeight(calculatedHeight);
    final deltaHeight =
        max(0, (constraintedHeight - calculatedHeight) / step1.rowCount);
    final calculatedWidth = tro.paddingLeft +
        step3.columnWidths.sum +
        columnGapsSum +
        tro.paddingRight;

    var captionHeight = .0;

    for (var i = 0; i < children.length; i++) {
      final child = children[i];
      final data = cells[i];
      var childSize = step4.childSizes[i];

      var childHeight =
          data.calculateHeight(tro, step4.rowHeights) + deltaHeight;
      var childWidth = data.calculateWidth(tro, step3.columnWidths);
      if (childSize.height != childHeight) {
        final cc2 = BoxConstraints.tight(Size(childWidth, childHeight));
        // side effect
        childSize = layouter(child, cc2);
        childHeight = childSize.height;
        childWidth = childSize.width;
        _logger.fine('Laid out child#$i at ${childWidth}x$childHeight');
      }

      final calculatedY = data.calculateY(tro, step4.rowHeights);
      if (child.hasSize) {
        final calculatedX = data.calculateX(tro, step3.columnWidths);

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

  static List<double> redistributeValues({
    required double available,
    required List<double> maxValues,
    required List<double> minValues,
  }) {
    final fair = available / minValues.length;
    final result = minValues
        // minimum may be NaN if there were an error during measurement
        .map((minValue) => minValue.isNaN ? fair : minValue)
        .toList(growable: false);
    final remaining = max(.0, available - result.sum);
    if (remaining.isZero) {
      // nothing left to redistribute
      return result;
    }

    final dirties = List.filled(result.length, .0);
    for (var i = 0; i < result.length; i++) {
      dirties[i] = max(.0, maxValues[i] - result[i]);
    }
    final dirtySum = dirties.sum;
    if (dirtySum.isZero) {
      // no dirty value that needs adjusting
      return result;
    }

    for (var i = 0; i < dirties.length; i++) {
      if (dirties[i].isZero) {
        continue;
      }

      // calculate delta using weighted distribution
      // e.g. if a value has larger difference, it will grow more
      final delta = dirties[i] / dirtySum * remaining;
      result[i] = min(maxValues[i], result[i] + delta);
    }

    return result;
  }
}

@immutable
class _TableDataStep1 {
  final double? availableWidth;
  final List<_TableCellData> cells;
  final List<RenderBox> children;
  final int columnCount;
  final int rowCount;

  const _TableDataStep1({
    this.availableWidth,
    required this.cells,
    required this.children,
    required this.columnCount,
    required this.rowCount,
  });
}

@immutable
class _TableDataStep2 {
  final _TableDataStep1 step1;

  final List<double?> cellWidths;
  final List<double?> naiveColumnWidths;

  const _TableDataStep2(
    this.step1, {
    required this.cellWidths,
    required this.naiveColumnWidths,
  });
}

@immutable
class _TableDataStep3 {
  final _TableDataStep2 step2;

  final List<Size?> cellSizes;
  final List<double> columnWidths;

  const _TableDataStep3(
    this.step2, {
    required this.cellSizes,
    required this.columnWidths,
  });
}

@immutable
class _TableDataStep4 {
  final _TableDataStep3 step3;

  final List<Size> childSizes;
  final List<double> rowHeights;

  const _TableDataStep4(
    this.step3, {
    required this.childSizes,
    required this.rowHeights,
  });
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
  Size computeDryLayout(BoxConstraints constraints) =>
      _TableRenderLayouter.dry(this, constraints).compute(firstChild).totalSize;

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
    final layouter = _TableRenderLayouter(this, constraints);
    _layout = layouter.compute(firstChild);
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
