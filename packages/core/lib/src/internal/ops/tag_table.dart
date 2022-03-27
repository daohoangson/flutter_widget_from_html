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
  final BuildMetadata tableMeta;
  final WidgetFactory wf;

  final _data = _TagTableData();

  late final BuildOp _captionOp;
  late final BuildOp _tableOp;

  TagTable(this.wf, this.tableMeta) {
    _captionOp = BuildOp(
      onWidgets: (captionMeta, widgets) {
        final child = wf.buildColumnPlaceholder(captionMeta, widgets);
        if (child != null) {
          _data.captions.add(child);
        }
        return [];
      },
      priority: BuildOp.kPriorityMax,
    );
    _tableOp = BuildOp(
      onChild: onChild,
      onTree: onTree,
      onWidgets: onWidgets,
      priority: 0,
    );
  }

  BuildOp get op => _tableOp;

  void onChild(BuildMetadata childMeta) {
    if (childMeta.element.parent != tableMeta.element) {
      return;
    }

    final which = _getCssDisplayValue(childMeta);
    _TagTableDataGroup? latestGroup;
    switch (which) {
      case kCssDisplayTableRow:
        latestGroup ??= _data.body;
        final row = _TagTableDataRow();
        latestGroup.rows.add(row);
        childMeta.register(_TagTableRow(this, childMeta, row).op);
        break;
      case kCssDisplayTableHeaderGroup:
      case kCssDisplayTableRowGroup:
      case kCssDisplayTableFooterGroup:
        final rows = which == kCssDisplayTableHeaderGroup
            ? _data.header.rows
            : which == kCssDisplayTableRowGroup
                ? _data.body.rows
                : _data.footer.rows;
        childMeta.register(_TagTableRowGroup(this, childMeta, rows).op);
        latestGroup = null;
        break;
      case kCssDisplayTableCaption:
        childMeta.register(_captionOp);
        break;
    }
  }

  void onTree(BuildMetadata _, BuildTree tree) {
    StyleBorder.skip(tableMeta);
    StyleSizing.skip(tableMeta);
  }

  Iterable<Widget> onWidgets(BuildMetadata _, Iterable<WidgetPlaceholder> __) {
    _prepareHtmlTableCaptionBuilders();
    _prepareHtmlTableCellBuilders(_data.header);
    for (final body in _data.bodies) {
      _prepareHtmlTableCellBuilders(body);
    }
    _prepareHtmlTableCellBuilders(_data.footer);
    if (_data.builders.isEmpty) {
      return [];
    }

    final border = tryParseBorder(tableMeta);
    final borderCollapse = tableMeta[kCssBorderCollapse]?.term;
    final borderSpacingExpression = tableMeta[kCssBorderSpacing]?.value;
    final borderSpacing = borderSpacingExpression != null
        ? tryParseCssLength(borderSpacingExpression)
        : null;

    return [
      WidgetPlaceholder<BuildMetadata>(tableMeta).wrapWith((context, _) {
        final tsh = tableMeta.tsb.build(context);

        return HtmlTable(
          border: border.getBorder(tsh),
          borderCollapse: borderCollapse == kCssBorderCollapseCollapse,
          borderSpacing: borderSpacing?.getValue(tsh) ?? 0.0,
          textDirection: tsh.textDirection,
          children: List.from(
            _data.builders.map((f) => f(context)).where((e) => e != null),
            growable: false,
          ),
        );
      }),
    ];
  }

  void _prepareHtmlTableCaptionBuilders() {
    for (final child in _data.captions) {
      final rowIndex = _data.rows;
      final builderIndex = _data.builders.length;
      _data.cells[rowIndex] = {0: builderIndex};
      _data.columns = max(_data.columns, 1);
      _data.rows = _data.cells.keys.length;

      _data.builders.add(
        (_) => HtmlTableCaption(
          columnSpan: _data.columns,
          rowIndex: rowIndex,
          child: child,
        ),
      );
    }
  }

  void _prepareHtmlTableCellBuilders(_TagTableDataGroup group) {
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

        final builderIndex = _data.builders.length;
        for (var r = 0; r < rowSpan; r++) {
          final rCells = _data.cells[rowStart + r] ??= {};
          _data.rows = _data.cells.length;

          for (var c = 0; c < columnSpan; c++) {
            rCells[columnStart + c] = builderIndex;
          }
        }
        _data.columns = max(_data.columns, columnStart + 1);
        _data.rows = _data.cells.keys.length;

        final cellMeta = cell.meta;
        final cssBorderParsed = tryParseBorder(cellMeta);
        final cssBorder = cssBorderParsed.inherit
            ? tryParseBorder(tableMeta).copyFrom(cssBorderParsed)
            : cssBorderParsed;

        _data.builders.add((context) {
          Widget? child = cell.child;

          final tsh = cellMeta.tsb.build(context);
          final border = cssBorder.getBorder(tsh);
          if (border != null) {
            child = wf.buildPadding(cellMeta, cell.child, border.dimensions);
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
            width: cell.width?.getSizing(tsh),
            child: child,
          );
        });
      }
    }
  }

  static BuildOp cellPaddingOp(double px) => BuildOp(
        onChild: (meta) =>
            (meta.element.localName == 'td' || meta.element.localName == 'th')
                ? meta[kCssPadding] = '${px}px'
                : null,
      );

  static BuildOp borderOp(double border, double borderSpacing) => BuildOp(
        defaultStyles: (_) => {
          if (border > 0.0) kCssBorder: '${border}px solid black',
          kCssBorderCollapse: kCssBorderCollapseSeparate,
          kCssBorderSpacing: '${borderSpacing}px',
        },
        onChild: border > 0
            ? (meta) {
                switch (meta.element.localName) {
                  case kTagTableCell:
                  case kTagTableHeaderCell:
                    meta[kCssBorder] = kCssBorderInherit;
                }
              }
            : null,
      );

  static String? _getCssDisplayValue(BuildMetadata meta) {
    for (final style in meta.element.styles.reversed) {
      if (style.property == kCssDisplay) {
        final term = style.term;
        if (term != null) {
          return term;
        }
      }
    }

    switch (meta.element.localName) {
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
  late final BuildOp op;
  final TagTable parent;
  final _TagTableDataRow row;
  final BuildMetadata rowMeta;

  late final BuildOp _cellOp;
  late final BuildOp _valignBaselineOp;

  _TagTableRow(this.parent, this.rowMeta, this.row) {
    op = BuildOp(onChild: onChild);
    _cellOp = BuildOp(
      onWidgets: (cellMeta, widgets) {
        final child =
            parent.wf.buildColumnPlaceholder(cellMeta, widgets) ?? widget0;

        final widthValue = cellMeta[kCssWidth]?.value;
        final width = widthValue != null ? tryParseCssLength(widthValue) : null;

        final attributes = cellMeta.element.attributes;
        row.cells.add(
          _TagTableDataCell(
            cellMeta,
            child: child,
            columnSpan: tryParseIntFromMap(attributes, kAttributeColspan) ?? 1,
            rowSpan: tryParseIntFromMap(attributes, kAttributeRowspan) ?? 1,
            width: width,
          ),
        );

        return [child];
      },
      priority: BuildOp.kPriorityMax,
    );
    _valignBaselineOp = BuildOp(
      onWidgets: (cellMeta, widgets) {
        final v = cellMeta[kCssVerticalAlign]?.term;
        if (v != kCssVerticalAlignBaseline) {
          return widgets;
        }

        return listOrNull(
          parent.wf
              .buildColumnPlaceholder(cellMeta, widgets)
              ?.wrapWith((_, child) {
            return HtmlTableValignBaseline(child: child);
          }),
        );
      },
      priority: StyleVerticalAlign.kPriority4k3,
    );
  }

  void onChild(BuildMetadata childMeta) {
    if (childMeta.element.parent != rowMeta.element) {
      return;
    }
    if (TagTable._getCssDisplayValue(childMeta) != kCssDisplayTableCell) {
      return;
    }

    final attrs = childMeta.element.attributes;
    if (attrs.containsKey(kAttributeValign)) {
      childMeta[kCssVerticalAlign] = attrs[kAttributeValign]!;
    }

    childMeta.register(_cellOp);
    StyleBorder.skip(childMeta);
    StyleSizing.skip(childMeta);
    childMeta.register(_valignBaselineOp);
  }
}

class _TagTableRowGroup {
  final TagTable parent;
  final List<_TagTableDataRow> rows;
  final BuildMetadata groupMeta;

  late BuildOp op;

  _TagTableRowGroup(this.parent, this.groupMeta, this.rows) {
    op = BuildOp(onChild: onChild);
  }

  void onChild(BuildMetadata childMeta) {
    if (childMeta.element.parent != groupMeta.element) {
      return;
    }
    if (TagTable._getCssDisplayValue(childMeta) != kCssDisplayTableRow) {
      return;
    }

    final row = _TagTableDataRow();
    rows.add(row);
    childMeta.register(_TagTableRow(parent, childMeta, row).op);
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
  final int? columnStart;
  final bool isCaption;
  final BuildMetadata meta;
  final int rowSpan;
  final int? rowStart;
  final CssLength? width;

  const _TagTableDataCell(
    this.meta, {
    required this.child,
    required this.columnSpan,
    this.columnStart,
    this.isCaption = false,
    required this.rowSpan,
    this.rowStart,
    this.width,
  });
}
