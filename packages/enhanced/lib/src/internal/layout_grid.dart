import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

Widget buildTableWithLayoutGrid(WidgetFactory wf, BuildMetadata meta,
    TextStyleHtml tsh, TableMetadata data) {
  final cols = data.cols;
  if (cols == 0) return null;
  final templateColumnSizes = List<TrackSize>(cols);
  for (var c = 0; c < cols; c++) {
    templateColumnSizes[c] = FlexibleTrackSize(1);
  }

  final rows = data.rows;
  if (rows == 0) return null;
  final templateRowSizes = List<TrackSize>(rows);
  for (var r = 0; r < rows; r++) {
    templateRowSizes[r] = IntrinsicContentTrackSize();
  }

  final border =
      data.border != null ? Border.fromBorderSide(data.border) : null;
  final columnGap =
      ((border?.left?.width ?? 0.0) + (border?.right?.width ?? 0.0)) / -2;
  final rowGap =
      ((border?.top?.width ?? 0.0) + (border?.bottom?.width ?? 0.0)) / -2;

  final children = <Widget>[];
  data.visitCells((col, row, widget, colspan, rowspan) {
    Widget built = SizedBox.expand(child: widget);

    if (border != null) {
      built = DecoratedBox(
        child: built,
        decoration: BoxDecoration(border: border),
      );

      if (colspan > 1 || rowspan > 1) {
        // the size buffer is required because
        // LayoutGrid will calculate extra width/height using negative gap values
        // making the allocated size not big enough to fit everything
        built = _LayoutGridSizeBuffer(
          child: built,
          heightDelta:
              ((border.top?.width ?? 0.0) + (border.bottom?.width ?? 0.0)) *
                  (rowspan - 1),
          widthDelta:
              ((border.left?.width ?? 0.0) + (border.right?.width ?? 0.0)) *
                  (colspan - 1),
        );
      }
    }

    children.add(built.withGridPlacement(
      columnStart: col,
      columnSpan: colspan,
      rowStart: row,
      rowSpan: rowspan,
    ));
  });

  final layoutGrid = LayoutGrid(
    children: children,
    columnGap: columnGap,
    gridFit: GridFit.passthrough,
    rowGap: rowGap,
    templateColumnSizes: templateColumnSizes,
    templateRowSizes: templateRowSizes,
  );

  if (border == null) return layoutGrid;

  return wf.buildStack(meta, tsh, <Widget>[
    layoutGrid,
    Positioned.fill(
      child: DecoratedBox(decoration: BoxDecoration(border: border)),
    )
  ]);
}

class _LayoutGridSizeBuffer extends SingleChildRenderObjectWidget {
  final double heightDelta;
  final double widthDelta;

  const _LayoutGridSizeBuffer({
    Widget child,
    @required this.heightDelta,
    Key key,
    @required this.widthDelta,
  }) : super(child: child, key: key);

  @override
  _RenderSizeBuffer createRenderObject(BuildContext _) =>
      _RenderSizeBuffer(heightDelta, widthDelta);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('heightDelta', heightDelta));
    properties.add(DoubleProperty('widthDelta', widthDelta));
  }

  @override
  void updateRenderObject(BuildContext _, _RenderSizeBuffer renderObject) {
    renderObject.heightDelta = heightDelta;
    renderObject.widthDelta = widthDelta;
  }
}

class _RenderSizeBuffer extends RenderProxyBox {
  _RenderSizeBuffer(this._heightDelta, this._widthDelta);

  double _heightDelta;
  set heightDelta(double value) {
    if (value == _heightDelta) return;
    _heightDelta = value;
    markNeedsLayout();
  }

  double _widthDelta;
  set widthDelta(double value) {
    if (value == _widthDelta) return;
    _widthDelta = value;
    markNeedsLayout();
  }

  @override
  double computeMaxIntrinsicHeight(double width) =>
      (child?.computeMaxIntrinsicHeight(width) ?? 0.0) + _heightDelta;

  @override
  double computeMaxIntrinsicWidth(double height) =>
      (child?.computeMaxIntrinsicWidth(height) ?? 0.0) + _widthDelta;

  @override
  void performLayout() {
    if (child != null) {
      child.layout(constraints, parentUsesSize: true);
      size = child.size;
    } else {
      performResize();
    }
  }
}
