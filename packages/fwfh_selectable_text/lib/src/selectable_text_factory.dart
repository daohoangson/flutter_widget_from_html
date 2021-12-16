import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

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
  Widget? buildText(BuildMetadata meta, TextStyleHtml tsh, InlineSpan text) {
    if (selectableText &&
        meta.overflow == TextOverflow.clip &&
        text is TextSpan) {
      return SelectableText.rich(
        text,
        maxLines: meta.maxLines > 0 ? meta.maxLines : null,
        textAlign: tsh.textAlign ?? TextAlign.start,
        textDirection: tsh.textDirection,
        textScaleFactor: 1.0,
        onSelectionChanged: selectableTextOnChanged,
      );
    }

    return super.buildText(meta, tsh, text);
  }
}
