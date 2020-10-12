import 'package:flutter/widgets.dart';

import '../../core_data.dart';
import '../../core_helpers.dart';
import '../../core_widget_factory.dart';
import '../core_parser.dart';

const kCssBorder = 'border';

class StyleBorder {
  final WidgetFactory wf;

  StyleBorder(this.wf);

  BuildOp get buildOp => BuildOp(
        onTree: (meta, tree) {
          if (meta.willBuildSubtree) return;
          final border = _tryParseBorder(meta);
          if (border == null) return;

          final copied = tree.copyWith() as BuildTree;
          final built = wf
              .buildColumnPlaceholder(meta, copied.build())
              ?.wrapWith((context, child) =>
                  _buildBorder(meta, context, child, border));
          if (built == null) return;

          tree.replaceWith(WidgetBit.inline(tree, built));
        },
        onWidgets: (meta, widgets) {
          if (widgets?.isNotEmpty != true) return null;
          final border = _tryParseBorder(meta);
          if (border == null) return widgets;

          return listOrNull(wf.buildColumnPlaceholder(meta, widgets)?.wrapWith(
              (context, child) => _buildBorder(meta, context, child, border)));
        },
        onWidgetsIsOptional: true,
        priority: 88888,
      );

  static final _parsedBorders = Expando<_Border>();
  static Border getParsedBorder(BuildMetadata meta, BuildContext context) {
    final border = _parsedBorders[meta.element];
    if (border == null) return null;
    return border.getValue(meta.tsb().build(context));
  }
}

Widget _buildBorder(
    BuildMetadata meta, BuildContext context, Widget child, _Border border) {
  final tsh = meta.tsb().build(context);
  final b = border.getValue(tsh);
  return Container(
    child: child,
    decoration: BoxDecoration(border: b),
  );
}

final _borderValuesThreeRegExp = RegExp(r'^(.+)\s+(.+)\s+(.+)$');
final _borderValuesTwoRegExp = RegExp(r'^(.+)\s+(.+)$');

_Border _tryParseBorder(BuildMetadata meta) {
  _Border border;

  for (final style in meta.styles) {
    if (!style.key.startsWith(kCssBorder)) continue;

    final borderSide = _tryParseBorderSide(style.value);
    final suffix = style.key.substring(kCssBorder.length);
    if (suffix.isEmpty) {
      border = _Border(
        bottom: borderSide,
        inlineEnd: borderSide,
        inlineStart: borderSide,
        top: borderSide,
      );
    } else {
      border ??= _Border();

      switch (suffix) {
        case kSuffixBottom:
        case kSuffixBlockEnd:
          border = border.copyWith(bottom: borderSide);
          break;
        case kSuffixInlineEnd:
          border = border.copyWith(inlineEnd: borderSide);
          break;
        case kSuffixInlineStart:
          border = border.copyWith(inlineStart: borderSide);
          break;
        case kSuffixLeft:
          border = border.copyWith(left: borderSide);
          break;
        case kSuffixRight:
          border = border.copyWith(right: borderSide);
          break;
        case kSuffixTop:
        case kSuffixBlockStart:
          border = border.copyWith(top: borderSide);
          break;
      }
    }
  }

  StyleBorder._parsedBorders[meta.element] = border;

  return border;
}

_BorderSide _tryParseBorderSide(String value) {
  final valuesThree = _borderValuesThreeRegExp.firstMatch(value);
  if (valuesThree != null) {
    final width = tryParseCssLength(valuesThree[1]);
    if (width == null || width.number <= 0) return _BorderSide.none;
    return _BorderSide(
      color: tryParseColor(valuesThree[3]),
      style: _tryParseBorderStyle(valuesThree[2]),
      width: width,
    );
  }

  final valuesTwo = _borderValuesTwoRegExp.firstMatch(value);
  if (valuesTwo != null) {
    final width = tryParseCssLength(valuesTwo[1]);
    if (width == null || width.number <= 0) return _BorderSide.none;
    return _BorderSide(
      style: _tryParseBorderStyle(valuesTwo[2]),
      width: width,
    );
  }

  final width = tryParseCssLength(value);
  if (width == null || width.number <= 0) return _BorderSide.none;
  return _BorderSide(
    style: BorderStyle.solid,
    width: width,
  );
}

BorderStyle _tryParseBorderStyle(String value) {
  switch (value) {
    case 'dotted':
    case 'dashed':
    case 'double':
    case 'solid':
      // TODO: add proper support for other border styles
      return BorderStyle.solid;
  }

  return BorderStyle.none;
}

@immutable
class _Border {
  final _BorderSide bottom;
  final _BorderSide inlineEnd;
  final _BorderSide inlineStart;
  final _BorderSide _left;
  final _BorderSide _right;
  final _BorderSide top;

  const _Border({
    this.bottom,
    this.inlineEnd,
    this.inlineStart,
    _BorderSide left,
    _BorderSide right,
    this.top,
  })  : _left = left,
        _right = right;

  _Border copyWith({
    _BorderSide bottom,
    _BorderSide inlineEnd,
    _BorderSide inlineStart,
    _BorderSide left,
    _BorderSide right,
    _BorderSide top,
  }) =>
      _Border(
        bottom: bottom ?? this.bottom,
        inlineEnd: inlineEnd ?? this.inlineEnd,
        inlineStart: inlineStart ?? this.inlineStart,
        left: left ?? _left,
        right: right ?? _right,
        top: top ?? this.top,
      );

  Border getValue(TextStyleHtml tsh) => Border(
        bottom: bottom?.getValue(tsh) ?? BorderSide.none,
        left: getValueLeft(tsh) ?? BorderSide.none,
        right: getValueRight(tsh) ?? BorderSide.none,
        top: top?.getValue(tsh) ?? BorderSide.none,
      );

  BorderSide getValueLeft(TextStyleHtml tsh) => (_left ??
          (tsh.textDirection == TextDirection.ltr ? inlineStart : inlineEnd))
      ?.getValue(tsh);

  BorderSide getValueRight(TextStyleHtml tsh) => (_right ??
          (tsh.textDirection == TextDirection.ltr ? inlineEnd : inlineStart))
      ?.getValue(tsh);
}

@immutable
class _BorderSide {
  final Color color;
  final BorderStyle style;
  final CssLength width;

  const _BorderSide({this.color, this.style, this.width});

  static const none = _BorderSide(style: BorderStyle.none, width: CssLength(0));

  BorderSide getValue(TextStyleHtml tsh) => identical(this, none)
      ? BorderSide.none
      : BorderSide(
          color: color ?? const Color(0xFF000000),
          style: style ?? BorderStyle.solid,
          width: width?.getValue(tsh) ?? 1.0,
        );
}
