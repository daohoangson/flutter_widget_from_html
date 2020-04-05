import 'package:flutter/widgets.dart';

import 'core_widget_factory.dart';

part 'widget/image_layout.dart';

/// A no op placeholder widget.
const widget0 = SizedBox.shrink();

typedef OnTapUrl = void Function(String url);

typedef Iterable<Widget> WidgetPlaceholderBuilder<T>(
    BuildContext context, Iterable<Widget> children, T input);

class WidgetPlaceholder<T1> extends StatelessWidget {
  final _builders = List<Function>();
  final Iterable<Widget> _firstChildren;
  final _inputs = [];

  WidgetPlaceholder({
    @required WidgetPlaceholderBuilder<T1> builder,
    Iterable<Widget> children,
    T1 input,
  })  : assert(builder != null),
        _firstChildren = children {
    _builders.add(builder);
    _inputs.add(input);
  }

  Iterable<Function> get builders => _builders.skip(0);

  Iterable get inputs => _inputs.skip(0);

  @override
  Widget build(BuildContext context) {
    Iterable<Widget> output = _firstChildren;

    final l = _builders.length;
    for (int i = 0; i < l; i++) {
      output = _builders[i](context, output, _inputs[i]);
    }

    output = output?.where((widget) => widget != null);
    if (output?.isNotEmpty != true) return widget0;
    if (output.length == 1) return output.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: List.unmodifiable(output),
    );
  }

  void wrapWith<T2>(WidgetPlaceholderBuilder<T2> builder, [T2 input]) {
    assert(builder != null);
    _builders.add(builder);
    _inputs.add(input);
  }

  static Iterable<Widget> wrap<T2>(
    Iterable<Widget> widgets,
    WidgetPlaceholderBuilder<T2> builder,
    WidgetFactory wf, [
    T2 input,
  ]) {
    final wrapped = List<Widget>(widgets.length);

    int i = 0;
    for (final widget in widgets) {
      if (widget is WidgetPlaceholder) {
        wrapped[i++] = widget..wrapWith(builder, input);
      } else {
        wrapped[i++] = WidgetPlaceholder(
          builder: builder,
          children: [widget],
          input: input,
        );
      }
    }

    return wrapped;
  }
}
