part of '../core_widget_factory.dart';

const _kTagTable = 'table';
const _kTagTableRow = 'tr';
const _kTagTableHeaderGroup = 'thead';
const _kTagTableRowGroup = 'tbody';
const _kTagTableFooterGroup = 'tfoot';
const _kTagTableHeaderCell = 'th';
const _kTagTableCell = 'td';
const _kTagTableCaption = 'caption';

const _kAttributeBorder = 'border';
const _kAttributeCellPadding = 'cellpadding';
const _kCssDisplayTable = 'table';
const _kCssDisplayTableRow = 'table-row';
const _kCssDisplayTableHeaderGroup = 'table-header-group';
const _kCssDisplayTableRowGroup = 'table-row-group';
const _kCssDisplayTableFooterGroup = 'table-footer-group';
const _kCssDisplayTableCell = 'table-cell';
const _kCssDisplayTableCaption = 'table-caption';

class _TagTable extends BuildOp {
  final NodeMetadata tableMeta;
  final WidgetFactory wf;

  final _data = _TableData();

  _TagTable(this.wf, this.tableMeta)
      : super(
          isBlockElement: true,
          priority: 999999,
        );

  @override
  bool get hasOnChild => true;

  @override
  void onChild(NodeMetadata childMeta, dom.Element e) {
    if (e.parent != tableMeta.domElement) return;

    final which = _getChildCssDisplayValue(childMeta, e);
    switch (which) {
      case _kCssDisplayTableRow:
        final row = _TableDataRow();
        _data.rows.add(row);
        childMeta.op = _TableRowOp(wf, childMeta, row);
        break;
      case _kCssDisplayTableHeaderGroup:
      case _kCssDisplayTableRowGroup:
      case _kCssDisplayTableFooterGroup:
        final rows = which == _kCssDisplayTableHeaderGroup
            ? _data.header.rows
            : which == _kCssDisplayTableRowGroup
                ? _data.rows
                : _data.footer.rows;
        childMeta.op = _TableGroupOp(wf, childMeta, rows);
        break;
      case _kCssDisplayTableCaption:
        childMeta.op = BuildOp(onWidgets: (_, widgets) {
          _data.caption = wf.buildColumn(widgets);
          return [_data.caption];
        });
        break;
    }
  }

  @override
  Iterable<WidgetPlaceholder> onWidgets(
          NodeMetadata meta, Iterable<WidgetPlaceholder> _) =>
      [
        WidgetPlaceholder<_TableData>(
          builder: _buildTable,
          input: _data,
        )
      ];

  Widget _buildTable(BuildContext c, Widget _, _TableData data) {
    final table = TableData(
      border: _parseBorder(c),
    );

    final rows = <_TableDataRow>[
      ...data.header.rows,
      ...data.rows,
      ...data.footer.rows,
    ];

    for (var i = 0; i < rows.length; i++) {
      for (final cell in rows[i].cells) {
        table.addCell(i, cell);
      }
    }

    final tableWidget = table.slots.isNotEmpty ? wf.buildTable(table) : widget0;
    if (data.caption == null) {
      return tableWidget;
    }

    return wf.buildColumn([data.caption, tableWidget]);
  }

  BorderSide _parseBorder(BuildContext context) {
    var styleBorder = tableMeta.style(_kCssBorder);
    if (styleBorder != null) {
      final borderParsed = wf.parseCssBorderSide(styleBorder);
      if (borderParsed != null) {
        return BorderSide(
          color: borderParsed.color ?? const Color(0xFF000000),
          width: borderParsed.width.getValue(context, tableMeta.tsb()),
        );
      }
    }

    final a = tableMeta.domElement.attributes;
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
          ? meta.addStyle(_kCssPadding, '${px}px')
          : null);

  static String _getChildCssDisplayValue(NodeMetadata meta, dom.Element e) {
    String value;
    switch (e.localName) {
      case _kTagTableRow:
        value = _kCssDisplayTableRow;
        break;
      case _kTagTableHeaderGroup:
        value = _kCssDisplayTableHeaderGroup;
        break;
      case _kTagTableRowGroup:
        value = _kCssDisplayTableRowGroup;
        break;
      case _kTagTableFooterGroup:
        value = _kCssDisplayTableFooterGroup;
        break;
      case _kTagTableHeaderCell:
      case _kTagTableCell:
        value = _kCssDisplayTableCell;
        break;
      case _kTagTableCaption:
        value = _kCssDisplayTableCaption;
        break;
    }

    if (value != null) {
      meta.addStyle(_kCssDisplay, value);
      return value;
    }

    if (e.attributes.containsKey('style')) {
      for (final pair in splitAttributeStyle(e.attributes['style'])
          .toList(growable: false)
          .reversed) {
        if (pair.key == _kCssDisplay) {
          return pair.value;
        }
      }
    }

    return null;
  }
}

class _TableGroupOp extends BuildOp {
  final List<_TableDataRow> rows;
  final NodeMetadata groupMeta;
  final WidgetFactory wf;

  _TableGroupOp(this.wf, this.groupMeta, this.rows);

  @override
  bool get hasOnChild => true;

  @override
  void onChild(NodeMetadata childMeta, dom.Element e) {
    if (e.parent != groupMeta.domElement) return;
    if (_TagTable._getChildCssDisplayValue(childMeta, e) !=
        _kCssDisplayTableRow) return;

    final row = _TableDataRow();
    rows.add(row);
    childMeta.op = _TableRowOp(wf, childMeta, row);
  }
}

class _TableRowOp extends BuildOp {
  final _TableDataRow row;
  final NodeMetadata rowMeta;
  final WidgetFactory wf;

  BuildOp _cellOp;

  _TableRowOp(this.wf, this.rowMeta, this.row);

  @override
  bool get hasOnChild => true;

  @override
  void onChild(NodeMetadata childMeta, dom.Element e) {
    if (e.parent != rowMeta.domElement) return;
    if (_TagTable._getChildCssDisplayValue(childMeta, e) !=
        _kCssDisplayTableCell) return;

    _cellOp ??= BuildOp(
      onWidgets: (childMeta, widgets) {
        final column = wf.buildColumn(widgets);
        if (column == null) return null;

        final cell = _build(childMeta, column);
        row.cells.add(cell);

        return [column];
      },
    );

    childMeta.op = _cellOp;
  }

  static TableDataCell _build(NodeMetadata cellMeta, Widget child) {
    final a = cellMeta.domElement.attributes;
    final colspan =
        a.containsKey('colspan') ? int.tryParse(a['colspan']) : null;
    final rowspan =
        a.containsKey('rowspan') ? int.tryParse(a['rowspan']) : null;

    return TableDataCell(
      child: child,
      colspan: colspan ?? 1,
      rowspan: rowspan ?? 1,
    );
  }
}

class _TableData {
  Widget caption;
  final footer = _TableDataGroup();
  final header = _TableDataGroup();
  final rows = <_TableDataRow>[];
}

class _TableDataGroup {
  final rows = <_TableDataRow>[];
}

class _TableDataRow {
  final cells = <TableDataCell>[];
}
