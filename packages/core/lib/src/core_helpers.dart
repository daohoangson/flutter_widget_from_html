import 'package:flutter/widgets.dart';

import 'core_html_widget.dart';
import 'core_widget_factory.dart';
import 'data_classes.dart';

part 'parser/border.dart';
part 'parser/color.dart';
part 'parser/css.dart';

/// A no op placeholder widget.
const widget0 = const SizedBox.shrink();

// https://ecma-international.org/ecma-262/9.0/#table-32
// https://unicode.org/cldr/utility/character.jsp?a=200B
final regExpSpaceLeading = RegExp(r'^[ \n\t\u{200B}]+', unicode: true);
final regExpSpaceTrailing = RegExp(r'[ \n\t\u{200B}]+$', unicode: true);
final regExpSpaces = RegExp(r'\s+');

typedef void OnTapUrl(String url);

typedef Iterable<Widget> WidgetPlaceholderBuilder<T>(
    BuilderContext bc, Iterable<Widget> children, T input);

typedef WidgetFactory FactoryBuilder(HtmlWidgetConfig config);

class SimpleColumn extends StatelessWidget {
  final List<Widget> children;

  SimpleColumn(this.children);

  @override
  Widget build(BuildContext _) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: children,
      );

  static Widget wrap(Iterable<Widget> ws) {
    if (ws?.isNotEmpty != true) return null;
    if (ws.length == 1) return ws.first;
    return SimpleColumn(ws is List ? ws : ws.toList(growable: false));
  }
}

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
  Widget build(BuildContext c) => buildWithContext(BuilderContext(c, this));

  Widget buildWithContext(BuilderContext bc) {
    Iterable<Widget> output;

    final l = _builders.length;
    for (int i = 0; i < l; i++) {
      final children = i == 0 ? _firstChildren : output;
      output = _builders[i](bc, children, _inputs[i]);
    }

    return SimpleColumn.wrap(output) ?? widget0;
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

  static Widget wrapOne<T2>(
    Iterable<Widget> widgets,
    WidgetPlaceholderBuilder<T2> builder, [
    T2 input,
  ]) =>
      widgets.length == 1
          ? wrap(widgets, builder, null, input).first
          : WidgetPlaceholder(
              builder: builder,
              children: widgets,
              input: input,
            );
}

Iterable<T> listOfNonNullOrNothing<T>(T x) => x == null ? null : [x];
