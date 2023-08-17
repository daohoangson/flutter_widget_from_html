import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart'
    as core show HtmlWidget;

import 'widget_factory.dart';

export 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart'
    show HtmlWidgetState;

/// A widget that builds Flutter widget tree from HTML
/// with support for IFRAME, VIDEO and many other tags.
class HtmlWidget extends core.HtmlWidget {
  /// Creates a widget that builds Flutter widget tree from html.
  ///
  /// The [html] argument must not be null.
  const HtmlWidget(
    super.html, {
    super.buildAsync,
    super.enableCaching,
    WidgetFactory Function()? factoryBuilder,
    super.key,
    super.baseUrl,
    super.customStylesBuilder,
    super.customWidgetBuilder,
    super.onErrorBuilder,
    super.onLoadingBuilder,
    super.onTapImage,
    super.onTapUrl,
    super.rebuildTriggers,
    super.renderMode,
    super.textStyle,
  }) : super(factoryBuilder: factoryBuilder ?? _getEnhancedWf);

  static WidgetFactory _getEnhancedWf() => WidgetFactory();
}
