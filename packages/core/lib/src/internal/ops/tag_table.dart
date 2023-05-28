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

  late final BuildOp borderOp;
  late final BuildOp cellPaddingOp;
  late final BuildOp tableOp;

  TagTable(this.wf) {
    borderOp = BuildOp(
      debugLabel: '$kTagTable--$kAttributeBorder',
      defaultStyles: (tree) {
        final data = tree.tableData;
        return {
          if (data.border > 0.0) kCssBorder: '${data.border}px solid black',
          kCssBorderCollapse: kCssBorderCollapseSeparate,
          kCssBorderSpacing: '${data.borderSpacing}px',
        };
      },
      onChild: (tree, subTree) {
        final data = tree.tableData;
        if (data.border > 0) {
          switch (subTree.element.localName) {
            case kTagTableCell:
            case kTagTableHeaderCell:
              subTree.register(
                const BuildOp(
                  debugLabel: '$kTagTable--$kAttributeBorder--child',
                  defaultStyles: _cssBorderInherit,
                  priority: Early.tagTableAttributeBorderChild,
                ),
              );
          }
        }
      },
      priority: Priority.tagTableAttributeBorder,
    );

    cellPaddingOp = BuildOp(
      debugLabel: '$kTagTable--$kAttributeCellPadding',
      onChild: (tree, subTree) {
        if (subTree.element.localName == 'td' ||
            subTree.element.localName == 'th') {
          final data = tree.tableData;
          subTree.register(
            BuildOp(
              debugLabel: '$kTagTable--$kAttributeCellPadding--child',
              defaultStyles: (_) => {kCssPadding: '${data.cellPadding}px'},
              priority: Early.tagTableAttributeCellPaddingChild,
            ),
          );
        }
      },
      priority: Priority.tagTableAttributeCellPadding,
    );

    tableOp = BuildOp(
      debugLabel: kTagTable,
      onChild: _onTableChild,
      onParsed: _onTableParsed,
      onRenderBlock: _onTableRenderBlock,
      priority: Early.tagTableRenderBlock,
    );
  }

  void _onTableChild(BuildTree tableTree, BuildTree subTree) {
    if (subTree.element.parent != tableTree.element) {
      return;
    }

    final data = tableTree.tableData;
    final which = _getCssDisplayValue(subTree);
    switch (which) {
      case kCssDisplayTableCaption:
        subTree.register(
          BuildOp(
            debugLabel: kTagTableCaption,
            mustBeBlock: true,
            onRenderedBlock: (_, block) => data.captions.add(block),
          ),
        );
        break;
      case kCssDisplayTableHeaderGroup:
      case kCssDisplayTableRowGroup:
      case kCssDisplayTableFooterGroup:
        final group = which == kCssDisplayTableHeaderGroup
            ? data.header
            : which == kCssDisplayTableRowGroup
                ? data.newBody()
                : data.footer;
        subTree.register(group._groupOp);
        break;
      case kCssDisplayTableRow:
        subTree.register(data.newBody().newRow()._rowOp);
        break;
      case kCssDisplayTableCell:
        data.latestBody.latestRow._registerCellOp(subTree);
        break;
    }
  }

  BuildTree _onTableParsed(BuildTree tableTree) {
    StyleBorder.skip(tableTree);
    StyleSizing.skip(tableTree);
    return tableTree;
  }

  Widget _onTableRenderBlock(BuildTree tableTree, WidgetPlaceholder _) {
    final data = tableTree.tableData;

    _prepareHtmlTableCaptionBuilders(data);
    _prepareHtmlTableCellBuilders(tableTree, data.header);
    for (final body in data.bodies) {
      _prepareHtmlTableCellBuilders(tableTree, body);
    }
    _prepareHtmlTableCellBuilders(tableTree, data.footer);
    if (data.builders.isEmpty) {
      return _;
    }

    final border = tryParseBorder(tableTree);
    final borderCollapse = tableTree.getStyle(kCssBorderCollapse)?.term;
    final borderSpacingExpression =
        tableTree.getStyle(kCssBorderSpacing)?.value;
    final borderSpacing = borderSpacingExpression != null
        ? tryParseCssLength(borderSpacingExpression)
        : null;

    return WidgetPlaceholder(
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
      debugLabel: kTagTable,
    );
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
    _TagTableRowGroup group,
  ) {
    final data = tableTree.tableData;
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

          final v = cellTree.getStyle(kCssVerticalAlign)?.term;
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

  static StylesMap _cssBorderInherit(BuildTree _) =>
      {kCssBorder: kCssBorderInherit};
}

