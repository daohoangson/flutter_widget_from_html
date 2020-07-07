part of '../../table_layout.dart';

@immutable
class GridArea {
  GridArea({
    this.name,
    this.columnStart,
    this.columnEnd,
    this.rowStart,
    this.rowEnd,
  });

  GridArea.withSpans({
    this.name,
    this.columnStart,
    int columnSpan,
    this.rowStart,
    int rowSpan,
  })  : columnEnd = columnStart + columnSpan,
        rowEnd = rowStart + rowSpan;

  final String name;
  final int columnStart;
  final int rowStart;

  /// The end column, exclusive
  final int columnEnd;
  int get columnSpan => columnEnd - columnStart;

  /// The end row, exclusive
  final int rowEnd;
  int get rowSpan => rowEnd - rowStart;

  int startForAxis(Axis axis) =>
      axis == Axis.horizontal ? columnStart : rowStart;
  int endForAxis(Axis axis) => axis == Axis.horizontal ? columnEnd : rowEnd;
  int spanForAxis(Axis axis) => endForAxis(axis) - startForAxis(axis);

  @override
  int get hashCode =>
      hashObjects(<dynamic>[name, columnStart, columnEnd, rowStart, rowEnd]);

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) return false;
    final typedOther = other as GridArea;
    return typedOther.name == name &&
        typedOther.columnStart == columnStart &&
        typedOther.columnEnd == columnEnd &&
        typedOther.rowStart == rowStart &&
        typedOther.rowEnd == rowEnd;
  }

  @override
  String toString() {
    return 'GridArea(' +
        (name != null ? 'name=$name, ' : '') +
        'columnSpan=[$columnStart–$columnEnd], rowSpan=[$rowStart–$rowEnd])';
  }
}
