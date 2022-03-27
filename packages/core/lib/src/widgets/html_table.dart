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

  /// The companion data for table.

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
      ..border = border
      ..borderCollapse = borderCollapse
      ..borderSpacing = borderSpacing
      ..textDirection = textDirection;
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

/// A `valign=baseline` widget.
class HtmlTableValignBaseline extends SingleChildRenderObjectWidget {
  /// Creates a `valign=baseline` widget.
  const HtmlTableValignBaseline({Widget? child, Key? key})
      : super(child: child, key: key);

  @override
  RenderObject createRenderObject(BuildContext context) {
    final table = context.findAncestorRenderObjectOfType<_TableRenderObject>()!;
    final cell = context.findAncestorWidgetOfExactType<HtmlTableCell>()!;
    return _ValignBaselineRenderObject(table._tableRenderData, cell.rowStart);
  }

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    final table = context.findAncestorRenderObjectOfType<_TableRenderObject>()!;
    final cell = context.findAncestorWidgetOfExactType<HtmlTableCell>()!;
    (renderObject as _ValignBaselineRenderObject)
      ..tableRenderData = table._tableRenderData
      ..row = cell.rowStart;
  }
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

class _TableRenderData {
  final baselines = <int, List<_ValignBaselineRenderObject>>{};

  // TODO: remove lint ignore
  // ignore: type_annotate_public_apis
  var layout = _TableRenderLayout.zero;
}

class _TableRenderLayout {
  final Rect cellRect;
  final Size totalSize;

  const _TableRenderLayout({
    required this.cellRect,
    required this.totalSize,
  });

  static const _TableRenderLayout zero = _TableRenderLayout(
    cellRect: Rect.zero,
    totalSize: Size.zero,
  );
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

  final _tableRenderData = _TableRenderData();

  Border? _border;
  // ignore: avoid_setters_without_getters
  set border(Border? v) {
    if (v == _border) {
      return;
    }

    _border = v;
    markNeedsLayout();
  }

  bool _borderCollapse;
  // ignore: avoid_setters_without_getters
  set borderCollapse(bool v) {
    if (v == _borderCollapse) {
      return;
    }

    _borderCollapse = v;
    markNeedsLayout();
  }

  double _borderSpacing;
  // ignore: avoid_setters_without_getters
  set borderSpacing(double v) {
    if (v == _borderSpacing) {
      return;
    }

    _borderSpacing = v;
    markNeedsLayout();
  }

  TextDirection _textDirection;
  // ignore: avoid_setters_without_getters
  set textDirection(TextDirection v) {
    if (v == _textDirection) {
      return;
    }

    _textDirection = v;
    markNeedsLayout();
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
    _tableRenderData.baselines.clear();

    final cellRect = _tableRenderData.layout.cellRect;
    if (!cellRect.isEmpty) {
      _border?.paint(
        context.canvas,
        cellRect.shift(offset),
      );
    }

    var child = firstChild;
    while (child != null) {
      final data = child.parentData! as _TableCellData;
      final childOffset = data.offset + offset;
      final childSize = child.size;
      context.paintChild(child, childOffset);

      data.border?.paint(
        context.canvas,
        Rect.fromLTWH(
          childOffset.dx,
          childOffset.dy,
          childSize.width,
          childSize.height,
        ),
      );

      child = data.nextSibling;
    }
  }

