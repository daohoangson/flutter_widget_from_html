part of '../core_widget_factory.dart';

const _kTagTable = 'table';
const _kTagTableAttrBorder = 'border';
const _kTagTableBody = 'tbody';
const _kTagTableCaption = 'caption';
const _kTagTableCell = 'td';
const _kTagTableFoot = 'tfoot';
const _kTagTableHead = 'thead';
const _kTagTableHeader = 'th';
const _kTagTableRow = 'tr';

class _TagTable {
  final WidgetFactory wf;

  BuildOp _cellOp;
  BuildOp _rowOp;
  BuildOp _setOp;

  _TagTable(this.wf);

  BuildOp get buildOp => BuildOp(
        onChild: (meta, e) {
          switch (e.localName) {
            case _kTagTableCaption:
              return lazySet(meta,
                  styles: [_kCssTextAlign, _kCssTextAlignCenter]);
            case _kTagTableCell:
            case _kTagTableHeader:
              return lazySet(meta, buildOp: cellOp);
            case _kTagTableRow:
              return lazySet(meta, buildOp: rowOp);
            case _kTagTableBody:
            case _kTagTableHead:
            case _kTagTableFoot:
              return lazySet(meta, buildOp: setOp);
          }

          return meta;
        },
        onWidgets: (meta, widgets) => [
          _TableLayoutPlaceholder(
            children: widgets,
            input: meta,
            lastBuilder: _build,
          ),
        ],
      );

  BuildOp get cellOp {
    _cellOp ??= BuildOp(
      defaultStyles: (_, e) => e.localName == _kTagTableHeader
          ? const [_kCssFontWeight, _kCssFontWeightBold]
          : null,
      onWidgets: (meta, widgets) => [
        WidgetPlaceholder(
          children: widgets,
          input: meta,
          lastBuilder: _cell,
        ),
      ],
    );
    return _cellOp;
  }

  BuildOp get rowOp {
    _rowOp ??= BuildOp(
      onWidgets: (_, widgets) => [
        _TableLayoutPlaceholder(
          children: widgets,
          lastBuilder: _row,
        ),
      ],
    );
    return _rowOp;
  }

  BuildOp get setOp {
    _setOp ??= BuildOp(
      onWidgets: (meta, widgets) => [
        _TableLayoutPlaceholder(
          children: widgets,
          input: meta,
          lastBuilder: _set,
        ),
      ],
    );
    return _setOp;
  }

  Iterable<Widget> _build(BuildContext c, Iterable<Widget> ws, NodeMetadata m) {
    if (ws?.isNotEmpty != true) return ws;

    final rows = <TableLayoutRow>[];
    List<TableLayoutRow> rowsThead, rowsTfoot;
    final widgets = <Widget>[];

    for (var child in ws) {
      if (child is WidgetPlaceholder) {
        final placeholder = child as WidgetPlaceholder;
        child = placeholder.build(c);
      }

      if (child is TableLayoutRow) {
        rows.add(child);
      } else if (child is TableLayoutSet) {
        if (child.type == _kTagTableHead && rowsThead == null) {
          rowsThead = child.rows;
        } else if (child.type == _kTagTableFoot && rowsTfoot == null) {
          rowsTfoot = child.rows;
        } else {
          rows.addAll(child.rows);
        }
      } else {
        widgets.add(child);
      }
    }

    if (rowsThead != null) rows.insertAll(0, rowsThead);
    if (rowsTfoot != null) rows.addAll(rowsTfoot);
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
    if (a.containsKey(_kTagTableAttrBorder)) {
      final width = double.tryParse(a[_kTagTableAttrBorder]);
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

Iterable<Widget> _set(BuildContext c, Iterable<Widget> ws, NodeMetadata m) {
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

  return [TableLayoutSet(rows: rows, type: m.domElement.localName)];
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
