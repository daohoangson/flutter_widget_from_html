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
const kAttributeColspan = 'colspan';
const kAttributeCellSpacing = 'cellspacing';
const kAttributeRowspan = 'rowspan';
const kAttributeValign = 'valign';

const kCssBorderCollapse = 'border-collapse';
const kCssBorderCollapseCollapse = 'collapse';
const kCssBorderCollapseSeparate = 'separate';
const kCssBorderSpacing = 'border-spacing';

const kCssDisplayTable = 'table';
const kCssDisplayTableRow = 'table-row';
const kCssDisplayTableHeaderGroup = 'table-header-group';
const kCssDisplayTableRowGroup = 'table-row-group';
const kCssDisplayTableFooterGroup = 'table-footer-group';
const kCssDisplayTableCell = 'table-cell';
const kCssDisplayTableCaption = 'table-caption';

class TagTable {
  final WidgetFactory wf;

  final _data = _TagTableData();

  TagTable(this.wf);

  BuildOp get buildOp => BuildOp(
        onChild: _onTableChild,
        onTree: _onTableTree,
        onWidgets: _onTableWidgets,
        priority: 0,
      );

  void _onTableChild(BuildTree tableTree, BuildTree subTree) {
    if (subTree.element.parent != tableTree.element) {
      return;
    }

    final data = _data;
    final which = _getCssDisplayValue(subTree);
    _TagTableDataGroup? latestGroup;
    switch (which) {
      case kCssDisplayTableRow:
        latestGroup ??= data.body;
        final row = _TagTableDataRow();
        latestGroup.rows.add(row);
        subTree.register(_TagTableRow(this, row)._rowOp);
        break;
      case kCssDisplayTableHeaderGroup:
      case kCssDisplayTableRowGroup:
      case kCssDisplayTableFooterGroup:
        final rows = which == kCssDisplayTableHeaderGroup
            ? data.header.rows
            : which == kCssDisplayTableRowGroup
                ? data.body.rows
                : data.footer.rows;
        subTree.register(_TagTableRowGroup(this, rows)._groupOp);
        latestGroup = null;
        break;
      case kCssDisplayTableCaption:
        subTree.register(
          BuildOp(
            onWidgets: (captionTree, widgets) {
              final child = wf.buildColumnPlaceholder(captionTree, widgets);
              if (child != null) {
                data.captions.add(child);
              }
              return [];
            },
            priority: BuildOp.kPriorityMax,
          ),
        );
        break;
    }
  }

  void _onTableTree(BuildTree tableTree) {
    StyleBorder.skip(tableTree);
    StyleSizing.skip(tableTree);
  }

  Iterable<Widget> _onTableWidgets(
    BuildTree tableTree,
    Iterable<WidgetPlaceholder> _,
  ) {
    final data = _data;

    _prepareHtmlTableCaptionBuilders(data);
    _prepareHtmlTableCellBuilders(tableTree, data.header);
    for (final body in data.bodies) {
      _prepareHtmlTableCellBuilders(tableTree, body);
    }
    _prepareHtmlTableCellBuilders(tableTree, data.footer);
    if (data.builders.isEmpty) {
      return [];
    }

    final border = tryParseBorder(tableTree);
    final borderCollapse = tableTree[kCssBorderCollapse]?.term;
    final borderSpacingExpression = tableTree[kCssBorderSpacing]?.value;
    final borderSpacing = borderSpacingExpression != null
        ? tryParseCssLength(borderSpacingExpression)
        : null;

    return [
      WidgetPlaceholder(
        builder: (context, _) {
          final tableStyle = tableTree.styleBuilder.build(context);

          return ValignBaselineContainer(
            child: HtmlTable(
              border: border.getBorder(tableStyle),
              borderCollapse: borderCollapse == kCssBorderCollapseCollapse,
              borderSpacing: borderSpacing?.getValue(tableStyle) ?? 0.0,
              textDirection: tableStyle.textDirection,
              children: List.from(
                data.builders.map((f) => f(context)).where((e) => e != null),
                growable: false,
              ),
            ),
          );
        },
        localName: kTagTable,
      ),
    ];
  }

