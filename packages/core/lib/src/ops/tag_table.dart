part of '../core_widget_factory.dart';

const _kAttributeBorder = 'border';
const _kAttributeCellPadding = 'cellpadding';
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

  BuildOp get buildOp => BuildOp(
        onWidgets: (meta, widgets) {
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
            _TagTablePlaceholder(
              children: widgets,
              input: meta,
              lastBuilder: lastBuilder,
            ),
          ];
        },
        priority: 999999,
      );

  Iterable<Widget> _build(BuildContext c, Iterable<Widget> ws, NodeMetadata m) {
    if (ws?.isNotEmpty != true) return ws;

    final rows = <_TableDataRow>[];
    List<_TableDataRow> rowsHeader, rowsFooter;
    final widgets = <Widget>[];

    for (var child in ws) {
      if (child is WidgetPlaceholder) {
        final placeholder = child as WidgetPlaceholder;
        child = placeholder.build(c);
      }

      if (child is _TableDataRow) {
        rows.add(child);
      } else if (child is _TableDataGroup) {
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

    final borderSide = _parseBorder(c, m);
    widgets.add(_buildTableLayout(borderSide, rows));

    return [wf.buildColumn(widgets)];
  }

  Widget _buildTableLayout(BorderSide border, List<_TableDataRow> rows) {
    final decoration = border != null
        ? BoxDecoration(border: Border.fromBorderSide(border))
        : null;

    final children = <Widget>[];
    // ignore: prefer_collection_literals
    final grid = Map<int, Map<int, int>>();
    for (var row = 0; row < rows.length; row++) {
      for (final cell in rows[row].cells) {
        grid[row] ??= {};
        var col = 0;
        while (grid[row].containsKey(col)) {
          col++;
        }

        final index = children.length;
        for (var r = 0; r < cell.rowspan; r++) {
          for (var c = 0; c < cell.colspan; c++) {
            var rr = row + r;
            grid[rr] ??= {};

            var cc = col + c;
            if (!grid[rr].containsKey(cc)) {
              grid[rr][cc] = index;
            }
          }
        }

        Widget child = SizedBox.expand(child: wf.buildColumn(cell.children));
        if (decoration != null) {
          child = Container(child: child, decoration: decoration);
        }

        children.add(TablePlacement(
          columnStart: col,
          columnSpan: cell.colspan,
          rowStart: row,
          rowSpan: cell.rowspan,
          child: child,
        ));
      }
    }

    final tableLayout = TableLayout(
      children: children,
      cols: grid.values.fold(0, _colsCombine),
      gap: -(border?.width ?? 0),
      rows: grid.keys.length,
    );

    if (decoration == null) return tableLayout;

    return Stack(
      children: <Widget>[
        tableLayout,
        Positioned.fill(child: Container(decoration: decoration))
      ],
    );
  }

  BorderSide _parseBorder(BuildContext context, NodeMetadata meta) {
    var styleBorder = meta.style(_kCssBorder);
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

  static BuildOp cellPaddingOp(double px) => BuildOp(
      onChild: (meta, e) => (e.localName == 'td' || e.localName == 'th')
          ? meta.styles = [_kCssPadding, '${px}px']
          : null);

  static int _colsCombine(int prev, Map<int, int> row) {
    final cols = row.keys.length;
    return prev > cols ? prev : cols;
  }
}

class _TagTablePlaceholder<T> extends WidgetPlaceholder<T> {
  final Iterable<Widget> children;

  _TagTablePlaceholder({
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

class _TableDataCell extends StatelessWidget {
  final Iterable<Widget> children;
  final int colspan;
  final int rowspan;

  const _TableDataCell({Key key, this.children, this.colspan, this.rowspan})
      : super(key: key);

  @override
  Widget build(BuildContext context) => widget0;
}

class _TableDataRow extends StatelessWidget {
  final Iterable<_TableDataCell> cells;

  const _TableDataRow({Key key, this.cells}) : super(key: key);

  @override
  Widget build(BuildContext context) => widget0;
}

class _TableDataGroup extends StatelessWidget {
  final Iterable<_TableDataRow> rows;
  final String type;

  const _TableDataGroup({Key key, this.rows, this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) => widget0;
}

Iterable<Widget> _cell(BuildContext _, Iterable<Widget> ws, NodeMetadata m) {
  if (ws?.isNotEmpty != true) return ws;

  final a = m.domElement.attributes;
  final colspan = a.containsKey('colspan') ? int.tryParse(a['colspan']) : null;
  final rowspan = a.containsKey('rowspan') ? int.tryParse(a['rowspan']) : null;

  return [
    _TableDataCell(
      children: ws,
      colspan: colspan ?? 1,
      rowspan: rowspan ?? 1,
    )
  ];
}

Iterable<Widget> _row(BuildContext c, Iterable<Widget> ws, _) {
  if (ws?.isNotEmpty != true) return ws;

  final cells = <_TableDataCell>[];

  for (var child in ws) {
    if (child is WidgetPlaceholder) {
      final placeholder = child as WidgetPlaceholder;
      child = placeholder.build(c);
    }

    if (child is _TableDataCell) {
      cells.add(child);
    }
  }

  if (cells.isEmpty) return null;

  return [_TableDataRow(cells: cells)];
}

Iterable<Widget> _group(BuildContext c, Iterable<Widget> ws, NodeMetadata m) {
  if (ws?.isNotEmpty != true) return ws;

  final rows = <_TableDataRow>[];

  for (var child in ws) {
    if (child is WidgetPlaceholder) {
      final placeholder = child as WidgetPlaceholder;
      child = placeholder.build(c);
    }

    if (child is _TableDataRow) {
      rows.add(child);
    }
  }

  if (rows.isEmpty) return null;

  return [_TableDataGroup(rows: rows, type: m.style(_kCssDisplay))];
}
