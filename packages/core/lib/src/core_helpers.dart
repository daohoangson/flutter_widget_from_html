import 'package:flutter/widgets.dart';

import 'core_html_widget.dart';
import 'core_widget_factory.dart';

/// A no op placeholder widget.
const widget0 = SizedBox.shrink();

typedef void OnTapUrl(String url);

typedef Iterable<Widget> WidgetPlaceholderBuilder<T>(
    BuildContext context, Iterable<Widget> children, T input);

typedef WidgetFactory FactoryBuilder(HtmlWidgetConfig config);

class WidgetPlaceholder<T1> extends IWidgetPlaceholder {
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

  @override
  Widget build(BuildContext context) {
    Iterable<Widget> output;

    final l = _builders.length;
    for (int i = 0; i < l; i++) {
      final children = i == 0 ? _firstChildren : output;
      output = _builders[i](context, children, _inputs[i]);
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

  @override
  void wrapWith<T2>(WidgetPlaceholderBuilder<T2> builder, [T2 input]) {
    _builders.add(builder);
    _inputs.add(input);
  }
}

abstract class IWidgetPlaceholder extends StatelessWidget {
  void wrapWith<T>(WidgetPlaceholderBuilder<T> builder, T input);

  static Iterable<Widget> wrap<T2>(
    Iterable<Widget> widgets,
    WidgetPlaceholderBuilder<T2> builder,
    WidgetFactory wf, [
    T2 input,
  ]) {
    final wrapped = List<Widget>(widgets.length);

    int i = 0;
    for (final widget in widgets) {
      if (widget is IWidgetPlaceholder) {
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

Iterable<T> listOfNonNullOrNothing<T>(T x) => x == null ? null : [x];
