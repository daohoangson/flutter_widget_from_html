import 'package:flutter/widgets.dart';
import 'package:html/dom.dart' as dom;

import 'core_html_widget.dart';

/// The default character threshold to build widget tree asynchronously.
///
/// Related: [HtmlWidget.buildAsync]
const kShouldBuildAsync = 10000;

/// A no op widget.
const widget0 = SizedBox.shrink();

/// A callback to specify custom styling.
///
/// The returned `Map` will be applied as inline styles.
/// See list of all supported inline stylings in README.md, the sample callback
/// below changes the color for all elements that have CSS class `name`:
///
/// ```dart
/// HtmlWidget(
///   'Hello <span class="name">World</span>!',
///   customStylesBuilder: (element) =>
///     element.classes.contains('name') ? {'color': 'red'} : null,
/// )
/// ```
typedef CustomStylesBuilder = Map<String, String> Function(dom.Element element);

/// A callback to render custom widget for a DOM element.
///
/// This is suitable for fairly simple widget. Please note that
/// you have to handle the DOM element and its children manually,
/// if the children have HTML styling etc., they won't be processed at all.
/// For those needs, a custom [WidgetFactory] is the way to go.
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
