# Flutter Widget from HTML

![Flutter](https://github.com/daohoangson/flutter_widget_from_html/workflows/Flutter/badge.svg)
![Android Test](https://github.com/daohoangson/flutter_widget_from_html/workflows/Android%20Test/badge.svg)
[![codecov](https://codecov.io/gh/daohoangson/flutter_widget_from_html/branch/master/graph/badge.svg)](https://codecov.io/gh/daohoangson/flutter_widget_from_html)
[![Pub](https://img.shields.io/pub/v/flutter_widget_from_html.svg)](https://pub.dev/packages/flutter_widget_from_html)

A Flutter package for building Flutter widget tree from HTML with support for IFRAME, VIDEO and many other tags.

This package extends the [`flutter_widget_from_html_core`](https://pub.dev/packages/flutter_widget_from_html_core) package with extra functionalities by using external depedencies like `cached_network_image` or `url_launcher`. It should be good enough as a quick starting point but you can always use the `core` directly if you dislike the dependencies.

## Usage

To use this package, add `flutter_widget_from_html` as a [dependency in your pubspec.yaml file](https://flutter.io/using-packages/).

See the [Demo app](https://github.com/daohoangson/flutter_widget_from_html/tree/master/demo_app) for inspiration.

## Example

```dart
const kHtml = '''
<h3>Heading</h3>
<p>
  A paragraph with <strong>strong</strong>, <em>emphasized</em>
  and <span style="color: red">colored</span> text.
  With an inline <a href="https://flutter.dev">Flutter</a> logo,
  like this: <img src="https://github.com/daohoangson/flutter_widget_from_html/raw/master/demo_app/logos/android.png" style="width: 1em" />.
</p>

<ol>
  <li>List item number one</li>
  <li>
    Two
    <ul>
      <li>2.1</li>
      <li>2.2</li>
    </ul>
  </li>
</ol>

<p>&lt;IFRAME&gt; of YouTube:</p>
<iframe src="https://www.youtube.com/embed/jNQXAC9IVRw" width="560" height="315"></iframe>
<br />

<table border="1" cellpadding="8">
  <tr><td colspan="2">&lt;TABLE&gt; colspan=2</td></tr>
  <tr>
    <td rowspan="3">rowspan=3</td>
    <td>&lt;SUB&gt; C<sub>8</sub>H<sub>10</sub>N<sub>4</sub>O<sub>2</sub></td>
  </tr>
  <tr><td>&lt;SUP&gt; <var>a<sup>2</sup></var> + <var>b<sup>2</sup></var> = <var>c<sup>2</sup></var></td></tr>
  <tr><td>&lt;RUBY&gt; <ruby>明日 <rp>(</rp><rt>Ashita</rt><rp>)</rp></ruby></td></tr>

</table>

''';

class HelloWorldScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text('HelloWorldScreen')),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: HtmlWidget(kHtml, webView: true),
          ),
        ),
      );
}

void main() => runApp(MaterialApp(home: HelloWorldScreen()));
```

<img src="../../demo_app/screenshots/HelloWorldScreen.png?raw=true" width="300" />

## Features

### HTML tags

Below tags are the ones that have special meaning / styling, all other tags will be parsed as text.

- A: underline, theme accent color, launch url via [`url_launcher`](https://pub.dev/packages/url_launcher), support base url resolver.
- H1/H2/H3/H4/H5/H6
- IFRAME via [`WebView`](https://pub.dev/packages/webview_flutter). Available configurations:
  - `.webView`, default=false
  - `.webViewJs`, default=true
  - `.webViewPadding`
  - To render IFRAME as web view: set `webView=true` in config and [setup iOS project manually](https://pub.dev/packages/webview_flutter#ios).
  - If the IFRAME has no `width` and `height` attributes, the web view will be rendered initially in a 16:9 box and automatically resize itself afterwards.
- IMG with support for asset (`asset://`), data uri and network image via [`CachedNetworkImage`](https://pub.dev/packages/cached_network_image). Additional .svg file support via [flutter_svg](https://pub.dev/packages/flutter_svg).
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

These tags and their contents will be ignored:

- SCRIPT
- STYLE

### Attributes

- dir: `auto`, `ltr` and `rtl`

### Inline stylings

- background (color only), background-color: hex values, `rgb()`, `hsl()` or named colors
- border-top, border-bottom: overline/underline with support for dashed/dotted/double/solid style
- color: hex values, `rgb()`, `hsl()` or named colors
- direction (similar to `dir` attribute)
- font-family
- font-size: absolute (e.g. `xx-large`), relative (`larger`, `smaller`) or values in `em`, `%`, `pt` and `px`
- font-style: italic/normal
- font-weight: bold/normal/100..900
- line-height: `normal` number or values in `em`, `%`, `pt` and `px`
- margin and margin-xxx: values in `em`, `pt` and `px`
- padding and padding-xxx: values in `em`, `pt` and `px`
- vertical-align: baseline/top/bottom/middle/sub/super
- text-align: center/end/justify/left/right/start/-moz-center/-webkit-center
- text-decoration: line-through/none/overline/underline
- text-overflow: clip/ellipsis. Note: `text-overflow: ellipsis` should be used in conjuntion with `max-lines` or `-webkit-line-clamp` for better result.
- Sizing (width & height, max-xxx, min-xxx) with values in `em`, `pt` and `px`

## Extensibility

See [flutter_widget_from_html_core](https://pub.dev/packages/flutter_widget_from_html_core#extensibility) for details.
