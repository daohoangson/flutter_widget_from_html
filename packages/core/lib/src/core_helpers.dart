import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:html/dom.dart' as dom;

part 'widget/css_element.dart';

/// The default character threshold to build widget tree asynchronously.
const kShouldBuildAsync = 10000;

/// A no op widget.
const widget0 = SizedBox.shrink();

/// A callback to specify custom styling.
typedef CustomStylesBuilder = Map<String, String> Function(dom.Element element);

/// A callback to render custom widget for a DOM element.
typedef CustomWidgetBuilder = Widget Function(dom.Element element);

/// A widget builder that supports builder callbacks.
class WidgetPlaceholder<T> extends StatelessWidget {
  /// The origin of this widget.
  final T generator;

  final List<Widget Function(Widget)> _builders = [];
  final Widget _firstChild;

  /// Creates a widget builder.
  WidgetPlaceholder({Widget child, @required this.generator})
      : assert(generator != null),
        _firstChild = child;

  @override
  Widget build(BuildContext context) => callBuilders(_firstChild);

  /// Calls builder callbacks on the specified [child] widget.
  Widget callBuilders(Widget child) {
    var built = child ?? widget0;

    for (final builder in _builders) {
      built = builder(built) ?? widget0;
    }

    return built;
  }

  /// Enqueues [builder] to be built later.
  WidgetPlaceholder<T> wrapWith(Widget Function(Widget child) builder) {
    assert(builder != null);
    _builders.add(builder);
    return this;
  }
}
