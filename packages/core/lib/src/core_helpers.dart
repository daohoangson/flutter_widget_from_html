import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:html/dom.dart' as dom;

import 'core_html_widget.dart';

export 'widgets/css_block.dart';
export 'widgets/css_sizing.dart';
export 'widgets/html_ruby.dart';

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

/// A set of values that should trigger rebuild.
class RebuildTriggers {
  final List _values;

  /// Creates a set.
  ///
  /// The values should have sane equality check to avoid excessive rebuilds.
  RebuildTriggers(this._values);

  @override
  bool operator ==(Object other) {
    if (other is! RebuildTriggers) return false;

    final otherValues = (other as RebuildTriggers)._values;
    if (otherValues.length != _values.length) return false;

    for (var i = 0; i < _values.length; i++) {
      if (otherValues[i] != _values[i]) return false;
    }

    return true;
  }
}

/// A widget builder that supports builder callbacks.
class WidgetPlaceholder<T> extends StatelessWidget {
  /// The origin of this widget.
  final T generator;

  final List<Widget Function(BuildContext, Widget)> _builders = [];
  final Widget _firstChild;

  /// Creates a widget builder.
  WidgetPlaceholder(this.generator, {Widget child}) : _firstChild = child;

  @override
  Widget build(BuildContext context) => callBuilders(context, _firstChild);

  /// Calls builder callbacks on the specified [child] widget.
  Widget callBuilders(BuildContext context, Widget child) {
    var built = child ?? widget0;

    for (final builder in _builders) {
      built = builder(context, built) ?? widget0;
    }

    return built;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<T>(
      'generator',
      generator,
      showName: false,
    ));
  }

  /// Enqueues [builder] to be built later.
  WidgetPlaceholder<T> wrapWith(
      Widget Function(BuildContext context, Widget child) builder) {
    assert(builder != null);
    _builders.add(builder);
    return this;
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) =>
      generator != null
          ? 'WidgetPlaceholder($generator)'
          : runtimeType.toString();

  /// Creates a placeholder lazily.
  ///
  /// Returns [child] if it is already a placeholder.
  static WidgetPlaceholder lazy(Widget child) => child is WidgetPlaceholder
      ? child
      : WidgetPlaceholder<Widget>(child, child: child);
}
