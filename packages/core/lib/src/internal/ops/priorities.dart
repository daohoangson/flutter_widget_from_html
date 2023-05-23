part of '../core_ops.dart';

/// Build op priorities.
///
/// All first party build ops should use a priority from this list
/// to make sure the rendering order is stable, at least for support tags / stylings.
///
/// User's build op has a default priority of 10 so they should run
/// after our early ops and before our normal ops.
class Prioritiy {
  static const _baseEarly00 = -3000000000000000;
  static const _baseNormal00 = 1000000000000000;
  static const _baseBoxModel = 5000000000000000;
  static const _step = 1000000000;
  static const _max = 9007199254740991;

  static const tagA = _baseNormal00 + _step;
  static const tagBr = tagA + _step;
  static const tagDetails = tagBr + _step;
  static const tagFont = tagDetails + _step;
  static const tagHr = tagFont + _step;
  static const tagImg = tagHr + _step;
  static const tagLiItem = tagImg + _step;
  static const tagLiList = tagLiItem + _step;
  static const tagPre = tagLiList + _step;
  static const tagQ = tagPre + _step;
  static const tagRuby = tagQ + _step;
  static const tagTableAttributeBorder = tagRuby + _step;
  static const tagTableAttributeCellPadding = tagTableAttributeBorder + _step;
  static const tagTableRow = tagTableAttributeCellPadding + _step;
  static const tagTableRowGroup = tagTableRow + _step;
}

class Early {
  static const _step = Prioritiy._step;

  static const cssBorderInline = Prioritiy._baseEarly00 + _step;
  static const cssTextAlign = cssBorderInline + _step;
  static const cssVerticalAlign = cssTextAlign + _step;
  static const tagTable = cssVerticalAlign + _step;
}

/// Box model priorities.
///
/// Note for maintainer: box model priorities must be in the correct order
/// to render padding inside border inside margin etc.
///
/// Values in other groups are sorted alphabetically.
class BoxModel {
  static const _step = Prioritiy._step;

  static const sizing = Prioritiy._baseBoxModel + _step;
  static const verticalAlign = sizing + _step;
  static const padding = verticalAlign + _step;
  static const border = padding + _step;
  static const background = border + _step;
  static const margin = background + _step;
  static const sizingMinWidthZero = margin + _step;
}

class Late {
  static const _step = Prioritiy._step;

  static const anchor = displayBlock - _step;
  static const displayBlock = displayInlineBlock - _step;
  static const displayInlineBlock = tagSummary - _step;
  static const tagSummary = tagTableCaption - _step;
  static const tagTableCaption = tagTableCell - _step;
  static const tagTableCell = displayNone - _step;
  static const displayNone = Prioritiy._max;
}