extension on BuildTree {
  _TagTableData get tableData {
    final existing = value<_TagTableData>();
    if (existing != null) {
      return existing;
    }

    final attrs = element.attributes;
    final newData = _TagTableData(
      border: tryParseDoubleFromMap(attrs, kAttributeBorder) ?? 0.0,
      borderSpacing: tryParseDoubleFromMap(attrs, kAttributeCellSpacing) ?? 2.0,
      cellPadding: tryParseDoubleFromMap(attrs, kAttributeCellPadding) ?? 1.0,
    );
    value(newData);
    return newData;
  }
}

class _TagTableRow {
  final cells = <_TagTableDataCell>[];

  late final BuildOp _rowOp;
  late final BuildOp _cellOp;

  _TagTableRow() {
    _rowOp = BuildOp(
      debugLabel: kTagTableRow,
      onChild: _onRowChild,
      priority: Priority.tagTableRow,
    );
    _cellOp = BuildOp(
      debugLabel: kTagTableCell,
      mustBeBlock: true,
      onRenderedBlock: _onCellRenderedBlock,
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

    _registerCellOp(cellTree);
  }

  void _onCellRenderedBlock(BuildTree cellTree, Widget block) {
    final widthValue = cellTree.getStyle(kCssWidth)?.value;
    final width = widthValue != null ? tryParseCssLength(widthValue) : null;

    final attributes = cellTree.element.attributes;
    cells.add(
      _TagTableDataCell(
        cellTree,
        child: block,
        columnSpan: tryParseIntFromMap(attributes, kAttributeColspan) ?? 1,
        rowSpan: tryParseIntFromMap(attributes, kAttributeRowspan) ?? 1,
        width: width,
      ),
    );
  }

  void _registerCellOp(BuildTree cellTree) {
    if (cellTree.element.attributes.containsKey(kAttributeValign)) {
      cellTree.register(
        const BuildOp(
          debugLabel: kTagTableCell,
          defaultStyles: _cssVerticalAlignFromAttribute,
          priority: Early.tagTableCellAttributeValign,
        ),
      );
    }

    cellTree.register(_cellOp);
    StyleBorder.skip(cellTree);
    StyleSizing.skip(cellTree);
  }

  static StylesMap _cssVerticalAlignFromAttribute(BuildTree tree) {
    final value = tree.element.attributes[kAttributeValign];
    return value != null ? {kCssVerticalAlign: value} : const {};
  }
}

class _TagTableRowGroup {
  final rows = <_TagTableRow>[];

  late final BuildOp _groupOp;

  _TagTableRowGroup(String debugLabel) {
    _groupOp = BuildOp(
      debugLabel: debugLabel,
      onChild: _onGroupChild,
      priority: Priority.tagTableRowGroup,
    );
  }

  _TagTableRow get latestRow {
    if (rows.isNotEmpty) {
      return rows.last;
    }

    final row = _TagTableRow();
    rows.add(row);
    return row;
  }

  _TagTableRow newRow() {
    final row = _TagTableRow();
    rows.add(row);
    return row;
  }

  void _onGroupChild(BuildTree groupTree, BuildTree rowTree) {
    if (rowTree.element.parent != groupTree.element) {
      return;
    }
    if (TagTable._getCssDisplayValue(rowTree) != kCssDisplayTableRow) {
      return;
    }

    rowTree.register(newRow()._rowOp);
  }
}

class _TagTableData {
  final double border;
  final double borderSpacing;
  final double cellPadding;

  final bodies = <_TagTableRowGroup>[];
  final captions = <Widget>[];
  final footer = _TagTableRowGroup(kCssDisplayTableFooterGroup);
  final header = _TagTableRowGroup(kCssDisplayTableHeaderGroup);

  final builders = <HtmlTableCell? Function(BuildContext)>[];
  final cells = <int, Map<int, int>>{};
  int columns = 0;
  int rows = 0;

  _TagTableData({
    required this.border,
    required this.borderSpacing,
    required this.cellPadding,
  });

  _TagTableRowGroup get latestBody =>
      bodies.isNotEmpty ? bodies.last : newBody();

  _TagTableRowGroup newBody() {
    final body = _TagTableRowGroup(kCssDisplayTableRowGroup);
    bodies.add(body);
    return body;
  }
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
