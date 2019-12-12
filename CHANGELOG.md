## 0.3.2-rc

* 0.2.4+4
  * Fix bug rendering ZERO WIDTH SPACE character (#119)

## 0.3.1-rc

* 0.2.4+3
  * Improve BR rendering logic
  * Add `enableCaching` prop to control cache logic
* 0.2.4+2
  * Add basic detection and support for `Directionality` widget during LI/OL/UL rendering (#115)
  * Fix bug LI has empty A (#112)
* 0.2.4+1
  * Improve caching logic (#112)
  * Fix extra space after BR tag (#111)
  * Fix cached image not being rendered on first build (#113)
* 0.2.4
  * Add support for `type`/`start`/`reversed` (LI/OL/UL) (#91)
  * Add support for tag FONT (#109)

## 0.3.0-rc

* Use `cached_network_image@2.0.0-rc` for compatibility with Flutter 1.10.15 (master channel)

## 0.2.3+4

* Improve IMG error handling (#96)
* Fix bug rendering nested list (OL/UL) with single child (#88)
* Fix bug related to null widget (#94, #95)

## 0.2.3+3

* Improve BR rendering to be consistent with browsers (#83, #84)
* Improve TABLE rendering to support multiple tables (#85, #86)

## 0.2.3+2

* Fix bug rendering empty TD tag (#81)
* Improve white space rendering
* Improve IMG rendering

## 0.2.3+1

* Build `RichText` with proper `textScaleFactor` (#75, #78)

## 0.2.3

* Re-implement text-align support to avoid conflicts (#66, #74)
* Fix WebView bug triggering browser for http 301/302 urls
* Improve performance when being put in list views (#62)

## 0.2.2+1

* Update coding convention

## 0.2.2

* Intercept all navigation requests within IFRAME (#48)
* Add support for InlineSpan / inline image (PR #53, issue #7)
* Add support for asset:// image (PR #52, issue #51)
* Add support for new tag: VIDEO (PR #47, issue #46)

## 0.2.1+1

* Merge `textStyle` with default for easy usage (#45)
* Fix bug in whitespace handling (#44)

## 0.2.1

* Add `unsupportedWebViewWorkaroundForIssue37` to address WebView issue temporary (#37)
* Render IMG inline whenever possible
* Use accent color for tag A
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
* Improve support for IFRAME: `WebView` can now resize itself to fit its contents
* Simplify config for easy usage and customization
* Fix bug using int.parse (#34)

## 0.1.5

* Fix margin with partial invalid values (#21)

## 0.1.4

* Update dependencies (#12)
* Add support for web view (#19)

## 0.1.3

* Update flutter_widget_from_html_core 0.1.3

## 0.1.2

* Update flutter_widget_from_html_core 0.1.2

## 0.1.1

* Update flutter_widget_from_html_core 0.1.1

## 0.0.1

* First release
