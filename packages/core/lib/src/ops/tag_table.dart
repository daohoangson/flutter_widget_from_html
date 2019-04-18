import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;

import '../core_wf.dart';

const kTagTable = 'table';
const kTagTableCell = 'td';
const kTagTableHeader = 'th';
const kTagTableRow = 'tr';

class TagTable {
  final dom.Element e;
  final WidgetFactory wf;

  TagTable(this.e, this.wf);

  Widget build(List<Widget> children) {
    switch (e.localName) {
      case kTagTable:
        return buildTable(children);
      case kTagTableRow:
        return buildTableRow(children);
    }

    return Container();
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
      final cells = rw.cells;
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
      children.map<TableCell>((c) => buildTableCell(child: c)).toList());
}

class _TableRowWidget extends StatelessWidget {
  final List<TableCell> cells;
  int get cols => cells.length;

  _TableRowWidget(this.cells);

  @override
  Widget build(BuildContext context) => null;
}
