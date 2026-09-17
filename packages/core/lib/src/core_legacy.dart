// intentionally uses deprecated members for backwards compatibility
// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter/widgets.dart';

import 'core_data.dart';
import 'core_widget_factory.dart';

/// A legacy tree of [BuildBit]s.
@Deprecated('Use BuildTree instead.')
typedef BuildMetadata = BuildTree;

extension BuildMetadataLegacy on BuildMetadata {
  /// The associated [HtmlStyle] builder.
  @Deprecated('Use .inherit to quickly enqueue callbacks or '
      '.inheritanceResolvers to access the resolvers directly.')
  TextStyleBuilder get tsb => inheritanceResolvers;
}

extension LegacyWidgetFactory on WidgetFactory {
  /// Prepares [GestureTapCallback].
  @Deprecated('Use .onTapUrl instead.')
  GestureTapCallback? gestureTapCallback(String url) => () => onTapUrl(url);
}

/// A legacy HTML styling set.
@Deprecated('Use InheritedProperties instead.')
typedef TextStyleHtml = InheritedProperties;

extension LegacyTextStyleHtml on TextStyleHtml {
  /// The [TextStyle].
  @Deprecated('Use `prepareTextStyle` to build one. '
      'For usage in resolving.copyWith, check the migration guide.')
  TextStyle get style => prepareTextStyle();

  /// Gets dependency by type [T].
  @Deprecated('Use .get instead.')
  T getDependency<T>() {
    final dep = get<T>();
    if (dep != null) {
      return dep;
    }
    throw StateError('The $T dependency could not be found');
  }
}

/// A legacy HTML styling builder.
@Deprecated('Use InheritanceResolvers instead.')
typedef TextStyleBuilder<T> = InheritanceResolvers;

extension LegacyTextStyleBuilder on TextStyleBuilder {
  /// Builds a [TextStyleHtml] by calling queued callbacks.
  @Deprecated('Use .resolve instead.')
  TextStyleHtml build(BuildContext context) => resolve(context);
}

/// Returns [List<T>] if [x] is provided or `null` otherwise.
@Deprecated('Use BuildOp.onRenderBlock instead.')
Iterable<T>? listOrNull<T>(T? x) => x == null ? null : [x];
