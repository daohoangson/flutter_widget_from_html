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
    borderOp = const BuildOp.v2(
      debugLabel: '$kTagTable--$kAttributeBorder',
      defaultStyles: _borderDefaultStyles,
      onVisitChild: _onBorderChild,
      priority: Priority.tagTableAttributeBorder,
    );

    cellPaddingOp = const BuildOp.v2(
      debugLabel: '$kTagTable--$kAttributeCellPadding',
      onVisitChild: _onCellPaddingChild,
      priority: Priority.tagTableAttributeCellPadding,
    );

    tableOp = BuildOp(
      debugLabel: kTagTable,
      onParsed: _onTableParsed,
      onRenderBlock: _onTableRenderBlock,
      onVisitChild: _onTableChild,
      priority: Early.tagTableRenderBlock,
    );
  }

  Widget _onTableRenderBlock(
    BuildTree tableTree,
    WidgetPlaceholder placeholder,
  ) {
    final data = tableTree.tableData;

    _prepareHtmlTableCaptionBuilders(data);
    _prepareHtmlTableCellBuilders(tableTree, data.header);
    for (final body in data.bodies) {
      _prepareHtmlTableCellBuilders(tableTree, body);
    }
    _prepareHtmlTableCellBuilders(tableTree, data.footer);
    if (data.builders.isEmpty) {
      return placeholder;
    }

    final border = tryParseBorder(tableTree);
    final borderCollapse = tableTree.getStyle(kCssBorderCollapse)?.term;
    final borderSpacingExpression =
        tableTree.getStyle(kCssBorderSpacing)?.value;
    final borderSpacing = borderSpacingExpression != null
        ? tryParseCssLength(borderSpacingExpression)
        : null;

    final layoutBuilder = HtmlLayoutBuilder(
      builder: (context, bc) {
        final resolved = tableTree.inheritanceResolvers.resolve(context);
        Widget built = ValignBaselineContainer(
          child: HtmlTable(
            border: border.getBorder(resolved),
            borderCollapse: borderCollapse == kCssBorderCollapseCollapse,
            borderSpacing: borderSpacing?.getValue(resolved) ?? 0.0,
            textDirection: resolved.directionOrLtr,
            children: List.from(
              data.builders
                  .map((builder) => builder(context))
                  .where(_htmlTableCellIsNotNull),
              growable: false,
            ),
          ),
        );

        // provide hints to size the columns properly
        built = CssSizingHint(
          maxWidth: bc.maxWidth,
          minWidth: bc.minWidth,
          child: built,
        );

        if (bc.maxWidth.isFinite) {
          built = wf.buildHorizontalScrollView(tableTree, built) ?? built;
        }

        return built;
      },
    );

    return WidgetPlaceholder(debugLabel: kTagTable, child: layoutBuilder);
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
        final rowSpanDefault = cell.rowSpan == 0 ? group.rows.length : 1;
        final rowSpan = min(
          rowSpanMax,
          cell.rowSpan > 0 ? cell.rowSpan : rowSpanDefault,
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

          final resolved = cellTree.inheritanceResolvers.resolve(context);
          final border = cssBorder.getBorder(resolved);
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
            child: child,
          );
        });
      }
    }
  }

  static StylesMap _borderDefaultStyles(dom.Element element) {
    final attrs = element.attributes;
    final border = element.attributeBorder;
    final borderSpacing = tryParseDoubleFromMap(attrs, kAttributeCellSpacing);

    return {
      if (border > 0.0) kCssBorder: '${border}px solid',
      kCssBorderCollapse: kCssBorderCollapseSeparate,
      kCssBorderSpacing: '${borderSpacing ?? 2.0}px',
    };
  }

  static StylesMap _cssBorderInherit(dom.Element _) =>
      {kCssBorder: kCssBorderInherit};

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

  static bool _htmlTableCellIsNotNull(HtmlTableCell? cell) => cell != null;

  static void _onBorderChild(BuildTree tableTree, BuildTree subTree) {
    if (tableTree.element.attributeBorder > 0) {
      switch (subTree.element.localName) {
        case kTagTableCell:
        case kTagTableHeaderCell:
          subTree.register(
            const BuildOp.v2(
              debugLabel: '$kTagTable--$kAttributeBorder--child',
              defaultStyles: _cssBorderInherit,
              priority: Early.tagTableAttributeBorderChild,
            ),
          );
      }
    }
  }

  static void _onCellPaddingChild(BuildTree tableTree, BuildTree subTree) {
    if (subTree.element.localName == 'td' ||
        subTree.element.localName == 'th') {
      final attrs = tableTree.element.attributes;
      final cellPadding = tryParseDoubleFromMap(attrs, kAttributeCellPadding);
      subTree.register(
        BuildOp(
          debugLabel: '$kTagTable--$kAttributeCellPadding--child',
          defaultStyles: (_) => {kCssPadding: '${cellPadding ?? 1.0}px'},
          priority: Early.tagTableAttributeCellPaddingChild,
        ),
      );
    }
  }

  static void _onTableChild(BuildTree tableTree, BuildTree subTree) {
    if (subTree.element.parent != tableTree.element) {
      return;
    }

    final data = tableTree.tableData;
    final which = _getCssDisplayValue(subTree);
    switch (which) {
      case kCssDisplayTableCaption:
        subTree.register(
          BuildOp(
            alwaysRenderBlock: true,
            debugLabel: kTagTableCaption,
            onRenderedBlock: (_, block) => data.captions.add(block),
          ),
        );
      case kCssDisplayTableHeaderGroup:
      case kCssDisplayTableRowGroup:
      case kCssDisplayTableFooterGroup:
        final _TagTableRowGroup group;
        switch (which) {
          case kCssDisplayTableHeaderGroup:
            group = data.header;
          case kCssDisplayTableRowGroup:
            group = data.newBody();
          default:
            group = data.footer;
        }
        subTree.register(group._groupOp);
      case kCssDisplayTableRow:
        subTree.register(data.newBody().newRow()._rowOp);
      case kCssDisplayTableCell:
        data.latestBody.latestRow._registerCellOp(subTree);
    }
  }

  static BuildTree _onTableParsed(BuildTree tableTree) {
    StyleBorder.skip(tableTree);
    return tableTree;
  }
}

