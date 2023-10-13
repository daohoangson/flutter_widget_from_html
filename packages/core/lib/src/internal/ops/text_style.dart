part of '../core_ops.dart';

const kCssDirection = 'direction';
const kCssDirectionLtr = 'ltr';
const kCssDirectionRtl = 'rtl';
const kAttributeDir = 'dir';

const kCssFontFamily = 'font-family';

const kCssFontSize = 'font-size';
const kCssFontSizeXxLarge = 'xx-large';
const kCssFontSizeXLarge = 'x-large';
const kCssFontSizeLarge = 'large';
const kCssFontSizeMedium = 'medium';
const kCssFontSizeSmall = 'small';
const kCssFontSizeXSmall = 'x-small';
const kCssFontSizeXxSmall = 'xx-small';
const kCssFontSizeLarger = 'larger';
const kCssFontSizeSmaller = 'smaller';
const kCssFontSizes = {
  '1': kCssFontSizeXxSmall,
  '2': kCssFontSizeXSmall,
  '3': kCssFontSizeSmall,
  '4': kCssFontSizeMedium,
  '5': kCssFontSizeLarge,
  '6': kCssFontSizeXLarge,
  '7': kCssFontSizeXxLarge,
};

const kCssFontStyle = 'font-style';
const kCssFontStyleItalic = 'italic';
const kCssFontStyleNormal = 'normal';

const kCssFontWeight = 'font-weight';
const kCssFontWeightBold = 'bold';

const kCssLineHeight = 'line-height';
const kCssLineHeightNormal = 'normal';

extension BuildTreeEllipsis on BuildTree {
  _BuildTreeEllipsis get _ellipsis =>
      getNonInheritedProperty<_BuildTreeEllipsis>() ??
      setNonInheritedProperty<_BuildTreeEllipsis>(const _BuildTreeEllipsis());

  int get maxLines => _ellipsis.maxLines;

  set maxLines(int value) => setNonInheritedProperty<_BuildTreeEllipsis>(
        _ellipsis.copyWith(maxLines: value),
      );

  TextOverflow get overflow => _ellipsis.overflow;

  set overflow(TextOverflow value) =>
      setNonInheritedProperty<_BuildTreeEllipsis>(
        _ellipsis.copyWith(overflow: value),
      );
}

@immutable
class _BuildTreeEllipsis {
  final int maxLines;
  final TextOverflow overflow;

  const _BuildTreeEllipsis({
    this.maxLines = -1,
    this.overflow = TextOverflow.clip,
  });

  _BuildTreeEllipsis copyWith({
    int? maxLines,
    TextOverflow? overflow,
  }) =>
      _BuildTreeEllipsis(
        maxLines: maxLines ?? this.maxLines,
        overflow: overflow ?? this.overflow,
      );
}
