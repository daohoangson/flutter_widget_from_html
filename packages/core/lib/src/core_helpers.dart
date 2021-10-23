import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:html/dom.dart' as dom;

import 'core_html_widget.dart';
import 'core_widget_factory.dart';

export 'external/csslib.dart';
export 'modes/render_mode.dart';
export 'widgets/css_sizing.dart';
export 'widgets/html_details.dart';
export 'widgets/html_list_item.dart';
export 'widgets/html_list_marker.dart';
export 'widgets/html_ruby.dart';
export 'widgets/html_table.dart';

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
typedef CustomStylesBuilder = Map<String, String>? Function(
  dom.Element element,
);

/// A callback to render custom widget for a DOM element.
///
/// This is suitable for fairly simple widget. Please note that
/// you have to handle the DOM element and its children manually,
/// if the children have HTML styling etc., they won't be processed at all.
/// For those needs, a custom [WidgetFactory] is the way to go.
typedef CustomWidgetBuilder = Widget? Function(dom.Element element);

/// A callback to scroll the anchor identified by [id] into the viewport.
///
/// By default, an internal implementation is given to [WidgetFactory.onTapAnchor]
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

/// An extension on [Widget] to keep track of anchors.
extension WidgetAnchors on Widget {
  static final _anchors = Expando<Iterable<Key>>();

  /// Anchor keys of this widget and its children.
  Iterable<Key>? get anchors => _anchors[this];

  /// Set anchor keys.
  bool setAnchorsIfUnset(Iterable<Key>? anchors) {
    if (anchors == null) {
      return false;
    }

    final existing = _anchors[this];
    if (existing != null) {
      return false;
    }

    _anchors[this] = anchors;
    return true;
  }
}

/// A widget builder that supports builder callbacks.
class WidgetPlaceholder<T> extends StatelessWidget {
  /// The origin of this widget.
  final T generator;

  final List<Widget? Function(BuildContext, Widget)> _builders = [];
  final Widget? _firstChild;

  /// Creates a widget builder.
  WidgetPlaceholder(this.generator, {Widget? child, Key? key})
      : _firstChild = child,
        super(key: key);

  @visibleForTesting
  @override
  Widget build(BuildContext context) => callBuilders(context, _firstChild);

  /// Calls builder callbacks on the specified [child] widget.
  Widget callBuilders(BuildContext context, Widget? child) {
    var built = child ?? widget0;

    for (final builder in _builders) {
      built = builder(context, built) ?? widget0;
    }

    built.setAnchorsIfUnset(anchors);

    return built;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty('generator', generator, showName: false));
  }

  /// Enqueues [builder] to be built later.
  WidgetPlaceholder<T> wrapWith(
    Widget? Function(BuildContext context, Widget child) builder,
  ) {
    _builders.add(builder);
    return this;
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) =>
      generator != null
          ? 'WidgetPlaceholder($generator)'
          : objectRuntimeType(this, 'WidgetPlaceholder');

  /// Creates a placeholder lazily.
  ///
  /// Returns [child] if it is already a placeholder.
  static WidgetPlaceholder lazy(Widget child) => child is WidgetPlaceholder
      ? child
      : WidgetPlaceholder<Widget>(child, child: child);
}

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

/// Returns [List<T>] if [x] is provided or `null` otherwise.
Iterable<T>? listOrNull<T>(T? x) => x == null ? null : [x];

/// Parses [key] from [map] as an double literal and return its value.
double? tryParseDoubleFromMap(Map<dynamic, String> map, String key) =>
    map.containsKey(key) ? double.tryParse(map[key]!) : null;

/// Parses [key] from [map] as a, possibly signed, integer literal and return its value.
int? tryParseIntFromMap(Map<dynamic, String> map, String key) =>
    map.containsKey(key) ? int.tryParse(map[key]!) : null;
