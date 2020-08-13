import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:html/dom.dart' as dom;

part 'widget/css_element.dart';

const kShouldBuildAsync = 10000;

/// A no op widget.
const widget0 = SizedBox.shrink();

typedef CustomStylesBuilder = Map<String, String> Function(dom.Element element);

typedef CustomWidgetBuilder = Widget Function(dom.Element element);

class WidgetPlaceholder<T> extends StatelessWidget {
  final T generator;

  final List<Widget Function(Widget)> _builders = [];
  final Widget _firstChild;

  WidgetPlaceholder({Widget child, @required this.generator})
      : assert(generator != null),
        _firstChild = child;

  @override
  Widget build(BuildContext context) => callBuilders(_firstChild);

  Widget callBuilders(Widget child) {
    var built = child ?? widget0;

    for (final builder in _builders) {
      built = builder(built) ?? widget0;
    }

    return built;
  }

  WidgetPlaceholder<T> wrapWith(Widget Function(Widget) builder) {
    assert(builder != null);
    _builders.add(builder);
    return this;
  }
}
