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
const _kTagTableOpPriority = 100;

class _TagTable {
  final WidgetFactory wf;

  BuildOp _captionOp;
  BuildOp _cellOp;
  BuildOp _rowOp;
  BuildOp _semanticOp;

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
              return lazySet(meta, buildOp: rowOp);
            case kTagTableBody:
            case kTagTableHead:
            case kTagTableFoot:
              return lazySet(meta, buildOp: semanticOp);
          }

          return meta;
        },
        onWidgets: (meta, widgets) => _buildTable(meta, widgets),
        priority: _kTagTableOpPriority,
      );

  BuildOp get captionOp {
    _captionOp ??= BuildOp(
      defaultStyles: (_, __) => const [kCssTextAlign, kCssTextAlignCenter],
      onWidgets: (_, widgets) => [_CaptionWidget(widgets)],
      priority: _kTagTableOpPriority,
    );
    return _captionOp;
  }

  BuildOp get cellOp {
    _cellOp ??= BuildOp(
      defaultStyles: (_, e) => e.localName == kTagTableHeader
          ? const [kCssFontWeight, kCssFontWeightBold]
          : null,
      onWidgets: (_, __) => null,
      priority: _kTagTableOpPriority,
    );
    return _cellOp;
  }

  BuildOp get rowOp {
    _rowOp ??= BuildOp(
      onWidgets: (_, ws) => [_RowWidget(ws.map((w) => _wrapCell(w)))],
      priority: _kTagTableOpPriority,
    );
    return _rowOp;
  }

  BuildOp get semanticOp {
    _semanticOp ??= BuildOp(
      onWidgets: (meta, widgets) => [
        _SemanticWidget(meta.domElement.localName, widgets),
      ],
      priority: _kTagTableOpPriority,
    );
    return _semanticOp;
  }

  Iterable<Widget> _buildTable(NodeMetadata meta, Iterable<Widget> children) {
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
      while (cells.length < cols) cells.add(wf.buildTableCell(widget0));
      return TableRow(children: cells);
    });

    final widgets = <Widget>[];

    if (children.isNotEmpty) {
      final first = children.first;
      if (first is _CaptionWidget) widgets.addAll(first.children);
    }

    widgets.add(WidgetPlaceholder((context) => wf.buildTable(
          rows.toList(),
          border: _buildTableBorder(context, meta),
        )));

    return widgets;
  }

  Widget _wrapCell(Widget widget) =>
      widget is TableCell ? widget : wf.buildTableCell(widget);
}

class _CaptionWidget extends StatelessWidget {
  final Iterable<Widget> children;

  _CaptionWidget(this.children);

  @override
  Widget build(BuildContext context) => Column(children: children);
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

TableBorder _buildTableBorder(BuildContext context, NodeMetadata meta) {
  String styleBorder;
  meta.styles((k, v) => k == kCssBorder ? styleBorder = v : null);
  if (styleBorder != null) {
    final borderParsed = parseCssBorderSide(styleBorder);
    if (borderParsed != null) {
      return TableBorder.all(
        color: borderParsed.color ?? const Color(0xFF000000),
        width: borderParsed.width.getValue(meta.textStyle(context)),
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
