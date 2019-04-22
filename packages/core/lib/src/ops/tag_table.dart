import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart'
    show BuildOp, NodeMetadata, attrStyleLoop, borderParseAll;

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
            return buildTable(meta, widgets);
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

  Widget buildTable(NodeMetadata meta, List<Widget> children) {
    final rowWidgets = <_TableRowWidget>[];
    children.forEach((c) => (c is _TableRowWidget ? rowWidgets.add(c) : null));

    // first pass to find number of columns
    int cols = 0;
    rowWidgets.forEach((rw) => cols = cols > rw.cols ? cols : rw.cols);

    final rows = <TableRow>[];
    rowWidgets.forEach((rw) {
      final cells = rw.cells.toList();
      while (cells.length < cols) {
        cells.add(buildTableCell());
      }

      rows.add(TableRow(children: cells));
    });

    return Table(
      border: _buildTableBorder(meta),
      children: rows,
    );
  }

  Widget buildTableCell({Widget child}) =>
      TableCell(child: child ?? Container());

  Widget buildTableRow(List<Widget> children) => _TableRowWidget(
        children.map((c) => c is TableCell ? c : buildTableCell(child: c)),
      );

  TableBorder _buildTableBorder(NodeMetadata meta) {
    final e = meta.buildOpElement;

    String styleBorder;
    attrStyleLoop(e, (k, v) => k == 'border' ? styleBorder = v : null);
    if (styleBorder != null) {
      final borderParsed = borderParseAll(styleBorder);
      if (borderParsed != null) {
        return TableBorder.all(
          color: borderParsed.color ?? const Color(0xFF000000),
          width: borderParsed.width,
        );
      }
    }

    if (e.attributes.containsKey('border')) {
      final width = double.tryParse(e.attributes['border']);
      if (width != null && width > 0) {
        return TableBorder.all(width: width);
      }
    }

    return null;
  }
}

class _TableRowWidget extends StatelessWidget {
  final Iterable<TableCell> cells;
  int get cols => cells.length;

  _TableRowWidget(this.cells);

  @override
  Widget build(BuildContext context) => null;
}