extension on BuildTree {
  _TagTableData get tableData =>
      getNonInherited<_TagTableData>() ?? setNonInherited(_TagTableData());
}

extension on dom.Element {
  double get attributeBorder =>
      tryParseDoubleFromMap(attributes, kAttributeBorder) ?? 0.0;
}

class _TagTableRow {
  final cells = <_TagTableDataCell>[];

  late final BuildOp _rowOp;
  late final BuildOp _cellOp;

  _TagTableRow() {
    _rowOp = BuildOp(
      alwaysRenderBlock: true,
      debugLabel: kTagTableRow,
      onVisitChild: _onRowChild,
      priority: Priority.tagTableRow,
    );
    _cellOp = BuildOp(
      alwaysRenderBlock: true,
      debugLabel: kTagTableCell,
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

    for (final style in rowTree.styles) {
      // forward all row styles to its cells, this is quite dangerous...
      cellTree.styles.add(style);
    }

    _registerCellOp(cellTree);
  }

  void _onCellRenderedBlock(BuildTree cellTree, Widget block) {
    final attributes = cellTree.element.attributes;
    cells.add(
      _TagTableDataCell(
        cellTree,
        child: block,
        columnSpan: tryParseIntFromMap(attributes, kAttributeColspan) ?? 1,
        rowSpan: tryParseIntFromMap(attributes, kAttributeRowspan) ?? 1,
      ),
    );
  }

  void _registerCellOp(BuildTree cellTree) {
    if (cellTree.element.attributes.containsKey(kAttributeValign)) {
      cellTree.register(
        const BuildOp.v2(
          debugLabel: kTagTableCell,
          defaultStyles: _cssVerticalAlignFromAttribute,
          priority: Early.tagTableCellValignParsed,
        ),
      );
    }

    cellTree.register(_cellOp);
    StyleBorder.skip(cellTree);
    StyleSizing.registerBlockOp(cellTree);
  }

  static StylesMap _cssVerticalAlignFromAttribute(dom.Element element) {
    final value = element.attributes[kAttributeValign];
    return value != null ? {kCssVerticalAlign: value} : const {};
  }
}

class _TagTableRowGroup {
  final rows = <_TagTableRow>[];

  late final BuildOp _groupOp;

  _TagTableRowGroup(String debugLabel) {
    _groupOp = BuildOp(
      debugLabel: debugLabel,
      onVisitChild: _onGroupChild,
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
  final bodies = <_TagTableRowGroup>[];
  final captions = <Widget>[];
  final footer = _TagTableRowGroup(kCssDisplayTableFooterGroup);
  final header = _TagTableRowGroup(kCssDisplayTableHeaderGroup);

  final builders = <HtmlTableCell? Function(BuildContext context)>[];
  final cells = <int, Map<int, int>>{};
  int columns = 0;
  int rows = 0;

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

  const _TagTableDataCell(
    this.tree, {
    required this.child,
    required this.columnSpan,
    required this.rowSpan,
  });
}
