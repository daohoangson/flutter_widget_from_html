# Flutter Widget from HTML

[![CirrusCI](https://api.cirrus-ci.com/github/daohoangson/flutter_widget_from_html.svg)](https://cirrus-ci.com/github/daohoangson/flutter_widget_from_html)
[![codecov](https://codecov.io/gh/daohoangson/flutter_widget_from_html/branch/master/graph/badge.svg)](https://codecov.io/gh/daohoangson/flutter_widget_from_html)
[![Pub](https://img.shields.io/pub/v/flutter_widget_from_html.svg)](https://pub.dartlang.org/packages/flutter_widget_from_html)

A Flutter plugin for building Flutter-widget tree from html.

This package extends the [`flutter_widget_from_html_core`](https://pub.dartlang.org/packages/flutter_widget_from_html_core) package with extra functionalities by using external depedencies like `cached_network_image` or `url_launcher`. It should be good enough as a quick starting point but you can always use the `core` directly if you dislike the dependencies.

## Usage

To use this plugin, add `flutter_widget_from_html` as a [dependency in your pubspec.yaml file](https://flutter.io/using-packages/).

See the [Example app](https://github.com/daohoangson/flutter_widget_from_html/tree/master/packages/example) for inspiration.

## Example

Note: `HtmlWidget.config` is optional, see dartdoc for all available configuration keys and their default values.

```dart
class HelloWorldScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text('HelloWorldScreen')),
        body: HtmlWidget(
          """<h1>Heading</h1>
<p>A paragraph with <strong>strong</strong> <em>emphasized</em> text.</p>
<ol>
  <li>List item number one</li>
  <li>
    Two
    <ul>
      <li>2.1 (nested)</li>
      <li>2.2</li>
    </ul>
  </li>
  <li>Three</li>
</ol>
<p>And YouTube video!</p>
<iframe src="https://www.youtube.com/embed/jNQXAC9IVRw" width="560" height="315"></iframe>
""",
          config: Config(webView: true),
        ),
      );
}
```

![](packages/example/screenshots/HelloWorldScreen.png?raw=true)

## Features

### HTML tags

Below tags are the ones that have special meaning / styling, all other tags will be parsed as text.
All texts will be rendered with padding (`Config.textPadding`).

- A: underline with theme accent color, launch url via [`url_launcher`](https://pub.dartlang.org/packages/url_launcher), support base url resolver. Override `WidgetFactory.buildGestureTapCallbackForUrl` if you want to do something else onTap.
- H1/H2/H3/H4/H5/H6
- IFRAME via [`WebView`](https://pub.dartlang.org/packages/webview_flutter). Available configurations:
  - `Config.webView`, default=false
  - `Config.webViewJs`, default=true
  - `Config.webViewPadding`
  - To render IFRAME as web view: set `webView=true` in config and [setup iOS project manually](https://pub.dartlang.org/packages/webview_flutter#ios).
  - If the IFRAME has no `width` and `height` attributes, the web view will be rendered initially in a 16:9 box and automatically resize itself afterwards.
- IMG via [`CachedNetworkImage`](https://pub.dartlang.org/packages/cached_network_image) with padding (`Config.imagePadding`), support base url resolver
- LI/OL/UL with marker and padding (`Config.listBullet`, `Config.listMarkerPaddingTop` and `Config.listMarkerWidth`)
- TABLE/CAPTION/THEAD/TBODY/TFOOT/TR/TD/TH with support for:
  - `<table border="1">`
  - `<table style="border: 1px solid #f00">`
- ABBR, ACRONYM, ADDRESS, ARTICLE, ASIDE, B, BIG, BLOCKQUOTE, BR, CENTER, CITE, CODE,
  DD, DEL, DFN, DIV, DL, DT, EM, FIGCAPTION, FIGURE, FOOTER, HEADER, HR, I, INS,
  KBD, MAIN, NAV, P, PRE, Q, S, SAMP, SECTION, STRIKE, STRONG, TT, U, VAR

These tags and their contents will be ignored:

- SCRIPT
- STYLE

### Inline stylings

- border-top, border-bottom: overline/underline with support for dashed/dotted/double/solid style
- color: hex values only (`#F00`, `#0F08`, `#00FF00` or `#00FF0080`)
- font-family
- font-size: absolute (e.g. `xx-large`), relative (`larger`, `smaller`) and value in em/px
- font-style: italic/normal
- font-weight: bold/normal/100..900
- margin, margin-top, margin-right, margin-bottom, margin-left (values in px only)
- text-align: center/justify/left/right
- text-decoration: line-through/none/overline/underline

## Extensibility

See [flutter_widget_from_html_core](https://pub.dartlang.org/packages/flutter_widget_from_html_core#extensibility) for details.
