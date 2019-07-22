## 0.2.2+1

* Update coding convention

## 0.2.2

* Intercept all navigation requests within IFRAME (#48)
* Add support for InlineSpan / inline image (PR #53, issue #7)
* Add support for asset:// image (PR #52, issue #51)

## 0.2.1+1

* Merge `textStyle` with default for easy usage (#45)
* Fix bug in whitespace handling (#44)

## 0.2.1

* Render IMG inline whenever possible
* Other bug fixes and improvements

## 0.2.0

* Add support for new tags:
  ABBR ACRONYM ADDRESS ARTICLE ASIDE BIG BLOCKQUOTE CITE CENTER DD/DL/DT DEL DFN
  FIGURE FIGCAPTION FOOTER HEADER HR INS KBD MAIN MARK NAV Q S SAMP STRIKE SECTION
  SMALL TT VAR
* Add support for table tags: TABLE CAPTION THEAD TBODY TFOOT TR TD TH
* Add support for `background-color`
* Add support for `em` CSS unit
* Improve support for existing tags: BR H1 H2 H3 H4 H5 H6 IMG P PRE
* Simplify config for easy usage and customization
* Fix bug using int.parse (#34)

## 0.1.5

* Fix margin with partial invalid values (#21)

## 0.1.4

* Update dependencies (#12)
* Fix layout rebuild loop because of `Column`'s `UniqueKey` (#19)

## 0.1.3

* Fix bug stylings got lost during block rendering (#10)

## 0.1.2

* Fix bug rendering overlapping elements with styling (#11)
* Expand CSS color hex values support

## 0.1.1

* Bug fixes
* Add support for BuildOp, making it easier to render new html tags
* Add support for margin inline styling

## 0.0.1

* First release