  void _prepareHtmlTableCaptionBuilders(_TagTableData data) {
    for (final child in data.captions) {
      final rowIndex = data.rows;
      final builderIndex = data.builders.length;
      data.cells[rowIndex] = {0: builderIndex};
      data.columns = max(data.columns, 1);
      data.rows = data.cells.keys.length;

      data.builders.add(
        (_) => HtmlTableCaption(
          columnSpan: data.columns,
          rowIndex: rowIndex,
          child: child,
        ),
      );
    }
  }

  void _prepareHtmlTableCellBuilders(
    BuildTree tableTree,
    _TagTableDataGroup group,
  ) {
    final data = _data;
    final rowStartOffset = data.rows;
    final rowSpanMax = group.rows.length;

    for (var i = 0; i < group.rows.length; i++) {
      final row = group.rows[i];
      final rowStart = rowStartOffset + i;
      final rowCells = data.cells[rowStart] ??= {};

      for (final cell in row.cells) {
        var columnStart = 0;
        while (rowCells.containsKey(columnStart)) {
          columnStart++;
        }

        final columnSpan = cell.columnSpan > 0 ? cell.columnSpan : 1;
        final rowSpan = min(
          rowSpanMax,
          cell.rowSpan > 0
              ? cell.rowSpan
              : cell.rowSpan == 0
                  ? group.rows.length
                  : 1,
        );

        final builderIndex = data.builders.length;
        for (var r = 0; r < rowSpan; r++) {
          final rCells = data.cells[rowStart + r] ??= {};
          data.rows = data.cells.length;

          for (var c = 0; c < columnSpan; c++) {
            rCells[columnStart + c] = builderIndex;
          }
        }
        data.columns = max(data.columns, columnStart + 1);
        data.rows = data.cells.keys.length;

        final cellTree = cell.tree;
        final cssBorderParsed = tryParseBorder(cellTree);
        final cssBorder = cssBorderParsed.inherit
            ? tryParseBorder(tableTree).copyFrom(cssBorderParsed)
            : cssBorderParsed;

        data.builders.add((context) {
          Widget? child = cell.child;

          final cellStyle = cellTree.styleBuilder.build(context);
          final border = cssBorder.getBorder(cellStyle);
          if (border != null) {
            child = wf.buildPadding(cellTree, cell.child, border.dimensions);
          }
          if (child == null) {
            return null;
          }

          final v = cellTree[kCssVerticalAlign]?.term;
          if (v == kCssVerticalAlignBaseline) {
            child = ValignBaseline(index: rowStart, child: child);
          }

          return HtmlTableCell(
            border: border,
            columnSpan: min(columnSpan, data.columns - columnStart),
            columnStart: columnStart,
            rowSpan: rowSpan,
            rowStart: rowStart,
            width: cell.width?.getSizing(cellStyle),
            child: child,
          );
        });
      }
    }
  }

  static BuildOp cellPaddingOp(double px) => BuildOp(
        onChild: (_, subTree) => (subTree.element.localName == 'td' ||
                subTree.element.localName == 'th')
            ? subTree[kCssPadding] = '${px}px'
            : null,
      );

  static BuildOp borderOp(double border, double borderSpacing) => BuildOp(
        defaultStyles: (_) => {
          if (border > 0.0) kCssBorder: '${border}px solid black',
          kCssBorderCollapse: kCssBorderCollapseSeparate,
          kCssBorderSpacing: '${borderSpacing}px',
        },
        onChild: border > 0
            ? (_, subTree) {
                switch (subTree.element.localName) {
                  case kTagTableCell:
                  case kTagTableHeaderCell:
                    subTree[kCssBorder] = kCssBorderInherit;
                }
              }
            : null,
      );

