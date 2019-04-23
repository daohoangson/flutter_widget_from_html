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

  TagTable(this.wf);

  BuildOp get buildOp => BuildOp(
        collectMetadata: (meta) {
          if (meta.buildOpElement.localName == kTagTableHeader) {
            meta.fontWeight ??= FontWeight.bold;
          }
        },
        onWidgets: (meta, widgets) {
          switch (meta.buildOpElement.localName) {
            case kTagTable:
              return _buildTable(meta, widgets);
            case kTagTableCell:
            case kTagTableHeader:
              return wf.buildColumn(widgets);
            case kTagTableRow:
              return _RowWidget(widgets.map((w) => _wrapCell(w)));
          }

          return Container();
        },
        priority: 100,
      );

  Widget _buildTable(NodeMetadata meta, Iterable<Widget> children) {
    final rowWidgets = <_RowWidget>[];
    children.forEach((c) => (c is _RowWidget ? rowWidgets.add(c) : null));

    // first pass to find number of columns
    int cols = 0;
    rowWidgets.forEach((rw) => cols = cols > rw.cols ? cols : rw.cols);

    final rows = rowWidgets.map((rw) {
      final cells = rw.cells.toList();
      while (cells.length < cols) cells.add(wf.buildTableCell(Container()));
      return TableRow(children: cells);
    });

    return wf.buildTable(rows.toList(), border: _buildTableBorder(meta));
  }

  Widget _wrapCell(Widget widget) =>
      widget is TableCell ? widget : wf.buildTableCell(widget);
}

class _RowWidget extends StatelessWidget {
  final Iterable<TableCell> cells;
  int get cols => cells.length;

  _RowWidget(this.cells);

  @override
  Widget build(BuildContext context) => null;
}

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
