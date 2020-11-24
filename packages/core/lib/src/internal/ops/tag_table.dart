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
const kAttributeCellSpacing = 'cellspacing';

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

  final _captions = <BuildTree>[];
  final _data = _TagTableData();

  BuildOp _tableOp;

  TagTable(this.wf, this.tableMeta);

  BuildOp get op {
    _tableOp = BuildOp(
      onChild: onChild,
      onTree: onTree,
      onWidgets: onWidgets,
      priority: StyleSizing.kPriority,
    );
    return _tableOp;
  }

  void onChild(BuildMetadata childMeta) {
    if (childMeta.element.parent != tableMeta.element) return;

    final which = _getCssDisplayValue(childMeta);
    _TagTableDataGroup latestGroup;
    switch (which) {
      case kCssDisplayTableRow:
        latestGroup ??= _data.body;
        final row = _TagTableDataRow();
        latestGroup.rows.add(row);
        childMeta.register(_TagTableRow(wf, childMeta, row).op);
        break;
      case kCssDisplayTableHeaderGroup:
      case kCssDisplayTableRowGroup:
      case kCssDisplayTableFooterGroup:
        final rows = which == kCssDisplayTableHeaderGroup
            ? _data.header.rows
            : which == kCssDisplayTableRowGroup
                ? _data.body.rows
                : _data.footer.rows;
        childMeta.register(_TagTableGroup(wf, childMeta, rows).op);
        latestGroup = null;
        break;
      case kCssDisplayTableCaption:
        childMeta.register(BuildOp(onTree: (_, tree) => _captions.add(tree)));
        break;
    }
  }

  void onTree(BuildMetadata _, BuildTree tree) {
    for (final caption in _captions) {
      final built = wf
          .buildColumnPlaceholder(tableMeta, caption.build())
          ?.wrapWith((_, child) => _TableCaption(child));
      if (built != null) {
        WidgetBit.block(tree.parent, built).insertBefore(tree);
      }

      caption.detach();
    }
  }

  Iterable<Widget> onWidgets(BuildMetadata _, Iterable<WidgetPlaceholder> __) {
    final children = <HtmlTableCell>[];
    // occupations data: { rowId: { columnId: occupied } }
    final occupations = <int, Map<int, bool>>{};
    _buildHtmlTableCells(_data.header, occupations, children);
    for (final body in _data.bodies) {
      _buildHtmlTableCells(body, occupations, children);
    }
    _buildHtmlTableCells(_data.footer, occupations, children);
    if (children.isEmpty) return [];

    CssLength borderSpacing;
    var collapseBorder = false;
    for (final style in tableMeta.styles) {
      switch (style.key) {
        case kCssBorderCollapse:
          switch (style.value) {
            case kCssBorderCollapseCollapse:
              collapseBorder = true;
              break;
            case kCssBorderCollapseSeparate:
              collapseBorder = false;
              break;
          }
          break;
        case kCssBorderSpacing:
          final cssLength = tryParseCssLength(style.value);
          if (cssLength != null) borderSpacing = cssLength;
          break;
      }
    }

    return [
      WidgetPlaceholder<BuildMetadata>(tableMeta).wrapWith((context, _) {
        final tsh = tableMeta.tsb().build(context);
        final border = StyleBorder.getParsedBorder(tableMeta, context);
        final spacing = borderSpacing?.getValue(tsh) ?? 0.0;

        return HtmlTable(
          children: children,
          columnGap: border != null && collapseBorder
              ? (border.left.width * -1.0)
              : spacing,
          rowGap: border != null && collapseBorder
              ? (border.top.width * -1.0)
              : spacing,
        );
      }),
    ];
  }

  static BuildOp cellPaddingOp(double px) => BuildOp(
      onChild: (meta) =>
          (meta.element.localName == 'td' || meta.element.localName == 'th')
              ? meta[kCssPadding] = '${px}px'
              : null);

  static BuildOp borderOp(double border, double borderSpacing) => BuildOp(
      defaultStyles: (_) => {
            kCssBorder: '${border}px solid black',
            kCssBorderCollapse: kCssBorderCollapseSeparate,
            kCssBorderSpacing: '${borderSpacing}px',
          },
      onChild: (meta) =>
          (meta.element.localName == 'td' || meta.element.localName == 'th')
              ? meta[kCssBorder] = '${border}px solid black'
              : null);

  static void _buildHtmlTableCells(_TagTableDataGroup group,
      Map<int, Map<int, bool>> occupations, List<HtmlTableCell> cells) {
    var rowStart = occupations.keys.length - 1;
    final rowSpanMax = group.rows.length;
    for (final row in group.rows) {
      rowStart++;
      occupations[rowStart] ??= {};

      for (final cell in row.cells) {
        var columnStart = 0;
        while (occupations[rowStart].containsKey(columnStart)) {
          columnStart++;
        }

        final columnSpan = cell.colspan > 0 ? cell.colspan : 1;
        final rowSpan = min(
            rowSpanMax,
            cell.rowspan > 0
                ? cell.rowspan
                : cell.rowspan == 0
                    ? group.rows.length
                    : 1);
        for (var r = 0; r < rowSpan; r++) {
          final rr = rowStart + r;
          occupations[rr] ??= {};
          for (var c = 0; c < columnSpan; c++) {
            occupations[rr][columnStart + c] = true;
          }
        }

        cells.add(HtmlTableCell(
          child: cell.child,
          columnSpan: columnSpan,
          columnStart: columnStart,
          rowSpan: rowSpan,
          rowStart: rowStart,
        ));
      }
    }
  }

  static String _getCssDisplayValue(BuildMetadata meta) {
    String value;
    switch (meta.element.localName) {
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

    final attrs = meta.element.attributes;
    if (attrs.containsKey('style')) {
      for (final pair in splitAttributeStyle(attrs['style'])
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

class _TableCaption extends SingleChildRenderObjectWidget {
  _TableCaption(Widget child, {Key key}) : super(child: child, key: key);

  @override
  RenderObject createRenderObject(BuildContext context) => RenderProxyBox();
}

class _TagTableGroup {
  final List<_TagTableDataRow> rows;
  final BuildMetadata groupMeta;
  final WidgetFactory wf;

  BuildOp op;

  _TagTableGroup(this.wf, this.groupMeta, this.rows) {
    op = BuildOp(onChild: onChild);
  }

  void onChild(BuildMetadata childMeta) {
    if (childMeta.element.parent != groupMeta.element) return;
    if (TagTable._getCssDisplayValue(childMeta) != kCssDisplayTableRow) {
      return;
    }

    final row = _TagTableDataRow();
    rows.add(row);
    childMeta.register(_TagTableRow(wf, childMeta, row).op);
  }
}

class _TagTableRow {
  final _TagTableDataRow row;
  final BuildMetadata rowMeta;
  final WidgetFactory wf;

  BuildOp op;
  BuildOp _cellOp;

  _TagTableRow(this.wf, this.rowMeta, this.row) {
    op = BuildOp(onChild: onChild);
  }

  void onChild(BuildMetadata childMeta) {
    if (childMeta.element.parent != rowMeta.element) return;
    if (TagTable._getCssDisplayValue(childMeta) != kCssDisplayTableCell) {
      return;
    }

    _cellOp ??= BuildOp(
      onWidgets: (cellMeta, widgets) {
        final column = wf.buildColumnPlaceholder(cellMeta, widgets);
        if (column == null) return [];

        final attributes = cellMeta.element.attributes;
        row.cells.add(_TagTableDataCell(
          child: column,
          colspan: tryParseIntFromMap(attributes, 'colspan') ?? 1,
          rowspan: tryParseIntFromMap(attributes, 'rowspan') ?? 1,
        ));

        return [column];
      },
      priority: StyleSizing.kPriority,
    );

    childMeta.register(_cellOp);
  }
}

@immutable
class _TagTableData {
  final bodies = <_TagTableDataGroup>[];
  final footer = _TagTableDataGroup();
  final header = _TagTableDataGroup();

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
  final int colspan;
  final int rowspan;

  _TagTableDataCell({this.child, this.colspan, this.rowspan});
}
