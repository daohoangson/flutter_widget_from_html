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
      defaultStyles: (element) {
        final data = element.parse();
        return {
          if (data.border > 0.0) kCssBorder: '${data.border}px solid black',
          kCssBorderCollapse: kCssBorderCollapseSeparate,
          kCssBorderSpacing: '${data.borderSpacing}px',
        };
      },
      onChild: (tree, subTree) {
        final data = tree.data;
        if (data.border > 0) {
          switch (subTree.element.localName) {
            case kTagTableCell:
            case kTagTableHeaderCell:
              subTree[kCssBorder] = kCssBorderInherit;
          }
        }
      },
    );

    cellPaddingOp = BuildOp(
      debugLabel: '$kTagTable--$kAttributeCellPadding',
      onChild: (tree, subTree) {
        if (subTree.element.localName == 'td' ||
            subTree.element.localName == 'th') {
          final data = tree.data;
          subTree[kCssPadding] = '${data.cellPadding}px';
        }
      },
    );

    tableOp = BuildOp(
      debugLabel: kTagTable,
      onBuilt: _onTableBuilt,
      onChild: _onTableChild,
      onTree: _onTableTree,
      priority: 0,
    );
  }

  void _onTableChild(BuildTree tableTree, BuildTree subTree) {
    if (subTree.element.parent != tableTree.element) {
      return;
    }

    final data = tableTree.data;
    final which = _getCssDisplayValue(subTree);
    _TagTableDataGroup? latestGroup;
    switch (which) {
      case kCssDisplayTableRow:
        latestGroup ??= data.body;
        final row = _TagTableDataRow();
        latestGroup.rows.add(row);
        subTree.register(_TagTableRow(row)._rowOp);
        break;
      case kCssDisplayTableHeaderGroup:
      case kCssDisplayTableRowGroup:
      case kCssDisplayTableFooterGroup:
        final rows = which == kCssDisplayTableHeaderGroup
            ? data.header.rows
            : which == kCssDisplayTableRowGroup
                ? data.body.rows
                : data.footer.rows;
        subTree.register(_TagTableRowGroup(which!, rows)._groupOp);
        latestGroup = null;
        break;
      case kCssDisplayTableCaption:
        subTree.register(
          BuildOp(
            debugLabel: kTagTableCaption,
            onBuilt: (captionTree, placeholder) {
              if (placeholder.isEmpty) {
                return null;
              }
              data.captions.add(placeholder);
              return placeholder;
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

  Widget? _onTableBuilt(BuildTree tableTree, WidgetPlaceholder _) {
    final data = tableTree.data;

    _prepareHtmlTableCaptionBuilders(data);
    _prepareHtmlTableCellBuilders(tableTree, data.header);
    for (final body in data.bodies) {
      _prepareHtmlTableCellBuilders(tableTree, body);
    }
    _prepareHtmlTableCellBuilders(tableTree, data.footer);
    if (data.builders.isEmpty) {
      return null;
    }

    final border = tryParseBorder(tableTree);
    final borderCollapse = tableTree[kCssBorderCollapse]?.term;
    final borderSpacingExpression = tableTree[kCssBorderSpacing]?.value;
    final borderSpacing = borderSpacingExpression != null
        ? tryParseCssLength(borderSpacingExpression)
        : null;

    return WidgetPlaceholder(
      debugLabel: kTagTable,
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
    _TagTableDataGroup group,
  ) {
    final data = tableTree.data;
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

extension _BuildTreeData on BuildTree {
  _TagTableData get data {
    final existing = value<_TagTableData>();
    if (existing != null) {
      return existing;
    }

    final newData = element.parse();
    value(newData);
    return newData;
  }
}

extension _BuildTreeDataParser on dom.Element {
  _TagTableData parse() {
    final attrs = attributes;
    return _TagTableData(
      border: tryParseDoubleFromMap(attrs, kAttributeBorder) ?? 0.0,
      borderSpacing: tryParseDoubleFromMap(attrs, kAttributeCellSpacing) ?? 2.0,
      cellPadding: tryParseDoubleFromMap(attrs, kAttributeCellPadding) ?? 1.0,
    );
  }
}

class _TagTableRow {
  final _TagTableDataRow row;

  late final BuildOp _rowOp;
  late final BuildOp _cellOp;

  _TagTableRow(this.row) {
    _rowOp = BuildOp(debugLabel: kTagTableRow, onChild: _onRowChild);
    _cellOp = BuildOp(
      debugLabel: kTagTableCell,
      onBuilt: _onCellBuilt,
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

  Widget? _onCellBuilt(BuildTree cellTree, WidgetPlaceholder placeholder) {
    final widthValue = cellTree[kCssWidth]?.value;
    final width = widthValue != null ? tryParseCssLength(widthValue) : null;

    final attributes = cellTree.element.attributes;
    row.cells.add(
      _TagTableDataCell(
        cellTree,
        child: placeholder,
        columnSpan: tryParseIntFromMap(attributes, kAttributeColspan) ?? 1,
        rowSpan: tryParseIntFromMap(attributes, kAttributeRowspan) ?? 1,
        width: width,
      ),
    );

    return placeholder;
  }
}

class _TagTableRowGroup {
  final List<_TagTableDataRow> rows;

  late final BuildOp _groupOp;

  _TagTableRowGroup(String debugLabel, this.rows) {
    _groupOp = BuildOp(debugLabel: debugLabel, onChild: _onGroupChild);
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
    rowTree.register(_TagTableRow(row)._rowOp);
  }
}

class _TagTableData {
  final double border;
  final double borderSpacing;
  final double cellPadding;

  final bodies = <_TagTableDataGroup>[];
  final captions = <WidgetPlaceholder>[];
  final footer = _TagTableDataGroup();
  final header = _TagTableDataGroup();

  final builders = <HtmlTableCell? Function(BuildContext)>[];
  final cells = <int, Map<int, int>>{};
  int columns = 0;
  int rows = 0;

  _TagTableData({
    required this.border,
    required this.borderSpacing,
    required this.cellPadding,
  });

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
