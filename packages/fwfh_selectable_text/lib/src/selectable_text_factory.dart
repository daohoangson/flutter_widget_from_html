import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

// ignore: implementation_imports
import 'package:flutter_widget_from_html_core/src/internal/core_ops.dart';

/// A mixin that can render [SelectableText].
mixin SelectableTextFactory on WidgetFactory {
  /// Controls whether text is rendered with [SelectableText] or [RichText].
  ///
  /// Default: `true`.
  bool get selectableText => true;

  /// The callback when user changes the selection of text.
  ///
  /// See [SelectableText.onSelectionChanged].
  SelectionChangedCallback? get selectableTextOnChanged => null;

  @override
  Widget? buildText(BuildTree tree, HtmlStyle style, InlineSpan text) {
    if (selectableText &&
        tree.overflow == TextOverflow.clip &&
        text is TextSpan) {
      return SelectableText.rich(
        text,
        maxLines: tree.maxLines > 0 ? tree.maxLines : null,
        textAlign: style.textAlign ?? TextAlign.start,
        textDirection: style.textDirection,
        textScaleFactor: 1.0,
        onSelectionChanged: selectableTextOnChanged,
      );
    }

    return super.buildText(tree, style, text);
  }
}
