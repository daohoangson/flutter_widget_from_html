## 0.8.5

- Improve `IFRAME` error & timer handling (#709)
- Fix `FwfhTextStyle` usage within `CupertinoPageScaffold` (#713)

## 0.8.4

- Add support for rtl in `HtmlTable` (#681)
- Improve parser for `border` inline style (#685, authored by @EA-YOUHOU)
- Remove decoration when href is missing (#678, authored by @EA-YOUHOU)
- Fix wrong text scale when `isSelectable=true` (#689)
- Fix background color being rendered twice (#691)
- Fix error on `TextStyle.merge` (#680, #693)

## 0.8.3+1

- Add support for `HtmlWidget.isSelectable` (#631)
- Add support for `HtmlWidget.onSelectionChanged` (#672)
- New package: `fwfh_selectable_text` (#672)

## 0.8.3

- Add support for Flutter@2.8 (#655)
- Add support for flutter_svg@1.0 (#648)
- Add support for webview_flutter@3.0 (#657)
- New package: `fwfh_text_style` (#628)
- Allow `HtmlWidget.textStyle` to be null (#632)
- Conditionally import `flutter_cache_manager` (#641)
- Avoid importing `dart:io` in svg_factory.dart (#653)
- Fix detached sub-tree still being built (#650)
- Fix bug text-align with padding (#651)
- Fix anchor being stuck (#659)

## 0.8.2

- Optimize `HtmlListMarker` (#623)
- Fix leading and trailing whitespace within `PRE` being trimmed (#624)
- Replace `evaluateJavascript` with `runJavascriptReturningResult` (#625)

## 0.8.1+1

- Fix missing `test/images` directory

## 0.8.1

- Mark enhanced `HtmlWidget.webViewXxx` properties as deprecated (#614)
- Add support for flutter_svg@0.23 (#611)
- Add support for `ListView` and `SliverList` constructor params (#616)

## 0.8.0

- Update for Flutter 2.5 (#587)
- BREAKING: Change `WidgetBit.inline` default alignment → bottom (#598)
- BREAKING: Remove `BuildMetadata.willBuildSubtree` (#607)
- BREAKING: Remove `BuildTree.replaceWith` (#607)
- BREAKING: Remove `WidgetFactory.buildBorder` (#608)
- Add support for `DETAILS` tag (#593)
- Add support for `BuildOp.onTreeFlattening` (#607)
- Add support for `display: inline-block` (#607)
- Add support for `border-radius` (#608)
- Fix bug extra space because of colspan (#600)
- Fix bug render loop when TABLE's baseline is needed (#604)

## 0.7.0

- Flutter 2.2
- BREAKING: Remove `HtmlWidget.buildAsyncBuilder` (#575)
- BREAKING: Remove `HtmlWidget.hyperlinkColor` (#571)
- BREAKING: Change `HtmlWidget.onTapUrl` signature to return a `FutureOr<bool>`. (#563)
- Show click cursor for `A` tag (#322)
- Add support for `HtmlWidget.renderMode` (#484)
- Add support for error & loading builder for network image (#547, thanks @DFelten)
- Improve `text-decoration` support (#569)
- Add support for `HtmlWidgetState.scrollToAnchor` (#577)
- Implement `HtmlWidget.onErrorBuilder` and `onLoadingBuilder` (#575)
- Fix bug border+background (#516)
- Fix incorrect UL/OL tag closing
- Fix `CssSizingValue` equality check
- Fix missing block margins on empty tag (#580)

This release includes some changes that may require migration if you have a custom `WidgetFactory`:

- Remove `TextStyleHtml.maxLines` and `.textOverflow` (#570)
- Remove `WidgetFactory.buildColumnPlaceholder` param `trimMarginVertical`
- Remove `WidgetFactory.buildColumnWidget` param `tsh`
- Change `WidgetFactory.buildImageWidget` params
- Replace `WidgetFactory.getListStyleMarker` with `getListMarkerText`
- Remove `WidgetFactory.imageLoadingBuilder` and `imageErrorBuilder` (#575)
- Replace `WidgetFactory.onTapAnchor` param `anchorContext` with `scrollTo`

## 0.6.2

- Add support for `AUDIO` tag (#530)
- Restore `computeLineMetrics` usage in Flutter web. (#561)
- Improve whitespace handling (#551)
- Fix negative margin/padding throwing exception (#510)
- Fix bug padding+background+h2 (#523)
- Fix `min-width` being ignored (#544)
- Fix portrait video (#553)

## 0.6.1

- Add support for white-space inline style (#483)
- Add support for `flutter_svg@0.22.0` (#498)
- Change onTapUrl signature to accept a returning value (#499)
- Fix `_ListMarkerRenderObject` invalid size
- Fix anchor bugs (#485, #491, #493 and #500)
- Fix TR display: none is still being rendered (#489)
- Fix empty TD being skipped -> incorrect table layout (#503)

## 0.6.0

- Flutter 2 with null safety 🚀
- Implement new packages:
  - `fwfh_webview` (#448)
  - `fwfh_url_launcher` (#450)
  - `fwfh_svg` (#452)
  - `fwfh_chewie` (#461)
  - `fwfh_cached_network_image` (#463)
- Use csslib to parse inline style (#379)
- Implement `computeDryLayout` (#411)
- Dispose recognizer properly (#466)
- Add Flutter Web support for `webViewMediaPlaybackAlwaysAllow` (#468)

## 0.5.2+1

- [CanvasKit] Add workaround for unimplemented `computeLineMetrics` (#441)

## 0.5.2

- Add support for TABLE attribute `cellpadding` (#365)
- Add support for table cell attributes `valign` (#365)
- Add WebView related params (#388, #431)
  - `unsupportedWebViewWorkaroundForIssue375`
  - `webViewDebuggingEnabled`
  - `webViewMediaPlaybackAlwaysAllow`
  - `webViewUserAgent`
- Add support for `HtmlWidget.onTapImage` callback (#398)
- Add support for sandbox="allow-scripts" (#420)
- Add support for file:// images (#432)
- Allow getting parsed inline styles from `dom.Element` directly (#367)
- Improve support for inline styles border, border-collapse and box-sizing  (#365)
- Fix line metrics are unavailable on Flutter web (#383)
- Fix IMG tag with dimensions being stretched (#429)

## 0.5.1+5

- Add support for chewie 0.12 (#373, authored by @urakozz)

## 0.5.1+4

- Improve RUBY baseline (#362)
- Fix `CssBlock` loosing stretched width on render object updated (#360)
- Fix nested sizing / text-align / vertical-align (#361)

## 0.5.1+3

- Fix LI marker position on non-default line height

## 0.5.1+2

- Fix bug `null` access (authored by @sweatfryash)
- Fix bug customWidgetBuilder does not work for TABLE, VIDEO (#353)

## 0.5.1+1

- Discard preferred width / height on infinity value. (#340)
- Fix image with dimensions cannot scale down (#341)
- Use a separated `BuildOp` for `display: block` (#342)

## 0.5.1

- Add support for auto, percentage sizing (e.g. `width: 50%`)
- Fix image cannot scale up (#337)

This release includes some changes that may require migration if you have a custom `WidgetFactory`:

- Replace `BuildMetadata.isBlockElement` with .`willBuildSubtree`.
- Replace `BuildOp.isBlockElement` with `.onWidgetsIsOptional`
- Split display parsing into `WidgetFactory.parseStyleDisplay`
- `TextStyleHtml.crossAxisAlignment` has been removed (no replacement)

## 0.5.0+7

- Fix incorrect alignment of list marker (#335)
- Add support for webview_flutter@1.0.0 (#336)

## 0.5.0+6

- Stop using singleton WidgetFactory by default
- Update `video_player` version constraint as suggested by publisher (#333, authored by @dgilperez)

## 0.5.0+5

- Use Stack.clipBehavior instead of .overflow (#321, authored by @bahador)

## 0.5.0+4

- Add support for flutter_svg@0.19.0 (#315)
- Add support for anchors (#317)

## 0.5.0+3

This is a big release with lots of improvements under the hood. If you don't extends `WidgetFactory` yourself then there are only two changes that may affect your app:

- `customStylesBuilder` returns `Map` instead of `List`
- `onTapUrl` is called for incomplete URL

Other changes:

- Restore sizing support (#248)
- Expand support for `text-align` with end/start/-moz-center/-webkit-center (#305)
- Update UL bullet for correctness (#306)
- Add support for colspan / rowspan in table (#157)
- Add support for inline style `text-overflow` (#204)
- Add support em/px in `line-height` and % in `font-size` (#220)
- Add support for svg src in `IMG` (#233)
- Add support for inline `margin`, `padding` (#237)
- Add support for `pt` unit (#266)
- Add support for inline style `background` (color only) (#275)
- Bug fixes

Finally, BREAKING changes if you use a custom `WidgetFactory`:

- `BuildOp`: callback params changed
- `BuiltPiece` has been removed
- `NodeMetadata` -> `BuildMetadata`
- `TextBit` -> `BuildBit`
- `TextStyleBuilders` -> `TextStyleBuilder`
- `WidgetFactory`
  - All `buildXxx` methods now have `BuildMetadata` as first parameter
  - `parseTag(NodeMetadata, String, String)` -> `parse(BuildMetadata)`

## 0.4.3

- Implement proper inline support for `margin` and `padding` (#237)
- Rollback support for sizing
- Make NodeMetadata.(op|styles) ignore `null`

## 0.4.2

- Add support for latest Flutter dev channel (#227)
- Add support for inline style sizing (#206): `width`, `height`, `max-width`, `max-height`, `min-width` and `min-height`
- Add support for inline style `text-overflow` (#204)
- Bug fixes

## 0.4.1

- BREAKING: Remove `TextStyleBuilders.recognizer` (#168)
- BREAKING: Remove `lazySet` method (#169)
- BREAKING: Remove `HtmlConfig` and change `factoryBuilder` method signature (#173)
- BREAKING: Remove `bodyPadding`
- BREAKING: Replace `builderCallback` with `customStylesBuilder` and `customWidgetBuilder` (#169)
- Add support for tag SVG (#133)
- Add support for tag RUBY (#144)
- Add support for attribute `align` (#153)
- Add support for async build (#154)
- Add support for inline style `padding` (#160)
- Add support for multiple font families (#172)
- Add support for `line-height` (#193)
- Add support for attribute `VIDEO.poster` (#197)
- Improve support for right-to-left (#141)
- Improve inline `color` support (#201)
- Bug fixes

## 0.3.3+4

- Fix non-breaking space rendering (#185)

## 0.3.3+3

- Switch to MIT license

## 0.3.3+2

- Fix bug vertical-align with trailing whitespace (#170)

## 0.3.3+1

- Fix conflict between TABLE and background-color (#171)

## 0.3.3

- Improve whitespace handling (#137)
- Add support for tag SUB, SUP and inline style `vertical-align` (#143)
- Fix text bit loop initial state (#156)

## 0.3.2+2

- Use minimum main axis size
- Update dependencies

## 0.3.2+1

- Fix IMG wrong size when device has scaled text (#127)
- Update supported Flutter version `>=1.12.13+hotfix.5 <2.0.0`

## 0.3.2

- Update supported Flutter version `>=1.10.15 <2.0.0`

## 0.2.4+4

- Fix bug rendering ZERO WIDTH SPACE character (#119)

## 0.2.4+3

- Improve BR rendering logic
- Add `enableCaching` prop to control cache logic

## 0.2.4+2

- Add basic detection and support for `Directionality` widget during LI/OL/UL rendering (#115)
- Fix bug LI has empty A (#112)

## 0.2.4+1

- Improve caching logic (#112)
- Fix extra space after BR tag (#111)
- Fix cached image not being rendered on first build (#113)

## 0.2.4

- Add support for `type`/`start`/`reversed` (LI/OL/UL) (#91)
- Add support for tag FONT (#109)

## 0.2.3+4

- Improve IMG error handling (#96)
- Fix bug rendering nested list (OL/UL) with single child (#88)
- Fix bug related to null widget (#94, #95)

## 0.2.3+3

- Improve BR rendering to be consistent with browsers (#83, #84)
- Improve TABLE rendering to support multiple tables (#85, #86)

## 0.2.3+2

- Fix bug rendering empty TD tag (#81)
- Improve white space rendering
- Improve IMG rendering

## 0.2.3+1

- Build `RichText` with proper `textScaleFactor` (#75, #78)

## 0.2.3

- Re-implement text-align support to avoid conflicts (#66, #74)
- Fix WebView bug triggering browser for http 301/302 urls
- Improve performance when being put in list views (#62)

## 0.2.2+1

- Update coding convention

## 0.2.2

- Intercept all navigation requests within IFRAME (#48)
- Add support for InlineSpan / inline image (PR #53, issue #7)
- Add support for asset:// image (PR #52, issue #51)
- Add support for new tag: VIDEO (PR #47, issue #46)

## 0.2.1+1

- Merge `textStyle` with default for easy usage (#45)
- Fix bug in whitespace handling (#44)

## 0.2.1

- Add `unsupportedWebViewWorkaroundForIssue37` to address WebView issue temporary (#37)
- Render IMG inline whenever possible
- Use accent color for tag A
- Other bug fixes and improvements

## 0.2.0

- Add support for new tags:
  ABBR ACRONYM ADDRESS ARTICLE ASIDE BIG BLOCKQUOTE CITE CENTER DD/DL/DT DEL DFN
  FIGURE FIGCAPTION FOOTER HEADER HR INS KBD MAIN MARK NAV Q S SAMP STRIKE SECTION
  SMALL TT VAR
- Add support for table tags: TABLE CAPTION THEAD TBODY TFOOT TR TD TH
- Add support for `background-color`
- Add support for `em` CSS unit
- Improve support for existing tags: BR H1 H2 H3 H4 H5 H6 IMG P PRE
- Improve support for IFRAME: `WebView` can now resize itself to fit its contents
- Simplify config for easy usage and customization
- Fix bug using int.parse (#34)

## 0.1.5

- Fix margin with partial invalid values (#21)

## 0.1.4

- Update dependencies (#12)
- Add support for web view (#19)

## 0.1.3

- Update flutter_widget_from_html_core 0.1.3

## 0.1.2

- Update flutter_widget_from_html_core 0.1.2

## 0.1.1

- Update flutter_widget_from_html_core 0.1.1

## 0.0.1

- First release
