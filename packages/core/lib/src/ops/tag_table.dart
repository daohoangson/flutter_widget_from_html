import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart'
    show BuildOp;

import '../core_wf.dart';

const kTagTable = 'table';
const kTagTableCell = 'td';
const kTagTableHeader = 'th';
const kTagTableRow = 'tr';

class TagTable {
  final WidgetFactory wf;

  BuildOp _buildOp;

  TagTable(this.wf);

  BuildOp get buildOp {
    _buildOp ??= BuildOp(
      collectMetadata: (meta) {
        final e = meta.buildOpElement;
        if (e.localName == kTagTableHeader) {
          meta.fontWeight = FontWeight.bold;
        }
      },
      onWidgets: (meta, widgets) {
        final e = meta.buildOpElement;

        switch (e.localName) {
          case kTagTable:
            return buildTable(widgets);
          case kTagTableCell:
          case kTagTableHeader:
            return buildTableCell(child: wf.buildColumn(widgets));
          case kTagTableRow:
            return buildTableRow(widgets);
        }

        return Container();
      },
      priority: 100,
    );

    return _buildOp;
  }

  Widget buildTable(List<Widget> children) {
    final rowWidgets = <_TableRowWidget>[];
    children.forEach((c) => (c is _TableRowWidget ? rowWidgets.add(c) : null));

    // first pass
    int cols = 0;
    rowWidgets.forEach((rw) => cols = cols > rw.cols ? cols : rw.cols);

    // second pass
    final rows = <TableRow>[];
    rowWidgets.forEach((rw) {
      final cells = rw.cells.toList();
      while (cells.length < cols) {
        cells.add(buildTableCell());
      }

      rows.add(TableRow(children: cells));
    });

    return Table(
      border: TableBorder.all(),
      children: rows,
    );
  }

  Widget buildTableCell({Widget child}) =>
      TableCell(child: child ?? Container());

  Widget buildTableRow(List<Widget> children) => _TableRowWidget(
        children.map((c) => c is TableCell ? c : buildTableCell(child: c)),
      );
}

class _TableRowWidget extends StatelessWidget {
  final Iterable<TableCell> cells;
  int get cols => cells.length;

  _TableRowWidget(this.cells);

  @override
  Widget build(BuildContext context) => null;
}
