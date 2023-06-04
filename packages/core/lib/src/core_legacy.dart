import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import 'core_data.dart';
import 'core_widget_factory.dart';

/// A legacy tree of [BuildBit]s.
@Deprecated('Use BuildTree instead.')
typedef BuildMetadata = BuildTree;

extension LegacyWidgetFactory on WidgetFactory {
  /// Prepares [GestureTapCallback].
  @Deprecated('Use .onTapUrl instead.')
  GestureTapCallback? gestureTapCallback(String url) => () => onTapUrl(url);
}

/// A legacy HTML styling set.
@Deprecated('Use HtmlStyle instead.')
typedef TextStyleHtml = HtmlStyle;

/// A legacy HTML styling builder.
@Deprecated('Use HtmlStyleBuilder instead.')
typedef TextStyleBuilder<T> = HtmlStyleBuilder;

/// Returns [List<T>] if [x] is provided or `null` otherwise.
@Deprecated('Use BuildOp.onRenderBlock instead.')
Iterable<T>? listOrNull<T>(T? x) => x == null ? null : [x];
