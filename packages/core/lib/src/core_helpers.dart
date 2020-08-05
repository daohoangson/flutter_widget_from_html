import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:html/dom.dart' as dom;

part 'widget/css_element.dart';

const kShouldBuildAsync = 10000;

/// A no op placeholder widget.
const widget0 = SizedBox.shrink();

typedef CustomStylesBuilder = Map<String, String> Function(dom.Element element);

typedef CustomWidgetBuilder = Widget Function(dom.Element element);

typedef WidgetPlaceholderBuilder<T> = Iterable<Widget> Function(
    BuildContext context, Iterable<Widget> children, T input);

class WidgetPlaceholder<T1> extends StatelessWidget {
  final _builders = <Function>[];
  final Iterable<Widget> _firstChildren;
  final _inputs = [];
  final WidgetPlaceholderBuilder<T1> _lastBuilder;
  final T1 _lastInput;

  WidgetPlaceholder({
    WidgetPlaceholderBuilder<T1> builder,
    Iterable<Widget> children,
    T1 input,
    WidgetPlaceholderBuilder<T1> lastBuilder,
  })  : assert((builder == null) != (lastBuilder == null),
            'Either builder or lastBuilder must be set'),
        _firstChildren = children,
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
  Widget build(BuildContext context) {
    var output = _firstChildren;

    final l = _builders.length;
    for (var i = 0; i < l; i++) {
      output = _builders[i](context, output, _inputs[i]);
    }

    if (_lastBuilder != null) {
      output = _lastBuilder(context, output, _lastInput);
    }

    output = output?.where((widget) => widget != null);
    if (output?.isNotEmpty != true) return widget0;
    if (output.length == 1) return output.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: List.unmodifiable(output),
    );
  }

  WidgetPlaceholder<T1> wrapWith<T2>(WidgetPlaceholderBuilder<T2> builder,
      [T2 input]) {
    assert(builder != null);
    _builders.add(builder);
    _inputs.add(input);
    return this;
  }
}
