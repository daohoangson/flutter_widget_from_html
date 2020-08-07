import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:html/dom.dart' as dom;

part 'widget/css_element.dart';

const kShouldBuildAsync = 10000;

/// A no op placeholder widget.
final placeholder0 = WidgetPlaceholder(builder: (_, __, ___) => widget0);

/// A no op widget.
const widget0 = SizedBox.shrink();

typedef CustomStylesBuilder = Map<String, String> Function(dom.Element element);

typedef CustomWidgetBuilder = Widget Function(dom.Element element);

typedef WidgetPlaceholderBuilder<T> = Widget Function(
    BuildContext context, Widget child, T input);

class WidgetPlaceholder<T1> extends StatelessWidget {
  final _builders = <Function>[];
  final Widget _child;
  final _inputs = [];
  final WidgetPlaceholderBuilder<T1> _lastBuilder;
  final T1 _lastInput;

  WidgetPlaceholder({
    WidgetPlaceholderBuilder<T1> builder,
    Widget child,
    T1 input,
    WidgetPlaceholderBuilder<T1> lastBuilder,
  })  : assert((builder == null) != (lastBuilder == null),
            'Either builder or lastBuilder must be set'),
        _child = child,
        _lastBuilder = lastBuilder,
        _lastInput = (lastBuilder != null ? input : null) {
    if (builder != null) {
      _builders.add(builder);
      _inputs.add(input);
    }
  }

  Iterable<Function> get builders => _builders.skip(0);

  Iterable get inputs => _inputs.skip(0);

  @override
  Widget build(BuildContext context) => callBuilders(context, _child);

  Widget callBuilders(BuildContext context, Widget widget) {
    var built = widget ?? widget0;

    final l = _builders.length;
    for (var i = 0; i < l; i++) {
      built = _builders[i](context, built, _inputs[i]) ?? widget0;
    }

    if (_lastBuilder != null) {
      built = _lastBuilder(context, built, _lastInput) ?? widget0;
    }

    return built;
  }

  WidgetPlaceholder<T1> wrapWith<T2>(WidgetPlaceholderBuilder<T2> builder,
      [T2 input]) {
    assert(builder != null);
    _builders.add(builder);
    _inputs.add(input);
    return this;
  }
}
