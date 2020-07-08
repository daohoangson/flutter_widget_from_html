import 'package:flutter/widgets.dart';
import 'package:html/dom.dart' as dom;

part 'widget/image_layout.dart';

const kShouldBuildAsync = 10000;

/// A no op placeholder widget.
const widget0 = SizedBox.shrink();

typedef CustomStylesBuilder = Iterable<String> Function(dom.Element element);

typedef CustomWidgetBuilder = Widget Function(dom.Element element);

typedef WidgetPlaceholderBuilder<T> = Iterable<Widget> Function(
    BuildContext context, Iterable<Widget> children, T input);

class WidgetPlaceholder<T1> extends StatelessWidget {
  final _builders = <Function>[];
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
    var output = _firstChildren;

    final l = _builders.length;
    for (var i = 0; i < l; i++) {
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
    WidgetPlaceholderBuilder<T2> builder, [
    T2 input,
  ]) {
    final wrapped = List<Widget>(widgets.length);

    var i = 0;
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

  static Widget wrapOne<T2>(
    Iterable<Widget> widgets,
    WidgetPlaceholderBuilder<T2> builder, [
    T2 input,
  ]) =>
      widgets.length == 1
          ? wrap(widgets, builder, input).first
          : WidgetPlaceholder(
              builder: builder,
              children: widgets,
              input: input,
            );
}