  @override
  void performLayout() {
    final layout = _tableRenderData.layout =
        _performLayout(this, firstChild!, constraints, _performLayoutLayouter);
    size = constraints.constrain(layout.totalSize);
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
    final _TableRenderObject tro,
    final RenderBox firstChild,
    final BoxConstraints constraints,
    final Size Function(RenderBox renderBox, BoxConstraints constraints)
        layouter,
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

        // TODO: use `late final` when https://github.com/dart-lang/coverage/issues/341 is fixed
        late double x;
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
      cellRect: Rect.fromLTWH(
        0,
        captionHeight,
        calculatedWidth,
        calculatedHeight - captionHeight,
      ),
      totalSize: Size(calculatedWidth, calculatedHeight),
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

class _ValignBaselineRenderObject extends RenderProxyBox {
  _ValignBaselineRenderObject(this._tableRenderData, this._row);

  _TableRenderData _tableRenderData;
  // ignore: avoid_setters_without_getters
  set tableRenderData(_TableRenderData v) {
    if (v == _tableRenderData) {
      return;
    }
    _tableRenderData = v;
    markNeedsLayout();
  }

  int _row;
  // ignore: avoid_setters_without_getters
  set row(int v) {
    if (v == _row) {
      return;
    }
    _row = v;
    markNeedsLayout();
  }

  double? _baselineWithOffset;
  var _paddingTop = 0.0;

  @override
  Size computeDryLayout(BoxConstraints constraints) =>
      _performLayout(child, _paddingTop, constraints, _performLayoutDry);

  @override
  void paint(PaintingContext context, Offset offset) {
    final effectiveOffset = offset.translate(0, _paddingTop);

    final child = this.child;
    if (child == null) {
      return;
    }

    final baselineWithOffset = _baselineWithOffset = effectiveOffset.dy +
        (child.getDistanceToBaseline(TextBaseline.alphabetic) ?? 0.0);

    final siblings = _tableRenderData.baselines;
    if (siblings.containsKey(_row)) {
      final rowBaseline = siblings[_row]!
          .map((e) => e._baselineWithOffset!)
          .reduce((v, e) => max(v, e));
      siblings[_row]!.add(this);

      if (rowBaseline > baselineWithOffset) {
        final offsetY = rowBaseline - baselineWithOffset;
        if (size.height - child.size.height >= offsetY) {
          // paint child with additional offset
          context.paintChild(child, effectiveOffset.translate(0, offsetY));
          return;
        } else {
          // skip painting this frame, wait for the correct padding
          _paddingTop += offsetY;
          _baselineWithOffset = rowBaseline;
          WidgetsBinding.instance
              ?.addPostFrameCallback((_) => markNeedsLayout());
          return;
        }
      } else if (rowBaseline < baselineWithOffset) {
        for (final sibling in siblings[_row]!) {
          if (sibling == this) {
            continue;
          }

          final offsetY = baselineWithOffset - sibling._baselineWithOffset!;
          if (offsetY != 0.0) {
            sibling._paddingTop += offsetY;
            sibling._baselineWithOffset = baselineWithOffset;
            WidgetsBinding.instance
                ?.addPostFrameCallback((_) => sibling.markNeedsLayout());
          }
        }
      }
    } else {
      siblings[_row] = [this];
    }

    context.paintChild(child, effectiveOffset);
  }

  @override
  void performLayout() {
    size = _performLayout(
      child,
      _paddingTop,
      constraints,
      _performLayoutLayouter,
    );
  }

  @override
  String toStringShort() => '_ValignBaselineRenderObject(row: $_row)';

  static Size _performLayout(
    final RenderBox? child,
    final double paddingTop,
    final BoxConstraints constraints,
    final Size? Function(RenderBox? renderBox, BoxConstraints constraints)
        layouter,
  ) {
    final cc = constraints.loosen().deflate(EdgeInsets.only(top: paddingTop));
    final childSize = layouter(child, cc) ?? Size.zero;
    return constraints.constrain(childSize + Offset(0, paddingTop));
  }

  static Size? _performLayoutDry(
    RenderBox? renderBox,
    BoxConstraints constraints,
  ) =>
      renderBox?.getDryLayout(constraints);

  static Size? _performLayoutLayouter(
    RenderBox? renderBox,
    BoxConstraints constraints,
  ) {
    renderBox?.layout(constraints, parentUsesSize: true);
    return renderBox?.size;
  }
}
