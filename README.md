# Flutter Widget from HTML

[![CircleCI](https://circleci.com/gh/daohoangson/flutter_widget_from_html.svg?style=svg)](https://circleci.com/gh/daohoangson/flutter_widget_from_html)
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
      appBar: AppBar(
        title: Text('HelloWorldScreen'),
      ),
      body: ListView(
        children: <Widget>[
          HtmlWidget("""<h1>Heading 1</h1>
<h2>Heading 2</h2>
<h3>Heading 3</h3>
<h4>Heading 4</h4>
<h5>Heading 5</h5>
<h6>Heading 6</h6>
<p>A paragraph with <strong>strong</strong> <em>emphasized</em> text.</p>
<p>And of course, cat image: <img src="https://media.giphy.com/media/6VoDJzfRjJNbG/giphy-downsized.gif" /></p>
<div style="text-align: center">Source: <a href="https://gph.is/QFgPA0">https://gph.is/QFgPA0</a></div>
"""),
        ],
      ));
}
```

![](packages/example/screenshots/HelloWorldScreen.jpg?raw=true)

## Features

### HTML tags

Below tags are the ones that have special meaning / styling, all other tags will be parsed as text.
All texts will be rendered with padding (`Config.textPadding`).

- A: underline with theme accent color, launch url via [`url_launcher`](https://pub.dartlang.org/packages/url_launcher), support base url resolver
- B
- BR
- CODE
- DIV
- EM
- H1/H2/H3/H4/H5/H6
- I
- IFRAME via [`WebView`](https://pub.dartlang.org/packages/webview_flutter). Available configurations:
  - `Config.webView`, default=false
  - `Config.webViewJs`, default=true
  - `Config.webViewPadding`
  - To render IFRAME as web view: set `webView=true` in config and [setup iOS project manually](https://pub.dartlang.org/packages/webview_flutter#ios).
  - Web view will be rendered in a 16:9 box unless `width` and `height` attributes are specified in the IFRAME.
- IMG via [`CachedNetworkImage`](https://pub.dartlang.org/packages/cached_network_image) with padding (`Config.imagePadding`), support base url resolver
- LI/OL/UL with marker and padding (`Config.listBullet`, `Config.listMarkerPaddingTop` and `Config.listMarkerWidth`)
- P
- PRE
- STRONG
- U

These tags and their contents will be ignored:

- SCRIPT
- STYLE

### Inline stylings

- color: hex values only (`#F00`, `#0F08`, `#00FF00` or `#00FF0080`)
- font-family
- font-size (value in px only)
- font-style: italic/normal
- font-weight: bold/normal/100..900
- margin, margin-top, margin-right, margin-bottom, margin-left (values in px only)
- text-align: center/justify/left/right
- text-decoration: line-through/none/overline/underline

## Extensibility

See [flutter_widget_from_html_core](https://pub.dartlang.org/packages/flutter_widget_from_html_core#extensibility) for details.
