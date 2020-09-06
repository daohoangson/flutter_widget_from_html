## 0.5.0-rc.2020081901

This is a big release with lots of improvements under the hood, probably the last pre-release before `v0.5.0` stable is out. If you don't extends `WidgetFactory` yourself then there are only two BREAKING changes that may affect your app:

* BREAKING: `customStylesBuilder` returns `Map` instead of `List`
* BREAKING: `onTapUrl` is called for incomplete URL

Other changes:

* Add support for `pt` unit (#266)
* Add support for inline style `background` (color only) (#275)
* Implement inline support for `margin`, `padding` (#237)
* Fix sizing (width, heigh, etc. #248)
* Fix bug `textScaleFactor` being considered twice during rendering (#267)
* Fix widget tree not being updated on dependency changes (#284)

Finally, BREAKING changes if you have a custom `WidgetFactory`:

* `BuildOp`: callback params changed
* `ImgMetadata` -> `ImageMetadata`:
  * Add `ImageSource`
* `NodeMetadata` -> `BuildMetadata`:
  * Text style properties moved into `TextStyleHtml`
  * Remove `hasOps`
  * Remove `hasParents`
  * `ops` -> `buildOps`
  * `parents` -> `parentOps`
  * `op=` -> `register(BuildOp)`
  * `style` -> `operator [](String)`
  * `styles=` -> `operator []=(String, String)`
* `TableData` -> `TableMetadata`
* `TextBit`
  * Remove `TextWhitespace`, `TextWhitespaceType`
  * Remove `data`
  * Remove `canCompile`
  * Remove `hasTrailingWhitespace` (`TextBits` still has it)
  * `InlineSpan compile(TextStyle)` -> `CompileTo compile(CompileFrom)`
  * `static TextBit TextBit.nextOf(TextBit)` -> instance `TextBit next()`
* `TextStyleBuilders` -> `TextStyleBuilder`:
  * Builder signature `TextStyleHtml Function(BuildContext, TextStyleHtml, T)` -> `TextStyleHtml Function(TextStyleHtml, T)`
* `WidgetFactory`
  * `buildXxx` methods have `BuildMetadata` as first parameter
  * `buildImageXxx` -> `imageXxx`
  * `buildGestureTapCallbackForUrl` -> `gestureTapCallback`
  * `parseTag(NodeMetadata, String, String)` -> `parse(BuildMetadata)`
* `WidgetPlaceholder`
  * Constructor changed
  * Builder signature `Iterable<Widget> Function(BuildContext, Iterable<Widget>, T)` -> `Widget Function(BuildContext, Widget)`

## 0.5.0-rc.2020071301

* BREAKING: Remove 3rd param `wf` from `WidgetPlaceholder.wrap`
* BREAKING: Remove field `HtmlWidget.tableCellPadding`
* BREAKING: Remove class `CssLineHeight`
* BREAKING: Remove class `ImageLayout` (#230)
* BREAKING: Change param `builder` of `TextStyleBuilders.enqueue`
* BREAKING: Change method `WidgetFactory.buildImage`
* Add support for colspan / rowspan in table (#157)
* Add support for inline style `text-overflow` (#204)
* Add support for inline style sizing (#206): `width`, `height`, `max-width`, `max-height`, `min-width` and `min-height`
* Add support em/px in `line-height` and % in `font-size` (#220)
* Add support for svg src in `IMG` (#233)
* Bug fixes

## 0.4.1

* BREAKING: Remove `TextStyleBuilders.recognizer` (#168)
* BREAKING: Remove `lazySet` method (#169)
* BREAKING: Remove `HtmlConfig` and change `factoryBuilder` method signature (#173)
* BREAKING: Remove `bodyPadding`
* BREAKING: Replace `builderCallback` with `customStylesBuilder` and `customWidgetBuilder` (#169)
* Add support for tag RUBY (#144)
* Add support for attribute `align` (#153) 
* Add support for async build (#154)
* Add support for inline style `padding` (#160)
* Add support for multiple font families (#172)
* Add support for `line-height` (#193)
* Improve support for right-to-left (#141)
* Improve inline `color` support (#201)
* Bug fixes

## 0.3.3+4

* Fix non-breaking space rendering (#185)

## 0.3.3+3

* Switch to MIT license

## 0.3.3+2

* Fix bug vertical-align with trailing whitespace (#170)

## 0.3.3+1

* Fix conflict between TABLE and background-color (#171)

## 0.3.3

* Improve whitespace handling (#137)
* Add support for tag SUB, SUP and inline style `vertical-align` (#143)
* Fix text bit loop initial state (#156)

## 0.3.2+2

* Use minimum main axis size

## 0.3.2+1

* Fix IMG wrong size when device has scaled text (#127)

## 0.2.4+4

* Fix bug rendering ZERO WIDTH SPACE character (#119)

## 0.2.4+3

* Improve BR rendering logic
* Add `enableCaching` prop to control cache logic

## 0.2.4+2

* Add basic detection and support for `Directionality` widget during LI/OL/UL rendering (#115)
* Fix bug LI has empty A (#112)

## 0.2.4+1

* Improve caching logic (#112)
* Fix extra space after BR tag (#111)
* Fix cached image not being rendered on first build (#113)

## 0.2.4

* Add support for `type`/`start`/`reversed` (LI/OL/UL) (#91)
* Add support for tag FONT (#109)

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

* Fix bug stylings got lost during text rendering (#10)

## 0.1.2

* Fix bug rendering overlapping elements with styling (#11)
* Expand CSS color hex values support

## 0.1.1

* Bug fixes
* Add support for BuildOp, making it easier to render new html tags
* Add support for margin inline styling

## 0.0.1

* First release
