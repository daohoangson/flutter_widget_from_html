import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart'
    as core show HtmlWidget;

import 'data.dart';
import 'helpers.dart';
import 'widget_factory.dart';

export 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart'
    show HtmlWidgetState;

/// A widget that builds Flutter widget tree from HTML
/// with support for IFRAME, VIDEO and many other tags.
class HtmlWidget extends core.HtmlWidget {
  /// Controls whether text is rendered with [SelectableText] or [RichText].
  ///
  /// Default: `false`, use [RichText].
  final bool isSelectable;

  /// The callback when user changes the selection of text.
  ///
  /// This doesn't have any effect if [isSelectable] is disabled.
  ///
  /// See [SelectableText.onSelectionChanged].
  final SelectionChangedCallback? onSelectionChanged;

  /// Creates a widget that builds Flutter widget tree from html.
  ///
  /// The [html] argument must not be null.
  const HtmlWidget(
    String html, {
    bool? buildAsync,
    bool enableCaching = true,
    WidgetFactory Function()? factoryBuilder,
    this.isSelectable = false,
    Key? key,
    Uri? baseUrl,
    CustomStylesBuilder? customStylesBuilder,
    CustomWidgetBuilder? customWidgetBuilder,
    OnErrorBuilder? onErrorBuilder,
    OnLoadingBuilder? onLoadingBuilder,
    this.onSelectionChanged,
    void Function(ImageMetadata)? onTapImage,
    FutureOr<bool> Function(String)? onTapUrl,
    RenderMode renderMode = RenderMode.column,
    TextStyle? textStyle,
  }) : super(
          html,
          baseUrl: baseUrl,
          buildAsync: buildAsync,
          customStylesBuilder: customStylesBuilder,
          customWidgetBuilder: customWidgetBuilder,
          enableCaching: enableCaching,
          factoryBuilder: factoryBuilder ?? _getEnhancedWf,
          onErrorBuilder: onErrorBuilder,
          onLoadingBuilder: onLoadingBuilder,
          onTapImage: onTapImage,
          onTapUrl: onTapUrl,
          rebuildTriggers: core.RebuildTriggers([
            isSelectable,
          ]),
          renderMode: renderMode,
          textStyle: textStyle,
          key: key,
        );

  static WidgetFactory _getEnhancedWf() => WidgetFactory();
}
