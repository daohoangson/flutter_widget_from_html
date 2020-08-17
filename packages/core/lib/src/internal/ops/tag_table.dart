part of '../core_ops.dart';

const kTagTable = 'table';
const kTagTableRow = 'tr';
const kTagTableHeaderGroup = 'thead';
const kTagTableRowGroup = 'tbody';
const kTagTableFooterGroup = 'tfoot';
const kTagTableHeaderCell = 'th';
const kTagTableCell = 'td';
const kTagTableCaption = 'caption';

const kAttributeBorder = 'border';
const kAttributeCellPadding = 'cellpadding';
const kCssDisplayTable = 'table';
const kCssDisplayTableRow = 'table-row';
const kCssDisplayTableHeaderGroup = 'table-header-group';
const kCssDisplayTableRowGroup = 'table-row-group';
const kCssDisplayTableFooterGroup = 'table-footer-group';
const kCssDisplayTableCell = 'table-cell';
const kCssDisplayTableCaption = 'table-caption';

class TagTable {
  final NodeMetadata tableMeta;
  final WidgetFactory wf;

  final _data = _TagTableData();

  BuildOp _tableOp;

  TagTable(this.wf, this.tableMeta);

  BuildOp get op {
    _tableOp = BuildOp(
      onChild: onChild,
      onWidgets: onWidgets,
    );
    return _tableOp;
  }

  void onChild(NodeMetadata childMeta, dom.Element e) {
    if (e.parent != tableMeta.domElement) return;

    final which = _getChildCssDisplayValue(childMeta, e);
    switch (which) {
      case kCssDisplayTableRow:
        final row = _TagTableDataRow();
        _data.rows.add(row);
        childMeta.register(_TagTableRow(wf, childMeta, row).op);
        break;
      case kCssDisplayTableHeaderGroup:
      case kCssDisplayTableRowGroup:
      case kCssDisplayTableFooterGroup:
        final rows = which == kCssDisplayTableHeaderGroup
            ? _data.header.rows
            : which == kCssDisplayTableRowGroup
                ? _data.rows
                : _data.footer.rows;
        childMeta.register(_TagTableGroup(wf, childMeta, rows).op);
        break;
      case kCssDisplayTableCaption:
        childMeta.register(BuildOp(onWidgets: (meta, widgets) {
          final caption = wf.buildColumnPlaceholder(meta, widgets);
          if (caption == null) return [];

          _data.captions.add(caption);
          return [caption];
        }));
        break;
    }
  }

  Iterable<WidgetPlaceholder> onWidgets(
      NodeMetadata _, Iterable<WidgetPlaceholder> __) {
    final metadata = TableMetadata(border: _parseBorder());

    final rows = <_TagTableDataRow>[
      ..._data.header.rows,
      ..._data.rows,
      ..._data.footer.rows,
    ];
    for (var i = 0; i < rows.length; i++) {
      for (final cell in rows[i].cells) {
        metadata.addCell(
          i,
          cell.child,
          colspan: cell.colspan,
          rowspan: cell.rowspan,
        );
      }
    }

    final table = wf.buildTable(tableMeta, metadata);
    final column = wf.buildColumnPlaceholder(tableMeta, [
      ..._data.captions,
      if (table != null) table,
    ]);
    if (column == null) return [];

    return [
      WidgetPlaceholder<TableMetadata>(
        child: column,
        generator: metadata,
      )
    ];
  }

  BorderSide _parseBorder() {
    final value = tableMeta[kCssBorder];
    if (value != null) {
      final borderParsed = tryParseCssBorderSide(value);
      if (borderParsed != null) {
        return BorderSide(
          color: borderParsed.color ?? const Color(0xFF000000),
          width: borderParsed.width.getValue(tableMeta.tsb().build()),
        );
      }
    }

    final width = tryParseDoubleFromMap(
        tableMeta.domElement.attributes, kAttributeBorder);
    if (width != null && width > 0) return BorderSide(width: width);

    return null;
  }