  static String? _getCssDisplayValue(BuildTree tree) {
    for (final style in tree.element.styles.reversed) {
      if (style.property == kCssDisplay) {
        final term = style.term;
        if (term != null) {
          return term;
        }
      }
    }

    switch (tree.element.localName) {
      case kTagTableRow:
        return kCssDisplayTableRow;
      case kTagTableHeaderGroup:
        return kCssDisplayTableHeaderGroup;
      case kTagTableRowGroup:
        return kCssDisplayTableRowGroup;
      case kTagTableFooterGroup:
        return kCssDisplayTableFooterGroup;
      case kTagTableHeaderCell:
      case kTagTableCell:
        return kCssDisplayTableCell;
      case kTagTableCaption:
        return kCssDisplayTableCaption;
    }

    return null;
  }
}

class _TagTableRow {
  final TagTable parent;
  final _TagTableDataRow row;

  late final BuildOp _rowOp;
  late final BuildOp _cellOp;

  _TagTableRow(this.parent, this.row) {
    _rowOp = BuildOp(onChild: _onRowChild);
    _cellOp = BuildOp(
      onWidgets: _onCellWidgets,
      priority: BuildOp.kPriorityMax,
    );
  }

  void _onRowChild(BuildTree rowTree, BuildTree cellTree) {
    final e = cellTree.element;
    if (e.parent != rowTree.element) {
      return;
    }
    if (TagTable._getCssDisplayValue(cellTree) != kCssDisplayTableCell) {
      return;
    }

    final attrs = e.attributes;
    if (attrs.containsKey(kAttributeValign)) {
      cellTree[kCssVerticalAlign] = attrs[kAttributeValign]!;
    }

    cellTree.register(_cellOp);
    StyleBorder.skip(cellTree);
    StyleSizing.skip(cellTree);
  }

  Iterable<Widget>? _onCellWidgets(
    BuildTree cellTree,
    Iterable<WidgetPlaceholder> widgets,
  ) {
    final child =
        parent.wf.buildColumnPlaceholder(cellTree, widgets) ?? widget0;

    final widthValue = cellTree[kCssWidth]?.value;
    final width = widthValue != null ? tryParseCssLength(widthValue) : null;

    final attributes = cellTree.element.attributes;
    row.cells.add(
      _TagTableDataCell(
        cellTree,
        child: child,
        columnSpan: tryParseIntFromMap(attributes, kAttributeColspan) ?? 1,
        rowSpan: tryParseIntFromMap(attributes, kAttributeRowspan) ?? 1,
        width: width,
      ),
    );

    return [child];
  }
}

class _TagTableRowGroup {
  final TagTable parent;
  final List<_TagTableDataRow> rows;

  late final BuildOp _groupOp;

  _TagTableRowGroup(this.parent, this.rows) {
    _groupOp = BuildOp(onChild: _onGroupChild);
  }

  void _onGroupChild(BuildTree groupTree, BuildTree rowTree) {
    if (rowTree.element.parent != groupTree.element) {
      return;
    }
    if (TagTable._getCssDisplayValue(rowTree) != kCssDisplayTableRow) {
      return;
    }

    final row = _TagTableDataRow();
    rows.add(row);
    rowTree.register(_TagTableRow(parent, row)._rowOp);
  }
}

class _TagTableData {
  final bodies = <_TagTableDataGroup>[];
  final captions = <Widget>[];
  final footer = _TagTableDataGroup();
  final header = _TagTableDataGroup();

  final builders = <HtmlTableCell? Function(BuildContext)>[];
  final cells = <int, Map<int, int>>{};
  int columns = 0;
  int rows = 0;

  _TagTableDataGroup get body {
    final body = _TagTableDataGroup();
    bodies.add(body);
    return body;
  }
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
  final int columnSpan;
  final BuildTree tree;
  final int rowSpan;
  final CssLength? width;

  const _TagTableDataCell(
    this.tree, {
    required this.child,
    required this.columnSpan,
    required this.rowSpan,
    this.width,
  });
}
