## 0.16.1

- Fix `text-align: center` inside tables (#1451)

## 0.16.0

- Requires Flutter 3.22 (#1403)
- Add support for CSS `gap` (#1403)

## 0.15.2

- Add support for Flutter 3.24 (#1308)
- Fix `HtmlFlex` incompatibility with Flutter@master (#1308)
- Fix unnamed function parameters (#1309, authored by hassony105)
- Fix RenderSliver mode error when html input is empty (#1321, authored by vanvixi)

## 0.15.1

- Requires Flutter 3.10 (#1250)
- Add support for `currentcolor` (#1240)
- Fix zero size image (#1266)

## 0.14.12

- Expand roman support to 3999 (#1154, authored by @ngthailam)
- Add support for `text-shadow` (#1158, also by @ngthailam 🎉)
- Improve support for `display: flex` (#1229, #1235)
- Fix bug cannot select text of nested HtmlWidget inside list view render mode (#1231)
- Fix white spaces are removed in PRE tag (#1233)

## 0.14.11

- Fix infinite `TextStyle.height` (#1147)
- Deprecate `InheritedProperties.style` getter (#1147)

## 0.14.10+1

- Fix default border color to match text color (#1123)

## 0.14.9

- Fix justify text inside a table (#1120)

## 0.14.7

- Add support for Flutter 3.13.9 (#1093)
- Add support for Flutter 3.16.0 (#1100)
- Fix `onTapUrl` doesn't work for links with `display: block` (#1104)

## 0.14.6

- Add support for `background-image` (#1057, authored by @anttileppa 🎉)
- Add support for `display: flex` (#1021, also by @anttileppa 🔥🔥🔥🔥)
- Add support for background position, repeat & size (#1084)

## 0.14.5+1

- Fix `TABLE` bug that force text to break line (#1078)

## 0.14.5

- Add support for auto margins (#1077)
- BREAKING: Replace `CssLengthBox.getValueLeft` with `.getLeft`
- BREAKING: Replace `CssLengthBox.getValueRight` with `.getRight`

## 0.14.4+1

- Improve table support for wide columns (#1073)
- Make `align=center` work like `CENTER` tag (#1076)
- BREAKING: remove `WidgetFactory.buildDivider` (#1075)

## 0.14.3

- Write migration docs from v0.10 to v0.14 (#1065)
- Fix Flutter badge SVG urls (#1065)
- Fix broken table (#1067)

## 0.14.2

- Add support for `display: table-cell` without row (#905)
- Add supporf for `BuildTree.getNonInherited` and `.setNonInherited` (#948)
- Add support for `InlineCustomWidget` via `customWidgetBuilder` to render simple widget inline (#1056)
- Add support for `BuildOp.inline` to render complicated widget inline (#1056)
- Fix incorrect cursor inside a `SelectionArea` (#902)
- Fix border radius does not clip contents (#903)
- Fix anchor doesn't work with `baseUrl` specified (#904)
- Fix padding is ignored on empty P tag (#906)
- Fix `border-radius` error if border is not uniform (#910)
- Fix inline `white-space: nowrap` (#944)
- Fix `TR` background color doesn't fill the whole row by #1049
- MIGRATE: Replace `WidgetPlaceholder.generator` with `.debugLabel` (#619)
- MIGRATE: Replace `WidgetFactory.gestureTapCallback` with `.buildGestureRecognizer` (#732)
- MIGRATE: Replace `RebuildTriggers` with `List`
- MIGRATE: Replace `BuildBit.detach`, `.insertAfter` and `.insertBefore` with returning a new tree in `BuildOp.onParsed` (#732)
- BREAKING: Remove `HtmlWidget.webViewXxx` properties #615
- BREAKING: Remove support for `box-sizing` (#903)
- BREAKING: Remove `WidgetPlaceholder.autoUnwrap` (#906)
- BREAKING: `.getDependency<MediaQueryData>()` no longer works (#911)
- BREAKING: Append `defaultStyles` instead of prepend (#1055)
- BREAKING: Change default alignment of inline widget from `bottom` to `baseline` (#1056)

See migration document: https://github.com/daohoangson/flutter_widget_from_html/blob/master/docs/migration.md

## 0.10.6

- Fix border 0 is still being rendered (#1045)

## 0.10.5

- Replace the deprecated `DecoderCallback` in tests (#1014)
- Assume HTTPS for protocol relative URL without base (#1016)
- Add screenshots, funding and topics to pubspec files (#1010)

## 0.10.4

- Add support for Flutter 3.13 (#995)
- Remove package `fwfh_text_style` (#1009)

## 0.10.3

- Fix `border-radius` being overwritten by `border` (#966)

## 0.10.2

- Fix 100% width TD in recursive TABLEs (#952)

## 0.10.1

- Add support for Flutter 3.10 (#889)
- Apply OpenSSF Scorecard (#888)

## 0.10.0

- Add support for Flutter 3.7 (#861)

## 0.9.1

- Adjust text-decoration-line cascading logic (#843)
- Try catch possible errors during table layout (#846)
- Add support for `list-style-type: none` (#847)
- Adjust sizing logic for IMG tag (#854)
- Redistribute table column width to avoid overflow (#856)

## 0.9.0+2

- Change column width calculation logic (#747)

## 0.9.0+1

- Fix context usage across async gaps (#835)

## 0.9.0

- Requires Flutter 3.3 (#821)
- Add support for `SelectionArea` (#821)

## 0.8.5+3

- Fix min constraints being 100% (#761)

## 0.8.5+2

- Catch error when building synchronously (#760)

## 0.8.5+1

- Fix percentage value bug (#712, authored by @equweiyu)
- Fix incorrect scrollable state (#728)

## 0.8.4

- Add support for rtl in `HtmlTable` (#681)
- Improve parser for `border` inline style (#685, authored by @EA-YOUHOU)
- Remove decoration when href is missing (#678, authored by @EA-YOUHOU)
- Fix background color being rendered twice (#691)
- Fix error on `TextStyle.merge` (#680, #693)

## 0.8.3+1

- Expose `BuildMetadata.maxLines` and `.overflow`

## 0.8.3

- Add support for Flutter@2.8 (#655)
- New package: `fwfh_text_style` (#628)
- Allow `HtmlWidget.textStyle` to be null (#632)
- Fix detached sub-tree still being built (#650)
- Fix bug text-align with padding (#651)
- Fix anchor being stuck (#659)

## 0.8.2

- Optimize `HtmlListMarker` (#623)
- Fix leading and trailing whitespace within `PRE` being trimmed (#624)

## 0.8.1

- Mark enhanced `HtmlWidget.webViewXxx` properties as deprecated (#614)
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

- Restore `computeLineMetrics` usage in Flutter web. (#561)

## 0.6.1+4

- Improve whitespace handling (#551)

## 0.6.1+3

- Fix bug padding+background+h2 (#523)
- Fix `min-width` being ignored (#544)

## 0.6.1+1

- Fix negative margin/padding throwing exception (#510)

## 0.6.1

- Add support for white-space inline style (#483)
- Change onTapUrl signature to accept a returning value (#499)
- Fix `_ListMarkerRenderObject` invalid size
- Fix anchor bugs (#485, #491, #493 and #500)
- Fix TR display: none is still being rendered (#489)
- Fix empty TD being skipped -> incorrect table layout (#503)

## 0.6.0

- Flutter 2 🚀
- Use csslib to parse inline style (#379)
- Implement `computeDryLayout` (#411)
- Migrate to null safety (#436, authored by @miDeb)
- Add support for anchor (#447)
- Dispose recognizer properly (#466)

## 0.5.2+1

- [CanvasKit] Add workaround for unimplemented `computeLineMetrics` (#441)

## 0.5.2

- Add support for TABLE attribute `cellpadding` (#365)
- Add support for table cell attributes `colspan`, `rowspan`, `valign` (#365)
- Add support for `HtmlWidget.onTapImage` callback (#398)
- Add support for file:// images (#432)
- Allow getting parsed inline styles from `dom.Element` directly (#367)
- Improve support for inline styles border, border-collapse and box-sizing (#365)
- Fix line metrics are unavailable on Flutter web (#383)
- Fix IMG tag with dimensions being stretched (#429)

## 0.5.1+4

- Improve RUBY baseline (#362)
- Fix `CssBlock` loosing stretched width on render object updated (#360)
- Fix nested sizing / text-align / vertical-align (#361)

## 0.5.1+3

- Fix LI marker position on non-default line height

## 0.5.1+2

- Fix bug `null` access (authored by @sweatfryash)
- Fix bug customWidgetBuilder does not work for TABLE (#353)

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

## 0.5.0+6

- Stop using singleton WidgetFactory by default

## 0.5.0+5

- Use Stack.clipBehavior instead of .overflow (#321, authored by @bahador)

## 0.5.0+3

This is a big release with lots of improvements under the hood. If you don't extends `WidgetFactory` yourself then there are only two changes that may affect your app:

- `customStylesBuilder` returns `Map` instead of `List`
- `onTapUrl` is called for incomplete URL

Other changes:

- Restore sizing support (#248)
- Expand support for `text-align` with end/start/-moz-center/-webkit-center (#305)
- Update UL bullet for correctness (#306)
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

- Add support for inline style sizing (#206): `width`, `height`, `max-width`, `max-height`, `min-width` and `min-height`
- Add support for inline style `text-overflow` (#204)
- Bug fixes

## 0.4.1

- BREAKING: Remove `TextStyleBuilders.recognizer` (#168)
- BREAKING: Remove `lazySet` method (#169)
- BREAKING: Remove `HtmlConfig` and change `factoryBuilder` method signature (#173)
- BREAKING: Remove `bodyPadding`
- BREAKING: Replace `builderCallback` with `customStylesBuilder` and `customWidgetBuilder` (#169)
- Add support for tag RUBY (#144)
- Add support for attribute `align` (#153)
- Add support for async build (#154)
- Add support for inline style `padding` (#160)
- Add support for multiple font families (#172)
- Add support for `line-height` (#193)
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

## 0.3.2+1

- Fix IMG wrong size when device has scaled text (#127)

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

## 0.2.1+1

- Merge `textStyle` with default for easy usage (#45)
- Fix bug in whitespace handling (#44)

## 0.2.1

- Render IMG inline whenever possible
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
- Simplify config for easy usage and customization
- Fix bug using int.parse (#34)

## 0.1.5

- Fix margin with partial invalid values (#21)

## 0.1.4

- Update dependencies (#12)
- Fix layout rebuild loop because of `Column`'s `UniqueKey` (#19)

## 0.1.3

- Fix bug stylings got lost during text rendering (#10)

## 0.1.2

- Fix bug rendering overlapping elements with styling (#11)
- Expand CSS color hex values support

## 0.1.1

- Bug fixes
- Add support for BuildOp, making it easier to render new html tags
- Add support for margin inline styling

## 0.0.1

- First release