  static BuildOp cellPaddingOp(double px) => BuildOp(
      onChild: (meta, e) => (e.localName == 'td' || e.localName == 'th')
          ? meta[kCssPadding] = '${px}px'
          : null);

  static String _getChildCssDisplayValue(NodeMetadata meta, dom.Element e) {
    String value;
    switch (e.localName) {
      case kTagTableRow:
        value = kCssDisplayTableRow;
        break;
      case kTagTableHeaderGroup:
        value = kCssDisplayTableHeaderGroup;
        break;
      case kTagTableRowGroup:
        value = kCssDisplayTableRowGroup;
        break;
      case kTagTableFooterGroup:
        value = kCssDisplayTableFooterGroup;
        break;
      case kTagTableHeaderCell:
      case kTagTableCell:
        return kCssDisplayTableCell;
      case kTagTableCaption:
        return kCssDisplayTableCaption;
    }

    if (value != null) {
      meta[kCssDisplay] = value;
      return value;
    }

    if (e.attributes.containsKey('style')) {
      for (final pair in splitAttributeStyle(e.attributes['style'])
          .toList(growable: false)
          .reversed) {
        if (pair.key == kCssDisplay) {
          return pair.value;
        }
      }
    }

    return null;
  }
}

class _TagTableGroup {
  final List<_TagTableDataRow> rows;
  final NodeMetadata groupMeta;
  final WidgetFactory wf;

  BuildOp op;

  _TagTableGroup(this.wf, this.groupMeta, this.rows) {
    op = BuildOp(onChild: onChild);
  }

  void onChild(NodeMetadata childMeta, dom.Element e) {
    if (e.parent != groupMeta.domElement) return;
    if (TagTable._getChildCssDisplayValue(childMeta, e) !=
        kCssDisplayTableRow) {
      return;
    }

    final row = _TagTableDataRow();
    rows.add(row);
    childMeta.register(_TagTableRow(wf, childMeta, row).op);
  }
}

class _TagTableRow {
  final _TagTableDataRow row;
  final NodeMetadata rowMeta;
  final WidgetFactory wf;

  BuildOp op;
  BuildOp _cellOp;

  _TagTableRow(this.wf, this.rowMeta, this.row) {
    op = BuildOp(onChild: onChild);
  }

  void onChild(NodeMetadata childMeta, dom.Element e) {
    if (e.parent != rowMeta.domElement) return;
    if (TagTable._getChildCssDisplayValue(childMeta, e) !=
        kCssDisplayTableCell) {
      return;
    }

    _cellOp ??= BuildOp(
      onWidgets: (cellMeta, widgets) {
        final column = wf.buildColumnPlaceholder(cellMeta, widgets);
        if (column == null) return [];

        final attributes = cellMeta.domElement.attributes;
        row.cells.add(_TagTableDataCell(
          child: column,
          colspan: _tryParseInt(attributes, 'colspan') ?? 1,
          rowspan: _tryParseInt(attributes, 'rowspan') ?? 1,
        ));

        return [column];
      },
    );

    childMeta.register(_cellOp);
  }

  static int _tryParseInt(Map<dynamic, String> attributes, String key) =>
      attributes.containsKey(key) ? int.tryParse(attributes[key]) : null;
}

@immutable
class _TagTableData {
  final captions = <Widget>[];
  final footer = _TagTableDataGroup();
  final header = _TagTableDataGroup();
  final rows = <_TagTableDataRow>[];
}

@immutable
class _TagTableDataGroup {
  final rows = <_TagTableDataRow>[];
}

@immutable
class _TagTableDataRow {
  final cells = <_TagTableDataCell>[];
}

@immutable
class _TagTableDataCell {
  final Widget child;
  final int colspan;
  final int rowspan;

  _TagTableDataCell({this.child, this.colspan, this.rowspan});
}
