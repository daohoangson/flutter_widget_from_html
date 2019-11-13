import 'package:flutter/widgets.dart';

import 'core_html_widget.dart';
import 'core_widget_factory.dart';
import 'data_classes.dart';

part 'parser/border.dart';
part 'parser/color.dart';
part 'parser/css.dart';

/// A no op placeholder widget.
const widget0 = const SizedBox.shrink();

// https://unicode.org/cldr/utility/character.jsp?a=200B
final regExpSpaceLeading = RegExp(r'^[\s\u{200B}]+', unicode: true);
final regExpSpaceTrailing = RegExp(r'[\s\u{200B}]+$', unicode: true);
final regExpSpaces = RegExp(r'[\s\u{200B}]+', unicode: true);

typedef void OnTapUrl(String url);

typedef Iterable<Widget> WidgetPlaceholderBuilder<T>(
    BuilderContext bc, Iterable<Widget> children, T input);

typedef WidgetFactory FactoryBuilder(HtmlWidgetConfig config);

class WidgetPlaceholder<T1> extends IWidgetPlaceholder {
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
  Widget build(BuildContext c) => buildWithContext(BuilderContext(c));

  Widget buildWithContext(BuilderContext bc) {
    Iterable<Widget> output;

    final l = _builders.length;
    for (int i = 0; i < l; i++) {
      final children = i == 0 ? _firstChildren : output;
      output = _builders[i](bc, children, _inputs[i]);
    }

    return wf.buildColumn(output) ?? widget0;
  }

  @override
  void wrapWith<T2>(WidgetPlaceholderBuilder<T2> builder, [T2 input]) {
    _builders.add(builder);
    _inputs.add(input);
  }
}

abstract class IWidgetPlaceholder extends StatelessWidget {
  void wrapWith<T>(WidgetPlaceholderBuilder<T> builder, T input);
}

Iterable<T> listOfNonNullOrNothing<T>(T x) => x == null ? null : [x];
