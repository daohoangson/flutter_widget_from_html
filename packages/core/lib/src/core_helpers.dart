import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:html/dom.dart' as dom;

import 'core_data.dart';
import 'core_html_widget.dart';
import 'core_widget_factory.dart';
import 'widgets/inline_custom_widget.dart';

export 'external/csslib.dart';
export 'modes/render_mode.dart';
export 'widgets/css_sizing.dart';
export 'widgets/horizontal_margin.dart';
export 'widgets/html_details.dart';
export 'widgets/html_flex.dart';
export 'widgets/html_list_item.dart';
export 'widgets/html_list_marker.dart';
export 'widgets/html_ruby.dart';
export 'widgets/html_table.dart';
export 'widgets/inline_custom_widget.dart';
export 'widgets/valign_baseline.dart';

/// The default character threshold to build widget tree asynchronously.
///
/// Related: [HtmlWidget.buildAsync]
const kShouldBuildAsync = 10000;

/// A no op widget.
const widget0 = SizedBox.shrink();

/// {@template flutter_widget_from_html.customStylesBuilder}
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
/// {@endtemplate}
typedef CustomStylesBuilder = StylesMap? Function(dom.Element element);

/// {@template flutter_widget_from_html.customWidgetBuilder}
/// A callback to render custom widget for a DOM element.
///
/// This is suitable for fairly simple widget. Please note that
/// you have to handle the DOM element and its children manually,
/// if the children have HTML styling etc., they won't be processed at all.
/// For those needs, a custom [WidgetFactory] is the way to go.
///
/// By default, the widget will be rendered as a block element.
/// Wrap custom widget in a [InlineCustomWidget] to make it inline.
/// {@endtemplate}
typedef CustomWidgetBuilder = Widget? Function(dom.Element element);

/// A callback to scroll the anchor identified by [id] into the viewport.
///
/// By default, an internal impl is given to [WidgetFactory.onTapAnchor]
/// when an anchor is tapped to handle the scrolling.
/// A wf subclass can use this to change the [curve], the animation [duration]
/// or even request scrolling to a different anchor.
///
/// The future is resolved after scrolling is completed.
/// It will be `true` if scrolling succeed or `false` otherwise.
typedef EnsureVisible = Future<bool> Function(
  String id, {
  Curve curve,
  Duration duration,
  Curve jumpCurve,
  Duration jumpDuration,
});

/// A builder function that is called if an error occurs
/// during a complicated element rendering.
///
/// See [OnLoadingBuilder] for the full list.
typedef OnErrorBuilder = Widget? Function(
  BuildContext context,
  dom.Element element,
  dynamic error,
);

/// A builder that specifies the widget to display to the user
/// while a complicated element is still loading.
///
/// List of widgets that will trigger this method:
/// - The [HtmlWidget] itself
/// - Image
/// - Video
typedef OnLoadingBuilder = Widget? Function(
  BuildContext context,
  dom.Element element,
  double? loadingProgress,
);

/// A widget builder that can be extended with callbacks.
class WidgetPlaceholder extends StatelessWidget {
  /// A human-readable description of this placeholder.
  final String? debugLabel;

  final List<WidgetPlaceholderBuilder> _builders;
  final Widget? _firstChild;

  /// Creates a placeholder.
  WidgetPlaceholder({
    WidgetPlaceholderBuilder? builder,
    Widget? child,
    this.debugLabel,
    super.key,
  })  : _builders = builder != null ? [builder] : [],
        _firstChild = child;

  /// Whether this placeholder renders anything.
  bool get isEmpty => _firstChild == null && _builders.isEmpty;

  @override
  Widget build(BuildContext context) => callBuilders(context, _firstChild);

  /// Calls builder callbacks on the specified [child] widget.
  @protected
  Widget callBuilders(BuildContext context, Widget? child) {
    var built = unwrap(context, child ?? widget0);

    for (final builder in _builders) {
      built = unwrap(context, builder(context, built) ?? widget0);
    }

    return built;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);

    if (debugLabel != null) {
      properties.add(
        DiagnosticsProperty('debugLabel', debugLabel, showName: false),
      );
    }
  }

  /// Enqueues [builder] to be built later.
  WidgetPlaceholder wrapWith(WidgetPlaceholderBuilder builder) {
    _builders.add(builder);
    return this;
  }

  /// Creates a placeholder lazily.
  ///
  /// Returns [child] if it is already a placeholder.
  // ignore: prefer_constructors_over_static_methods
  static WidgetPlaceholder lazy(Widget child, {String? debugLabel}) =>
      child is WidgetPlaceholder
          ? child
          : WidgetPlaceholder(debugLabel: debugLabel, child: child);

  /// Builds widget if it is a placeholder.
  static Widget unwrap(BuildContext context, Widget widget) =>
      widget is WidgetPlaceholder ? widget.build(context) : widget;
}

/// A callback for [WidgetPlaceholder].
typedef WidgetPlaceholderBuilder = Widget? Function(
  BuildContext context,
  Widget child,
);

final _dataUriRegExp = RegExp('^data:[^;]+;([^,]+),');

/// Returns [Uint8List] by decoding [dataUri].
///
/// Supported encoding:
///
/// - base64
/// - utf8
Uint8List? bytesFromDataUri(String dataUri) {
  final match = _dataUriRegExp.matchAsPrefix(dataUri);
  if (match == null) {
    return null;
  }

  final prefix = match[0]!;
  final encoding = match[1];
  final data = dataUri.substring(prefix.length);
  final bytes = encoding == 'base64'
      ? base64.decode(data)
      : encoding == 'utf8'
          ? Uint8List.fromList(data.codeUnits)
          : null;

  return bytes?.isNotEmpty == true ? bytes : null;
}

/// Parses [key] from [map] as an double literal and return its value.
double? tryParseDoubleFromMap(Map<dynamic, String> map, String key) {
  final value = map[key];
  if (value == null) {
    return null;
  }

  return double.tryParse(value);
}

/// Parses [key] from [map] as an integer literal and return its value.
int? tryParseIntFromMap(Map<dynamic, String> map, String key) {
  final value = map[key];
  if (value == null) {
    return null;
  }

  return int.tryParse(value);
}
