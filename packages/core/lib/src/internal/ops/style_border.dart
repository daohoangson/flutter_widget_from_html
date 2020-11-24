import 'package:flutter/widgets.dart';

import '../../core_data.dart';
import '../../core_helpers.dart';
import '../../core_widget_factory.dart';
import '../core_parser.dart';

const kCssBorder = 'border';
const kCssBoxSizing = 'box-sizing';
const kCssBoxSizingContentBox = 'content-box';
const kCssBoxSizingBorderBox = 'border-box';

class StyleBorder {
  final WidgetFactory wf;

  final _borderHasBeenBuiltFor = Expando<bool>();

  StyleBorder(this.wf);

  BuildOp get buildOp => BuildOp(
        onTree: (meta, tree) {
          if (meta.willBuildSubtree) return;
          final border = _tryParseBorder(meta);
          if (border == null) return;

          _borderHasBeenBuiltFor[meta] = true;
          final copied = tree.copyWith() as BuildTree;
          final built = wf
              .buildColumnPlaceholder(meta, copied.build())
              ?.wrapWith((context, child) =>
                  _buildBorder(meta, context, child, border));
          if (built == null) return;

          tree.replaceWith(WidgetBit.inline(tree, built));
        },
        onWidgets: (meta, widgets) {
          if (_borderHasBeenBuiltFor[meta] == true) return widgets;
          if (widgets?.isNotEmpty != true) return null;
          final border = _tryParseBorder(meta);
          if (border == null) return widgets;

          return listOrNull(wf.buildColumnPlaceholder(meta, widgets)?.wrapWith(
              (context, child) => _buildBorder(meta, context, child, border)));
        },
        onWidgetsIsOptional: true,
        priority: 88888,
      );

  Widget _buildBorder(
    BuildMetadata meta,
    BuildContext context,
    Widget child,
    _Border border,
  ) {
    final tsh = meta.tsb().build(context);
    return wf.buildBorder(
      meta,
      child,
      border.getValue(tsh),
      isBorderBox: meta[kCssBoxSizing] == kCssBoxSizingBorderBox,
    );
  }

  static final _parsedBorders = Expando<_Border>();
  static Border getParsedBorder(BuildMetadata meta, BuildContext context) {
    final border = _parsedBorders[meta.element];
    if (border == null) return null;
    return border.getValue(meta.tsb().build(context));
  }
}

final _borderValuesThreeRegExp = RegExp(r'^(.+)\s+(.+)\s+(.+)$');
final _borderValuesTwoRegExp = RegExp(r'^(.+)\s+(.+)$');

_Border _tryParseBorder(BuildMetadata meta) {
  var border = _Border();

  for (final style in meta.styles) {
    if (!style.key.startsWith(kCssBorder)) continue;

    final borderSide = _tryParseBorderSide(style.value);
    final suffix = style.key.substring(kCssBorder.length);
    if (suffix.isEmpty) {
      border = border.copyWith(all: borderSide);
    } else {
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
  String color_, style_, width_;

  final valuesThree = _borderValuesThreeRegExp.firstMatch(value);
  if (valuesThree != null) {
    color_ = valuesThree[3];
    style_ = valuesThree[2];
    width_ = valuesThree[1];
  } else {
    final valuesTwo = _borderValuesTwoRegExp.firstMatch(value);
    if (valuesTwo != null) {
      style_ = valuesTwo[2];
      width_ = valuesTwo[1];
    } else {
      width_ = value;
    }
  }

  final width = tryParseCssLength(width_);
  if (width == null || width.number <= 0) return _BorderSide.none;

  return _BorderSide(
    color: tryParseColor(color_),
    style: _tryParseBorderStyle(style_),
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
  final _BorderSide _all;
  final _BorderSide bottom;
  final _BorderSide inlineEnd;
  final _BorderSide inlineStart;
  final _BorderSide _left;
  final _BorderSide _right;
  final _BorderSide top;

  const _Border({
    _BorderSide all,
    this.bottom,
    this.inlineEnd,
    this.inlineStart,
    _BorderSide left,
    _BorderSide right,
    this.top,
  })  : _all = all,
        _left = left,
        _right = right;

  _Border copyWith({
    _BorderSide all,
    _BorderSide bottom,
    _BorderSide inlineEnd,
    _BorderSide inlineStart,
    _BorderSide left,
    _BorderSide right,
    _BorderSide top,
  }) =>
      _Border(
        all: _BorderSide.copyWith(_all, all),
        bottom: _BorderSide.copyWith(this.bottom, bottom),
        inlineEnd: _BorderSide.copyWith(this.inlineEnd, inlineEnd),
        inlineStart: _BorderSide.copyWith(this.inlineStart, inlineStart),
        left: _BorderSide.copyWith(_left, left),
        right: _BorderSide.copyWith(_right, right),
        top: _BorderSide.copyWith(this.top, top),
      );

  Border getValue(TextStyleHtml tsh) {
    final bottom = _BorderSide.copyWith(_all, this.bottom)?.getValue(tsh);
    final left = getValueLeft(tsh);
    final right = getValueRight(tsh);
    final top = _BorderSide.copyWith(_all, this.top)?.getValue(tsh);
    if (bottom == null && left == null && right == null && top == null) {
      return null;
    }

    return Border(
      bottom: bottom ?? BorderSide.none,
      left: left ?? BorderSide.none,
      right: right ?? BorderSide.none,
      top: top ?? BorderSide.none,
    );
  }

  BorderSide getValueLeft(TextStyleHtml tsh) => _BorderSide.copyWith(
          _all,
          _left ??
              (tsh.textDirection == TextDirection.ltr
                  ? inlineStart
                  : inlineEnd))
      ?.getValue(tsh);

  BorderSide getValueRight(TextStyleHtml tsh) => _BorderSide.copyWith(
          _all,
          _right ??
              (tsh.textDirection == TextDirection.ltr
                  ? inlineEnd
                  : inlineStart))
      ?.getValue(tsh);
}

@immutable
class _BorderSide {
  final Color color;
  final BorderStyle style;
  final CssLength width;

  const _BorderSide({this.color, this.style, this.width});

  static const none = _BorderSide();

  BorderSide getValue(TextStyleHtml tsh) => identical(this, none)
      ? null
      : BorderSide(
          color: color ?? tsh.style.color,
          style: style ?? BorderStyle.none,
          width: width?.getValue(tsh) ?? 0.0,
        );

  static _BorderSide copyWith(_BorderSide base, _BorderSide value) =>
      base == null || identical(value, none)
          ? value
          : value == null
              ? base
              : _BorderSide(
                  color: value.color ?? base.color,
                  style: value.style ?? base.style,
                  width: value.width ?? base.width,
                );
}
