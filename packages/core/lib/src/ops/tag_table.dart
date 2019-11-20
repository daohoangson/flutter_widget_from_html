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

class _TagTable {
  final WidgetFactory wf;

  BuildOp _captionOp;
  BuildOp _cellOp;
  BuildOp _childOp;

  _TagTable(this.wf);

  BuildOp get buildOp => BuildOp(
        onChild: (meta, e) {
          switch (e.localName) {
            case kTagTableCaption:
              return lazySet(meta, buildOp: captionOp);
            case kTagTableCell:
            case kTagTableHeader:
              return lazySet(meta, buildOp: cellOp);
            case kTagTableRow:
            case kTagTableBody:
            case kTagTableHead:
            case kTagTableFoot:
              return lazySet(meta, buildOp: childOp);
          }

          return meta;
        },
        onWidgets: (meta, widgets) => [_placeholder(widgets, meta)],
      );

  BuildOp get captionOp {
    _captionOp ??= BuildOp(
      defaultStyles: (_, __) => const [kCssTextAlign, kCssTextAlignCenter],
      onWidgets: (meta, widgets) => [_placeholder(widgets, meta)],
    );
    return _captionOp;
  }

  BuildOp get cellOp {
    _cellOp ??= BuildOp(
      defaultStyles: (_, e) => e.localName == kTagTableHeader
          ? const [kCssFontWeight, kCssFontWeightBold]
          : null,
      onWidgets: (meta, widgets) =>
          [_placeholder(widgets, meta, kTagTableCell)],
    );
    return _cellOp;
  }

  BuildOp get childOp {
    _childOp ??= BuildOp(
      onWidgets: (meta, widgets) => [_placeholder(widgets, meta)],
    );
    return _childOp;
  }

  Iterable<Widget> _build(
      BuilderContext bc, Iterable<Widget> ws, _TableInput i) {
    switch (i.tag) {
      case kTagTableCaption:
      case kTagTableCell:
        return ws;
      case kTagTableRow:
        return [_buildRow(bc, ws, i)];
      case kTagTableHead:
      case kTagTableBody:
      case kTagTableFoot:
        return [_buildRows(bc, ws, i)];
    }

    return listOfNonNullOrNothing(_buildTable(bc, ws, i));
  }

  Widget _buildTable(BuilderContext bc, Iterable<Widget> ws, _TableInput i) {
    final rows = <_TableRow>[];
    final bodyRows = <_TableRow>[];
    final footRows = <_TableRow>[];
    for (final child in ws) {
      if (child is _TablePlaceholder) {
        switch (child.tag) {
          case kTagTableHead:
            rows.addAll((child.buildWithContext(bc) as _TableRows).rows);
            break;
          case kTagTableBody:
            bodyRows.addAll((child.buildWithContext(bc) as _TableRows).rows);
            break;
          case kTagTableFoot:
            footRows.addAll((child.buildWithContext(bc) as _TableRows).rows);
            break;
          case kTagTableRow:
            bodyRows.add(child.buildWithContext(bc));
            break;
        }
      }
    }

    rows.addAll(bodyRows);
    rows.addAll(footRows);
    if (rows.isEmpty) return null;

    int cols = 0;
    for (final row in rows) {
      cols = cols > row.cells.length ? cols : row.cells.length;
    }
    if (cols == 0) return null;

    final tableRows = <TableRow>[];
    for (final row in rows) {
      final cells = List<Widget>(cols);

      int i = 0;
      for (final cell in row.cells) cells[i++] = wf.buildTableCell(cell);
      while (i < cols) cells[i++] = widget0;

      tableRows.add(TableRow(children: cells));
    }

    final widgets = <Widget>[];
    if (ws.isNotEmpty) {
      final first = ws.first;
      if (first is _TablePlaceholder && first.tag == kTagTableCaption)
        widgets.add(first);
    }

    final border = _buildTableBorder(bc, i.meta);
    widgets.add(wf.buildTable(tableRows, border: border));

    if (widgets.length == 1) return widgets.first;
    return SimpleColumn.wrap(widgets);
  }

  TableBorder _buildTableBorder(BuilderContext bc, NodeMetadata meta) {
    String styleBorder;
    meta.styles((k, v) => k == kCssBorder ? styleBorder = v : null);
    if (styleBorder != null) {
      final borderParsed = parseCssBorderSide(styleBorder);
      if (borderParsed != null) {
        return TableBorder.all(
          color: borderParsed.color ?? const Color(0xFF000000),
          width: borderParsed.width.getValue(bc, meta.tsb),
        );
      }
    }

    final a = meta.domElement.attributes;
    if (a.containsKey(kTagTableAttrBorder)) {
      final width = double.tryParse(a[kTagTableAttrBorder]);
      if (width != null && width > 0) {
        return TableBorder.all(width: width);
      }
    }

    return null;
  }

  Widget _buildRow(BuilderContext bc, Iterable<Widget> ws, _TableInput i) {
    final cells = <Widget>[];
    for (final child in ws) {
      if (child is _TablePlaceholder && child.tag == kTagTableCell) {
        cells.add(child.buildWithContext(bc));
      }
    }

    return _TableRow(cells);
  }

  Widget _buildRows(BuilderContext bc, Iterable<Widget> ws, _TableInput i) {
    final rows = <_TableRow>[];
    for (final child in ws) {
      if (child is _TablePlaceholder && child.tag == kTagTableRow) {
        rows.add(child.buildWithContext(bc));
      }
    }

    return _TableRows(rows);
  }

  _TablePlaceholder _placeholder(
    Iterable<Widget> children,
    NodeMetadata meta, [
    String tag,
  ]) =>
      _TablePlaceholder(
        this,
        children,
        _TableInput()
          ..meta = meta
          ..tag = tag ?? meta.domElement.localName,
      );
}

class _TableInput {
  NodeMetadata meta;
  String tag;
}

class _TablePlaceholder extends WidgetPlaceholder<_TableInput> {
  final Iterable<Widget> _children;
  final String tag;

  _TablePlaceholder(
    _TagTable self,
    this._children,
    _TableInput _input,
  )   : tag = _input.tag,
        super(
          builder: self._build,
          children: _children,
          input: _input,
        );

  @override
  void wrapWith<T>(WidgetPlaceholderBuilder<T> builder, [T input]) {
    if (tag == kTagTableCell) return super.wrapWith(builder, input);

    for (final child in _children)
      if (child is IWidgetPlaceholder) child.wrapWith(builder, input);
  }
}

class _TableRow extends StatelessWidget {
  final List<Widget> cells;

  _TableRow(this.cells);

  @override
  Widget build(BuildContext context) => widget0;
}

class _TableRows extends StatelessWidget {
  final Iterable<_TableRow> rows;

  _TableRows(this.rows);

  @override
  Widget build(BuildContext context) => widget0;
}
