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

  final children = <Widget>[];
  data.visitCells((col, row, widget, colspan, rowspan) {
    children.add(_LayoutGridCell(
      border: border,
      child: widget,
      col: col,
      colspan: colspan,
      row: row,
      rowspan: rowspan,
    ));
  });

  final layoutGrid = LayoutGrid(
    children: children,
    columnGap: (-border.left.width - border.right.width) / 2,
    gridFit: GridFit.passthrough,
    rowGap: (-border.top.width - border.bottom.width) / 2,
    templateColumnSizes: templateColumnSizes,
    templateRowSizes: templateRowSizes,
  );

  if (border == null) return layoutGrid;

  return wf.buildStack(meta, tsh, <Widget>[
    layoutGrid,
    Positioned.fill(child: Container(decoration: BoxDecoration(border: border)))
  ]);
}

class _LayoutGridCell extends StatelessWidget {
  final Border border;
  final Widget child;
  final int col;
  final int colspan;
  final int row;
  final int rowspan;

  const _LayoutGridCell({
    Key key,
    this.border,
    this.child,
    this.col,
    this.colspan,
    this.row,
    this.rowspan,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget built = SizedBox.expand(child: child);

    if (border != null) {
      built = Container(
        child: built,
        decoration: BoxDecoration(border: border),
      );
    }

    return GridPlacement(
      child: built,
      columnStart: col,
      columnSpan: colspan,
      rowStart: row,
      rowSpan: rowspan,
    );
  }
}
