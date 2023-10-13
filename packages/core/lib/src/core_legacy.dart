// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter/widgets.dart';

import 'core_data.dart';
import 'core_widget_factory.dart';

/// A legacy tree of [BuildBit]s.
@Deprecated('Use BuildTree instead.')
typedef BuildMetadata = BuildTree;

extension BuildMetadataLegacy on BuildMetadata {
  /// The associated [HtmlStyle] builder.
  @Deprecated('Use .styleBuilder instead.')
  TextStyleBuilder get tsb => styleBuilder;
}

extension LegacyWidgetFactory on WidgetFactory {
  /// Prepares [GestureTapCallback].
  @Deprecated('Use .onTapUrl instead.')
  GestureTapCallback? gestureTapCallback(String url) => () => onTapUrl(url);
}

/// A legacy HTML styling set.
@Deprecated('Use HtmlStyle instead.')
typedef TextStyleHtml = HtmlStyle;

extension LegacyTextStyleHtml on TextStyleHtml {
  /// The input [TextStyle].
  @Deprecated('Use .textStyle instead.')
  TextStyle get style => textStyle;

  /// Gets dependency by type [T].
  @Deprecated('Use .value instead.')
  T getDependency<T>() {
    final dep = value<T>();
    if (dep != null) {
      return dep;
    }
    throw StateError('The $T dependency could not be found');
  }
}

/// A legacy HTML styling builder.
@Deprecated('Use HtmlStyleBuilder instead.')
typedef TextStyleBuilder<T> = HtmlStyleBuilder;

/// Returns [List<T>] if [x] is provided or `null` otherwise.
@Deprecated('Use BuildOp.onRenderBlock instead.')
Iterable<T>? listOrNull<T>(T? x) => x == null ? null : [x];
