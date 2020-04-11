part of '../core_widget_factory.dart';

const _kAttributeBorder = 'border';
const _kCssDisplayTable = 'table';
const _kCssDisplayTableRow = 'table-row';
const _kCssDisplayTableHeaderGroup = 'table-header-group';
const _kCssDisplayTableRowGroup = 'table-row-group';
const _kCssDisplayTableFooterGroup = 'table-footer-group';
const _kCssDisplayTableCell = 'table-cell';
const _kCssDisplayTableCaption = 'table-caption';

class _TagTable {
  final WidgetFactory wf;

  _TagTable(this.wf);

  BuildOp get buildOp => BuildOp(onWidgets: (meta, widgets) {
        WidgetPlaceholderBuilder<NodeMetadata> lastBuilder;

        switch (meta.style(_kCssDisplay)) {
          case _kCssDisplayTableRow:
            lastBuilder = _row;
            break;
          case _kCssDisplayTableHeaderGroup:
          case _kCssDisplayTableRowGroup:
          case _kCssDisplayTableFooterGroup:
            lastBuilder = _group;
            break;
          case _kCssDisplayTableCell:
            return [
              WidgetPlaceholder(
                children: widgets,
                input: meta,
                lastBuilder: _cell,
              ),
            ];
          case _kCssDisplayTableCaption:
            return widgets;
          default:
            lastBuilder = _build;
        }

        return [
          _TableLayoutPlaceholder(
            children: widgets,
            input: meta,
            lastBuilder: lastBuilder,
          ),
        ];
      });

  Iterable<Widget> _build(BuildContext c, Iterable<Widget> ws, NodeMetadata m) {
    if (ws?.isNotEmpty != true) return ws;

    final rows = <TableLayoutRow>[];
    List<TableLayoutRow> rowsHeader, rowsFooter;
    final widgets = <Widget>[];

    for (var child in ws) {
      if (child is WidgetPlaceholder) {
        final placeholder = child as WidgetPlaceholder;
        child = placeholder.build(c);
      }

      if (child is TableLayoutRow) {
        rows.add(child);
      } else if (child is TableLayoutGroup) {
        if (child.type == _kCssDisplayTableHeaderGroup && rowsHeader == null) {
          rowsHeader = child.rows;
        } else if (child.type == _kCssDisplayTableFooterGroup &&
            rowsFooter == null) {
          rowsFooter = child.rows;
        } else {
          rows.addAll(child.rows);
        }
      } else {
        widgets.add(child);
      }
    }

    if (rowsHeader != null) rows.insertAll(0, rowsHeader);
    if (rowsFooter != null) rows.addAll(rowsFooter);
    if (rows.isEmpty) return widgets;

    final tableLayout = TableLayout();
    for (var i = 0; i < rows.length; i++) {
      for (final cell in rows[i].cells) {
        tableLayout.addCell(i, cell);
      }
    }

    final border = _parseBorderSide(c, m);
    widgets.add(wf.buildTable(tableLayout, border: border));

    return [wf.buildColumn(widgets)];
  }

  BorderSide _parseBorderSide(BuildContext context, NodeMetadata meta) {
    String styleBorder = meta.style(_kCssBorder);
    if (styleBorder != null) {
      final borderParsed = wf.parseCssBorderSide(styleBorder);
      if (borderParsed != null) {
        return BorderSide(
          color: borderParsed.color ?? const Color(0xFF000000),
          width: borderParsed.width.getValue(context, meta.tsb),
        );
      }
    }

    final a = meta.domElement.attributes;
    if (a.containsKey(_kAttributeBorder)) {
      final width = double.tryParse(a[_kAttributeBorder]);
      if (width != null && width > 0) {
        return BorderSide(width: width);
      }
    }

    return null;
  }
}

Iterable<Widget> _cell(BuildContext _, Iterable<Widget> ws, NodeMetadata m) {
  if (ws?.isNotEmpty != true) return ws;

  final a = m.domElement.attributes;
  final colspan = a.containsKey('colspan') ? int.tryParse(a['colspan']) : null;
  final rowspan = a.containsKey('rowspan') ? int.tryParse(a['rowspan']) : null;

  return [
    TableLayoutCell(
      children: ws,
      colspan: colspan ?? 1,
      rowspan: rowspan ?? 1,
    )
  ];
}

Iterable<Widget> _row(BuildContext c, Iterable<Widget> ws, _) {
  if (ws?.isNotEmpty != true) return ws;

  final cells = <TableLayoutCell>[];

  for (var child in ws) {
    if (child is WidgetPlaceholder) {
      final placeholder = child as WidgetPlaceholder;
      child = placeholder.build(c);
    }

    if (child is TableLayoutCell) {
      cells.add(child);
    }
  }

  if (cells.isEmpty) return null;

  return [TableLayoutRow(cells: cells)];
}

Iterable<Widget> _group(BuildContext c, Iterable<Widget> ws, NodeMetadata m) {
  if (ws?.isNotEmpty != true) return ws;

  final rows = <TableLayoutRow>[];

  for (var child in ws) {
    if (child is WidgetPlaceholder) {
      final placeholder = child as WidgetPlaceholder;
      child = placeholder.build(c);
    }

    if (child is TableLayoutRow) {
      rows.add(child);
    }
  }

  if (rows.isEmpty) return null;

  return [TableLayoutGroup(rows: rows, type: m.style(_kCssDisplay))];
}

class _TableLayoutPlaceholder<T> extends WidgetPlaceholder<T> {
  final Iterable<Widget> children;

  _TableLayoutPlaceholder({
    this.children,
    T input,
    WidgetPlaceholderBuilder<T> lastBuilder,
  }) : super(children: children, input: input, lastBuilder: lastBuilder);

  @override
  void wrapWith<T2>(WidgetPlaceholderBuilder<T2> builder, [T2 input]) {
    assert(builder != null);

    for (final child in children) {
      if (child is WidgetPlaceholder) {
        child.wrapWith(builder, input);
      }
    }
  }
}
