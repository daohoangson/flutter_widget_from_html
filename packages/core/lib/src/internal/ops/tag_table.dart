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
  final companion = HtmlTableCompanion();
  final WidgetFactory wf;

  final _data = _TagTableData();

  BuildOp? _captionOp;

  TagTable(this.wf);

  BuildOp get buildOp => BuildOp(
        debugLabel: kTagTable,
        onChild: (tableTree, subTree) {
          if (subTree.element.parent != tableTree.element) {
            return;
          }

          final which = _getCssDisplayValue(subTree);
          _TagTableDataGroup? latestGroup;
          switch (which) {
            case kCssDisplayTableRow:
              latestGroup ??= _data.body;
              final row = _TagTableDataRow();
              latestGroup.rows.add(row);
              subTree.register(_TagTableRow(row).buildOp);
              break;
            case kCssDisplayTableHeaderGroup:
            case kCssDisplayTableRowGroup:
            case kCssDisplayTableFooterGroup:
              final rows = which == kCssDisplayTableHeaderGroup
                  ? _data.header.rows
                  : which == kCssDisplayTableRowGroup
                      ? _data.body.rows
                      : _data.footer.rows;
              subTree.register(_TagTableRowGroup(rows).buildOp);
              latestGroup = null;
              break;
            case kCssDisplayTableCaption:
              subTree.register(
                _captionOp ??= BuildOp(
                  debugLabel: kTagTableCaption,
                  onBuilt: (captionTree, caption) {
                    _data.captions.add(caption);
                    return captionTree.placeholder;
                  },
                ),
              );
              break;
          }
        },
        onTree: (tableTree) {
          StyleBorder.skip(tableTree);
          StyleSizing.treatHeightAsMinHeight(tableTree);
        },
        onBuilt: (tableTree, _) {
          _prepareHtmlTableCellBuilders(tableTree, _data.header);
          for (final body in _data.bodies) {
            _prepareHtmlTableCellBuilders(tableTree, body);
          }
          _prepareHtmlTableCellBuilders(tableTree, _data.footer);
          if (_data.builders.isEmpty) {
            return null;
          }

          final border = tryParseBorder(tableTree);
          final borderCollapse = tableTree[kCssBorderCollapse]?.term;
          final borderSpacingExpression = tableTree[kCssBorderSpacing]?.value;
          final borderSpacing = borderSpacingExpression != null
              ? tryParseCssLength(borderSpacingExpression)
              : null;

          return wf.buildColumnPlaceholder(
            tableTree,
            [
              ..._data.captions,
              tableTree.placeholder.wrapWith((context, _) {
                final tableStyle = tableTree.styleBuilder.build(context);

                return HtmlTable(
                  border: border.getBorder(tableStyle),
                  borderCollapse: borderCollapse == kCssBorderCollapseCollapse,
                  borderSpacing: borderSpacing?.getValue(tableStyle) ?? 0.0,
                  companion: companion,
                  textDirection: tableStyle.textDirection,
                  children: List.from(
                    _data.builders
                        .map((f) => f(context))
                        .where((e) => e != null),
                    growable: false,
                  ),
                );
              }),
            ],
          );
        },
      );

  void _prepareHtmlTableCellBuilders(
    BuildTree tableTree,
    _TagTableDataGroup group,
  ) {
    final rowStartOffset = _data.rows;
    final rowSpanMax = group.rows.length;

    for (var i = 0; i < group.rows.length; i++) {
      final row = group.rows[i];
      final rowStart = rowStartOffset + i;
      final rowCells = _data.cells[rowStart] ??= {};

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
        final cell0 = _TagTableDataCell(
          cell.tree,
          child: cell.child,
          columnSpan: columnSpan,
          columnStart: columnStart,
          rowSpan: rowSpan,
          rowStart: rowStart,
        );

        for (var r = 0; r < rowSpan; r++) {
          final rCells = _data.cells[rowStart + r] ??= {};
          for (var c = 0; c < columnSpan; c++) {
            rCells[columnStart + c] = cell0;
          }
        }

        final cellTree = cell.tree;
        final cssBorderParsed = tryParseBorder(cellTree);
        final cssBorder = cssBorderParsed.inherit
            ? tryParseBorder(tableTree).copyFrom(cssBorderParsed)
            : cssBorderParsed;

        _data.builders.add((context) {
          Widget? child = cell.child;

          final cellStyle = cellTree.styleBuilder.build(context);
          final border = cssBorder.getBorder(cellStyle);
          if (border != null) {
            child = wf.buildPadding(cellTree, cell.child, border.dimensions);
          }
          if (child == null) {
            return null;
          }

          return HtmlTableCell(
            border: border,
            columnSpan: min(columnSpan, _data.columns - columnStart),
            columnStart: columnStart,
            rowSpan: rowSpan,
            rowStart: rowStart,
            child: child,
          );
        });
      }
    }
  }

  static BuildOp cellPaddingOp(double px) => BuildOp(
        debugLabel: '$kTagTable--$kAttributeCellPadding',
        onChild: (_, subTree) => (subTree.element.localName == 'td' ||
                subTree.element.localName == 'th')
            ? subTree[kCssPadding] = '${px}px'
            : null,
      );

  static BuildOp borderOp(double border, double borderSpacing) => BuildOp(
        debugLabel: '$kTagTable--$kAttributeBorder',
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

extension _BuildTreeTagTable on BuildTree {
  WidgetPlaceholder get placeholder =>
      WidgetPlaceholder(debugLabel: element.localName);
}

class _TagTableRow {
  final _TagTableDataRow row;

  late final BuildOp _cellOp;
  late final BuildOp _valignBaselineOp;

  _TagTableRow(this.row) {
    _cellOp = BuildOp(
      debugLabel: kTagTableCell,
      onBuilt: (cellTree, cellWidget) {
        final attributes = cellTree.element.attributes;
        row.cells.add(
          _TagTableDataCell(
            cellTree,
            child: cellWidget,
            columnSpan: tryParseIntFromMap(attributes, kAttributeColspan) ?? 1,
            rowSpan: tryParseIntFromMap(attributes, kAttributeRowspan) ?? 1,
          ),
        );

        return cellTree.placeholder;
      },
      priority: BuildOp.kPriorityMax,
    );
    _valignBaselineOp = BuildOp(
      debugLabel: '$kTagTable--$kCssVerticalAlign',
      onBuilt: (cellTree, cellPlaceholder) {
        final v = cellTree[kCssVerticalAlign]?.term;
        if (v != kCssVerticalAlignBaseline) {
          return null;
        }

        return cellPlaceholder
            .wrapWith((_, child) => HtmlTableValignBaseline(child: child));
      },
      priority: StyleVerticalAlign.kPriority4k3,
    );
  }

  BuildOp get buildOp => BuildOp(
        debugLabel: kTagTableRow,
        onChild: (rowTree, cellTree) {
          if (cellTree.element.parent != rowTree.element) {
            return;
          }
          if (TagTable._getCssDisplayValue(cellTree) != kCssDisplayTableCell) {
            return;
          }

          final attrs = cellTree.element.attributes;
          if (attrs.containsKey(kAttributeValign)) {
            cellTree[kCssVerticalAlign] = attrs[kAttributeValign]!;
          }

          cellTree.register(_cellOp);
          StyleBorder.skip(cellTree);
          StyleSizing.treatHeightAsMinHeight(cellTree);
          cellTree.register(_valignBaselineOp);
        },
      );
}

class _TagTableRowGroup {
  final List<_TagTableDataRow> rows;

  _TagTableRowGroup(this.rows);

  BuildOp get buildOp => BuildOp(
        debugLabel: kTagTableRowGroup,
        onChild: (groupTree, rowTree) {
          if (rowTree.element.parent != groupTree.element) {
            return;
          }
          if (TagTable._getCssDisplayValue(rowTree) != kCssDisplayTableRow) {
            return;
          }

          final row = _TagTableDataRow();
          rows.add(row);
          rowTree.register(_TagTableRow(row).buildOp);
        },
      );
}

@immutable
class _TagTableData {
  final bodies = <_TagTableDataGroup>[];
  final captions = <WidgetPlaceholder>[];
  final footer = _TagTableDataGroup();
  final header = _TagTableDataGroup();

  final cells = <int, Map<int, _TagTableDataCell>>{};
  final builders = <HtmlTableCell? Function(BuildContext)>[];

  _TagTableDataGroup get body {
    final body = _TagTableDataGroup();
    bodies.add(body);
    return body;
  }

  int get columns => cells.entries.fold(
        0,
        (prev, row) {
          final cells = row.value.entries;
          return max(
            prev,
            cells.fold(
              0,
              (prev, cell) => max(prev, (cell.value.columnStart ?? 0) + 1),
            ),
          );
        },
      );

  int get rows => cells.keys.length;
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
  final int? columnStart;
  final BuildTree tree;
  final int rowSpan;
  final int? rowStart;

  const _TagTableDataCell(
    this.tree, {
    required this.child,
    required this.columnSpan,
    this.columnStart,
    required this.rowSpan,
    this.rowStart,
  });
}
