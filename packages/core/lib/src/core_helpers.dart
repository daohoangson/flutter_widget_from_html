import 'package:flutter/widgets.dart';

import 'core_html_widget.dart';
import 'core_widget_factory.dart';
import 'data_classes.dart';

part 'parser/border.dart';
part 'parser/color.dart';
part 'parser/css.dart';

/// A no op placeholder widget.
const widget0 = const SizedBox.shrink();

typedef void OnTapUrl(String url);

typedef Iterable<Widget> WidgetPlaceholderBuilder<T>(
    BuildContext context, Iterable<Widget> children, T input);

typedef WidgetFactory FactoryBuilder(HtmlWidgetConfig config);

class WidgetPlaceholder<T1> extends StatelessWidget
    implements IWidgetPlaceholder {
  final WidgetFactory wf;

  final _builders = List<Function>();
  final Iterable<Widget> _firstChildren;
  final _inputs = [];

  WidgetPlaceholder({
    WidgetPlaceholderBuilder<T1> builder,
    Iterable<Widget> children,
    T1 input,
    this.wf,
  })  : assert(builder != null),
        assert(wf != null),
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

    return wf.buildColumn(output) ?? widget0;
  }

  @override
  void wrapWith<T2>(WidgetPlaceholderBuilder<T2> builder, [T2 input]) {
    _builders.add(builder);
    _inputs.add(input);
  }
}

abstract class IWidgetPlaceholder extends Widget {
  Widget build(BuildContext context);

  void wrapWith<T>(WidgetPlaceholderBuilder<T> builder, T input);
}
