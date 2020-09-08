## 0.5.0+2

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
