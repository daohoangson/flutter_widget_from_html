import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../core_widget_factory.dart';

part 'column_mode.dart';
part 'list_view_mode.dart';
part 'sliver_list_mode.dart';

/// A render mode.
abstract class RenderMode {
  /// The body will be rendered as a [Column] widget.
  ///
  /// This is the default render mode.
  /// It's good enough for small / medium document and can be used easily.
  static const column = ColumnMode();

  /// The body will be rendered as a [ListView] widget.
  ///
  /// It's good for medium / large document in a dedicated page layout
  /// (e.g. the HTML document is the only thing on the screen).
  ///
  /// Construct your own render mode instance with [ListViewMode]
  /// to configure the list view further (e.g. using a [ScrollController]).
  static const listView = ListViewMode();

  /// The body will be rendered as a [SliverList] sliver.
  ///
  /// It's good for large / huge document and can be put in the same scrolling
  /// context with other contents.
  /// A [CustomScrollView] or similar is required for this to work.
  static const sliverList = SliverListMode();

  /// Creates a render mode.
  const RenderMode();

  /// Builds HTML body widget.
  ///
  /// See [ColumnMode].
  /// See [ListViewMode].
  /// See [SliverListMode].
  Widget buildBodyWidget(
    WidgetFactory wf,
    BuildContext context,
    Iterable<Widget> children,
  );
}
