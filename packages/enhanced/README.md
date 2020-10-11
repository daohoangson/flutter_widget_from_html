# Flutter Widget from HTML

![Flutter](https://github.com/daohoangson/flutter_widget_from_html/workflows/Flutter/badge.svg)
[![codecov](https://codecov.io/gh/daohoangson/flutter_widget_from_html/branch/master/graph/badge.svg)](https://codecov.io/gh/daohoangson/flutter_widget_from_html)
[![Pub](https://img.shields.io/pub/v/flutter_widget_from_html.svg)](https://pub.dev/packages/flutter_widget_from_html)

A Flutter package for building Flutter widget tree from HTML with support for IFRAME, VIDEO and 70+ other tags.

| [Live demo](https://html-widget-demo.now.sh/#/helloworld)                                                                     |                                                                                                                               |                                                                                                                               |
| ----------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| ![](https://raw.githubusercontent.com/daohoangson/flutter_widget_from_html/master/demo_app/screenshots/HelloWorldScreen1.jpg) | ![](https://raw.githubusercontent.com/daohoangson/flutter_widget_from_html/master/demo_app/screenshots/HelloWorldScreen2.gif) | ![](https://raw.githubusercontent.com/daohoangson/flutter_widget_from_html/master/demo_app/screenshots/HelloWorldScreen3.gif) |

## Getting Started

Add this to your app's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_widget_from_html: ^0.5.1+1
```

## Usage

Then you have to import the package with:

```dart
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
```

And use `HtmlWidget` where appropriate:

```dart
HtmlWidget(
  // the first parameter (`html`) is required
  '''
  <h3>Heading</h3>
  <p>
    A paragraph with <strong>strong</strong>, <em>emphasized</em>
    and <span style="color: red">colored</span> text.
  </p>
  <!-- anything goes here -->
  ''',

  // all other parameters are optional, a few notable params:

  // specify custom styling for an element
  // see supported inline styling below
  customStylesBuilder: (element) {
    if (element.classes.contains('foo')) {
      return {'color': 'red'};
    }

    return null;
  },

  // render a custom widget
  customWidgetBuilder: (element) {
    if (element.attributes['foo'] == 'bar') {
      return FooBarWidget();
    }

    return null;
  },

  // set the default styling for text
  textStyle: TextStyle(fontSize: 14),

  // By default, `webView` is turned off because additional config
  // must be done for `PlatformView` to work on iOS.
  // https://pub.dev/packages/webview_flutter#ios
  // Make sure you have it configured before using.
  webView: true,
),
```

## Features

### HTML tags

Below tags are the ones that have special meaning / styling, all other tags will be parsed as text.
[Compare between Flutter rendering and browser's.](https://html-widget-demo.now.sh/supported/tags.html)

- A: underline, theme accent color
  - Scroll to anchor
  - Launch URL via [url_launcher](https://pub.dev/packages/url_launcher) with base URL resolver
- H1/H2/H3/H4/H5/H6
- IFRAME via [webview_flutter](https://pub.dev/packages/webview_flutter)
- IMG with support for asset (`asset://`), data uri and network image via [cached_network_image](https://pub.dev/packages/cached_network_image). Additional .svg file support via [flutter_svg](https://pub.dev/packages/flutter_svg).
- LI/OL/UL with support for:
  - Attributes: `type`, `start`, `reversed`
  - Inline style `list-style-type` values: `lower-alpha`, `upper-alpha`, `lower-latin`, `upper-latin`, `circle`, `decimal`, `disc`, `lower-roman`, `upper-roman`, `square`
- TABLE/CAPTION/THEAD/TBODY/TFOOT/TR/TD/TH with support for:
  - TABLE attributes (`border`, `cellpadding`) and inline style (`border`)
  - TD/TH attributes `colspan`, `rowspan` via [flutter_layout_grid](https://pub.dev/packages/flutter_layout_grid)
- SVG via [flutter_svg](https://pub.dev/packages/flutter_svg)
- VIDEO via [chewie](https://pub.dev/packages/chewie)
- ABBR, ACRONYM, ADDRESS, ARTICLE, ASIDE, B, BIG, BLOCKQUOTE, BR, CENTER, CITE, CODE,
  DD, DEL, DFN, DIV, DL, DT, EM, FIGCAPTION, FIGURE, FONT, FOOTER, HEADER, HR, I, INS,
  KBD, MAIN, NAV, P, PRE, Q, RP, RT, RUBY, S, SAMP, SECTION, STRIKE, STRONG, SUB, SUP, TT, U, VAR
- Everything with screenshot: https://html-widget-demo.now.sh/supported/tags.html

These tags and their contents will be ignored:

- SCRIPT
- STYLE

### Attributes

- align: center/end/justify/left/right/start/-moz-center/-webkit-center
- dir: auto/ltr/rtl

### Inline stylings

- background (color only), background-color: hex values, `rgb()`, `hsl()` or named colors
- border-top, border-bottom: overline/underline with support for dashed/dotted/double/solid style
- color: hex values, `rgb()`, `hsl()` or named colors
- direction (similar to `dir` attribute)
- font-family
- font-size: absolute (e.g. `xx-large`), relative (`larger`, `smaller`) or values in `em`, `%`, `pt` and `px`
- font-style: italic/normal
- font-weight: bold/normal/100..900
- line-height: `normal`, number or values in `em`, `%`, `pt` and `px`
- margin and margin-xxx: values in `em`, `pt` and `px`
- padding and padding-xxx: values in `em`, `pt` and `px`
- vertical-align: baseline/top/bottom/middle/sub/super
- text-align (similar to `align` attribute)
- text-decoration: line-through/none/overline/underline
- text-overflow: clip/ellipsis. Note: `text-overflow: ellipsis` should be used in conjuntion with `max-lines` or `-webkit-line-clamp` for better result.
- Sizing (width, height, max-xxx, min-xxx): `auto` or values in `em`, `%`, `pt` and `px`

## Extensibility

See [flutter_widget_from_html_core](https://pub.dev/packages/flutter_widget_from_html_core#extensibility) for details.
