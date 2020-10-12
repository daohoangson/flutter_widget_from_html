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
    final rows = <_TagTableDataRow>[
      ..._data.header.rows,
      ..._data.rows,
      ..._data.footer.rows,
    ];

    final children = <HtmlTableCell>[];
    for (var row = 0; row < rows.length; row++) {
      for (final cell in rows[row].cells) {
        children.add(
          HtmlTableCell(
            child: cell.child,
            columnSpan: cell.colspan,
            rowSpan: cell.rowspan,
            rowStart: row,
          ),
        );
      }
    }
    if (children.isEmpty) return [];

    CssLength borderSpacing;
    for (final style in tableMeta.styles) {
      switch (style.key) {
        case kCssBorderSpacing:
          final cssLength = tryParseCssLength(style.value);
          if (cssLength != null) borderSpacing = cssLength;
      }
    }

    return [
      WidgetPlaceholder<BuildMetadata>(tableMeta).wrapWith((context, _) {
        final tsh = tableMeta.tsb().build(context);
        final gap = borderSpacing?.getValue(tsh) ?? 0.0;

        return HtmlTable(
          children: children,
          columnGap: gap,
          rowGap: gap,
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
            kCssBorder: '${border}px',
            kCssBorderSpacing: '${borderSpacing}px',
          },
      onChild: (meta) =>
          (meta.element.localName == 'td' || meta.element.localName == 'th')
              ? meta[kCssBorder] = '${border}px'
              : null);

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

class _TableCell extends SingleChildRenderObjectWidget {
  _TableCell(Widget child, {Key key}) : super(child: child, key: key);

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
        final column = wf
            .buildColumnPlaceholder(cellMeta, widgets)
            ?.wrapWith((_, child) => _TableCell(child));
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
