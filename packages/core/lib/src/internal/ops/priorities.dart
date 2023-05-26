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
  static const tagTableCellRenderedBlock = tagTableAttributeCellPadding + _step;
  static const tagTableRow = tagTableCellRenderedBlock + _step;
  static const tagTableRowGroup = tagTableRow + _step;
}

class Early {
  static const _step = Prioritiy._step;

  static const attributeAlign = Prioritiy._baseEarly00 + _step;
  static const attributeDir = attributeAlign + _step;
  static const cssTextAlign = attributeDir + _step;
  static const tagAcronym = cssTextAlign + _step;
  static const tagAddress = tagAcronym + _step;
  static const tagCenter = tagAddress + _step;
  static const tagDd = tagCenter + _step;
  static const tagDiv = tagDd + _step;
  static const tagDt = tagDiv + _step;
  static const tagFigure = tagDt + _step;
  static const tagH1 = tagFigure + _step;
  static const tagH2 = tagH1 + _step;
  static const tagH3 = tagH2 + _step;
  static const tagH4 = tagH3 + _step;
  static const tagH5 = tagH4 + _step;
  static const tagH6 = tagH5 + _step;
  static const tagIns = tagH6 + _step;
  static const tagMark = tagIns + _step;
  static const tagP = tagMark + _step;
  static const tagRp = tagP + _step;
  static const tagScript = tagRp + _step;
  static const tagStrike = tagScript + _step;
  static const tagSub = tagStrike + _step;
  static const tagSup = tagSub + _step;
  static const tagTableAttributeBorderChild = tagSup + _step;
  static const tagTableAttributeCellPaddingChild =
      tagTableAttributeBorderChild + _step;
  static const tagTableCaptionTextAlignCenter =
      tagTableAttributeCellPaddingChild - _step;
  static const tagTableCellAttributeValign =
      tagTableCaptionTextAlignCenter + _step;
  static const tagTableCellDefaultStyles = tagTableCellAttributeValign + _step;
  static const tagTableDisplayTable = tagTableCellDefaultStyles + _step;
  static const tagTableHeaderCellDefaultStyles = tagTableDisplayTable + _step;
  static const tagTableRenderBlock = tagTableHeaderCellDefaultStyles + _step;
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
  static const tagSummary = tagTableCaptionRenderBlock - _step;
  static const tagTableCaptionRenderBlock = displayNone - _step;
  static const displayNone = Prioritiy._max;
}
