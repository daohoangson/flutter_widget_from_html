part of '../core_widget_factory.dart';

class _ColumnPlaceholder extends WidgetPlaceholder {
  final Iterable<Widget> children;
  final bool trimMarginVertical;

  _ColumnPlaceholder(
    this.children, {
    @required this.trimMarginVertical,
  });

  @override
  Widget build(BuildContext context) => _column(_process(context));

  List<Widget> _process(BuildContext context) {
    final data = _ColumnLoopData(trimMarginVertical: trimMarginVertical);

    _loop(context, _ColumnWidgetIterator(context, children.iterator), data);

    final column = callBuilders(_column(data.children));

    return [
      ...data.marginTop,
      if (column != widget0) column,
      ...data.marginBottom,
    ];
  }

  static Widget _column(List<Widget> children) {
    if (children.isEmpty) return widget0;
    if (children.length == 1) return children.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  static void _loop(
    BuildContext context,
    Iterator<Widget> iter,
    _ColumnLoopData data,
  ) {
    Widget prev;
    var hasCurrent = false;

    while (iter.moveNext()) {
      final first = iter.current;
      if (first is _MarginVerticalPlaceholder) {
        if (!data.trimMarginVertical) {
          if (prev is _MarginVerticalPlaceholder) {
            prev.mergeWith(first);
            continue;
          }

          data.marginTop.add(first);
          prev = first;
        }
      } else {
        hasCurrent = true;
        break;
      }
    }
    if (iter.current == null) return null;

    while (hasCurrent || iter.moveNext()) {
      var child = iter.current;
      if (hasCurrent) hasCurrent = false;

      if (child is _MarginVerticalPlaceholder &&
          prev is _MarginVerticalPlaceholder) {
        prev.mergeWith(child);
        continue;
      }

      if (child == widget0) continue;

      data.children.add(child);
      prev = child;
    }

    while (data.children.isNotEmpty) {
      final last = data.children.last;
      if (last is _MarginVerticalPlaceholder) {
        data.children.removeLast();

        if (!data.trimMarginVertical) {
          data.marginBottom.add(last);
        }

        continue;
      }

      break;
    }
  }
}

class _ColumnWidgetIterator extends Iterator<Widget> {
  final BuildContext context;
  final Iterator<Widget> iter;

  Widget _current;
  _ColumnWidgetIterator _subIter;

  _ColumnWidgetIterator(this.context, this.iter);

  @override
  Widget get current => _current;

  @override
  bool moveNext() => _subNext() ?? _thisNext();

  bool _thisNext() {
    _current = null;
    if (!iter.moveNext()) return false;

    _current = iter.current;

    final b = _onNewCurrent();
    if (b != null) return b;

    return true;
  }

  bool _onNewCurrent() {
    if (_current is _ColumnPlaceholder) {
      final grandChildren = (_current as _ColumnPlaceholder)._process(context);
      _subIter = _ColumnWidgetIterator(context, grandChildren.iterator);

      return _subNext();
    } else if (_current is _MarginVerticalPlaceholder) {
      return null;
    } else if (_current is WidgetPlaceholder) {
      _current = (_current as WidgetPlaceholder).build(context);
      return _onNewCurrent();
    }

    return null;
  }

  bool _subNext() {
    if (_subIter == null) return null;

    _current = null;
    if (!_subIter.moveNext()) {
      _subIter = null;
      return _thisNext();
    }

    _current = _subIter.current;
    return true;
  }
}

@immutable
class _ColumnLoopData {
  final marginBottom = <Widget>[];
  final marginTop = <Widget>[];
  final children = <Widget>[];

  final bool trimMarginVertical;

  _ColumnLoopData({
    @required this.trimMarginVertical,
  });

  List<Widget> get everything => [...marginTop, ...children, ...marginBottom];
}
