part of '../core_widget_factory.dart';

const kTagTable = 'table';
const kTagTableAttrBorder = 'border';
const kTagTableBody = 'tbody';
const kTagTableCaption = 'caption';
const kTagTableCell = 'td';
const kTagTableFoot = 'tfoot';
const kTagTableHead = 'thead';
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
        getInlineStyles: (_, e) {
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
            case kTagTableBody:
            case kTagTableHead:
            case kTagTableFoot:
              return _SemanticWidget(meta.buildOpElement.localName, widgets);
          }

          return wf.buildColumn(widgets);
        },
        priority: 100,
      );

  Widget _buildTable(NodeMetadata meta, Iterable<Widget> children) {
    final headWidgets = <_RowWidget>[];
    final bodyWidgets = <_RowWidget>[];
    final footWidgets = <_RowWidget>[];
    for (final c in children) {
      if (c is _RowWidget) {
        bodyWidgets.add(c);
      } else if (c is _SemanticWidget) {
        final list = c.tag == kTagTableHead
            ? headWidgets
            : c.tag == kTagTableBody
                ? bodyWidgets
                : c.tag == kTagTableFoot ? footWidgets : null;
        for (final cc in c.widgets) {
          if (cc is _RowWidget) list?.add(cc);
        }
      }
    }

    final rowWidgets = List()
      ..addAll(headWidgets)
      ..addAll(bodyWidgets)
      ..addAll(footWidgets);
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

class _SemanticWidget extends StatelessWidget {
  final String tag;
  final Iterable<Widget> widgets;

  _SemanticWidget(this.tag, this.widgets);

  @override
  Widget build(BuildContext context) => Column(children: widgets.toList());
}

TableBorder _buildTableBorder(NodeMetadata meta) {
  String styleBorder;
  meta.styles((k, v) => k == kCssBorder ? styleBorder = v : null);
  if (styleBorder != null) {
    final borderParsed = borderParse(styleBorder);
    if (borderParsed != null) {
      return TableBorder.all(
        color: borderParsed.color ?? const Color(0xFF000000),
        width: borderParsed.width.getValue(meta.buildOpTextStyle),
      );
    }
  }

  final e = meta.buildOpElement;
  if (e.attributes.containsKey(kTagTableAttrBorder)) {
    final width = double.tryParse(e.attributes[kTagTableAttrBorder]);
    if (width != null && width > 0) {
      return TableBorder.all(width: width);
    }
  }

  return null;
}
