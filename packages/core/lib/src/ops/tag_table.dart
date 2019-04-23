part of '../core_wf.dart';

const kTagTable = 'table';
const kTagTableCaption = 'caption';
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
        getInlineStyles: (e) {
          if (e.localName == kTagTableCaption) {
            return [kCssTextAlign, kCssTextAlignCenter];
          }
        },
        onWidgets: (meta, widgets) {
          switch (meta.buildOpElement.localName) {
            case kTagTable:
              return _buildTable(meta, widgets);
            case kTagTableCaption:
              return _CaptionWidget(wf.buildColumn(widgets));
            case kTagTableRow:
              return _RowWidget(widgets.map((w) => _wrapCell(w)));
          }

          return wf.buildColumn(widgets);
        },
        priority: 100,
      );

  Widget _buildTable(NodeMetadata meta, Iterable<Widget> children) {
    final rowWidgets = <_RowWidget>[];
    children.forEach((c) => (c is _RowWidget ? rowWidgets.add(c) : null));
    if (rowWidgets.isEmpty) return null;

    // first pass to find number of columns
    int cols = 0;
    rowWidgets.forEach((rw) => cols = cols > rw.cols ? cols : rw.cols);

    final rows = rowWidgets.map((rw) {
      final cells = rw.cells.toList();
      while (cells.length < cols) cells.add(wf.buildTableCell(Container()));
      return TableRow(children: cells);
    });

    final widgets = <Widget>[];

    if (children.isNotEmpty) {
      final first = children.first;
      if (first is _CaptionWidget) widgets.add(first.child);
    }

    widgets.add(wf.buildTable(rows.toList(), border: _buildTableBorder(meta)));

    return wf.buildColumn(widgets);
  }

  Widget _wrapCell(Widget widget) =>
      widget is TableCell ? widget : wf.buildTableCell(widget);
}

class _CaptionWidget extends StatelessWidget {
  final Widget child;

  _CaptionWidget(this.child);

  @override
  Widget build(BuildContext context) => child;
}

class _RowWidget extends StatelessWidget {
  final Iterable<TableCell> cells;
  int get cols => cells.length;

  _RowWidget(this.cells);

  @override
  Widget build(BuildContext context) => Table(
        children: <TableRow>[TableRow(children: cells.toList())],
      );
}

TableBorder _buildTableBorder(NodeMetadata meta) {
  String styleBorder;
  meta.forEachInlineStyle((k, v) => k == 'border' ? styleBorder = v : null);
  if (styleBorder != null) {
    final borderParsed = parser.borderParse(styleBorder);
    if (borderParsed != null) {
      return TableBorder.all(
        color: borderParsed.color ?? const Color(0xFF000000),
        width: borderParsed.width.getValue(meta.buildOpTextStyle),
      );
    }
  }

  final e = meta.buildOpElement;
  if (e.attributes.containsKey('border')) {
    final width = double.tryParse(e.attributes['border']);
    if (width != null && width > 0) {
      return TableBorder.all(width: width);
    }
  }

  return null;
}
