# Flutter Widget from HTML (core)

[![CirrusCI](https://api.cirrus-ci.com/github/daohoangson/flutter_widget_from_html.svg)](https://cirrus-ci.com/github/daohoangson/flutter_widget_from_html)
[![codecov](https://codecov.io/gh/daohoangson/flutter_widget_from_html/branch/master/graph/badge.svg)](https://codecov.io/gh/daohoangson/flutter_widget_from_html)
[![Pub](https://img.shields.io/pub/v/flutter_widget_from_html_core.svg)](https://pub.dev/packages/flutter_widget_from_html_core)

A Flutter plugin for building Flutter-widget tree from html.

This `core` package implements html parsing and widget building logic so it's easy to extend and fit your app's use case. It tries to render an optimal tree: use `Text` instead of `RichText` as much as possible, merge text spans together, show images in `AspectRatio`, etc.

If this is your first time here, consider using the [`flutter_widget_from_html`](https://pub.dev/packages/flutter_widget_from_html) package as a quick starting point.

## Usage

To use this plugin, add `flutter_widget_from_html_core` as a [dependency in your pubspec.yaml file](https://flutter.io/using-packages/).

See the [Example app](https://github.com/daohoangson/flutter_widget_from_html/tree/master/packages/example) for inspiration.

### Example

```dart
const kHtml = """<h1>Heading 1</h1>
<h2>Heading 2</h2>
<h3>Heading 3</h3>
<h4>Heading 4</h4>
<h5>Heading 5</h5>
<h6>Heading 6</h6>
<p>A paragraph with <strong>strong</strong> <em>emphasized</em> text.</p>

<p>And of course, cat image:</p>
<figure>
  <img src="https://media.giphy.com/media/6VoDJzfRjJNbG/giphy-downsized.gif" width="250" height="171" />
  <figcaption>Source: <a href="https://gph.is/QFgPA0">https://gph.is/QFgPA0</a></figcaption>
</figure>
""";

class HelloWorldCoreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('HelloWorldCoreScreen'),
        ),
        body: HtmlWidget(
          kHtml,
          onTapUrl: (url) => showDialog(
                context: context,
                builder: (_) => AlertDialog(
                      title: Text('onTapUrl'),
                      content: Text(url),
                    ),
              ),
        ),
      );
}
```

![](../../packages/example/screenshots/HelloWorldCoreScreen.jpg?raw=true)

## Features

### HTML tags

Below tags are the ones that have special meaning / styling, all other tags will be parsed as text.

- A: underline, blue color, no default onTap action (use [`flutter_widget_from_html`](https://pub.dev/packages/flutter_widget_from_html) for that)
- H1/H2/H3/H4/H5/H6
- IMG with support for asset (`asset://`), data uri and network image without caching (use [`flutter_widget_from_html`](https://pub.dev/packages/flutter_widget_from_html) for that)
- LI/OL/UL with support for:
  - Attributes: `type`, `start`, `reversed`
  - Inline style `list-style-type` values: `lower-alpha`, `upper-alpha`, `lower-latin`, `upper-latin`, `circle`, `decimal`, `disc`, `lower-roman`, `upper-roman`, `square`
- TABLE/CAPTION/THEAD/TBODY/TFOOT/TR/TD/TH with support for:
  - Attribute: `<table border="1">`
  - Inline style: `<table style="border: 1px solid #f00">`
- ABBR, ACRONYM, ADDRESS, ARTICLE, ASIDE, B, BIG, BLOCKQUOTE, BR, CENTER, CITE, CODE,
  DD, DEL, DFN, DIV, DL, DT, EM, FIGCAPTION, FIGURE, FONT, FOOTER, HEADER, HR, I, IMG, INS,
  KBD, MAIN, NAV, P, PRE, Q, S, SAMP, SECTION, STRIKE, STRONG, TT, U, VAR

However, these tags and their contents will be ignored:

- IFRAME (use [`flutter_widget_from_html`](https://pub.dev/packages/flutter_widget_from_html) for web view support)
- SCRIPT
- STYLE

### Inline stylings

- border-top, border-bottom: overline/underline with support for dashed/dotted/double/solid style
- color: hex values only (`#F00`, `#0F08`, `#00FF00` or `#00FF0080`)
- font-family
- font-size: absolute (e.g. `xx-large`), relative (`larger`, `smaller`) and value in em/px
- font-style: italic/normal
- font-weight: bold/normal/100..900
- margin and margin-xxx (values in px only)
- text-align: center/justify/left/right
- text-decoration: line-through/none/overline/underline

## Extensibility

As previously mentioned, this package focuses on the core parsing-building routine with lots of tests to make sure it works correctly. If the [`flutter_widget_from_html`](https://pub.dev/packages/flutter_widget_from_html) package does not suite your need or you don't like any of the dependencies included in that package, it's time to extend `flutter_widget_from_html_core`.

Here is how it works:

1. `HtmlWidget` parses input html into dom nodes
2. `Builder` loops through each node, looking for `NodeMetadata` (text size, styling, hyperlink or image source, etc.)
3. Use the metadata to build widget via `WidgetFactory`

If you want to, you can change the way metadata is collected (in step 2) and build widget however you like (in step 3) by extending the `WidgetFactory` and give it to `HtmlWidget`. The example below replace smilie inline image with an emoji:

```dart
const kHtml = """
<p>Hello <img class="smilie smilie-1" alt=":)" src="http://domain.com/sprites.png" />!</p>
<p>How are you <img class="smilie smilie-2" alt=":P" src="http://domain.com/sprites.png" />?
""";

const kSmilies = {':)': '🙂'};

class SmilieScreen extends StatelessWidget {
  final smilieOp = BuildOp(
    onPieces: (meta, pieces) {
      final alt = meta.domElement.attributes['alt'];
      final text = kSmilies.containsKey(alt) ? kSmilies[alt] : alt;
      return pieces..first?.block?.addText(text);
    },
  );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('SmilieScreen'),
        ),
        body: HtmlWidget(
          kHtml,
          builderCallback: (meta, e) => e.classes.contains('smilie')
              ? lazySet(null, buildOp: smilieOp)
              : meta,
        ),
      );
}
```

![](../../packages/example/screenshots/SmilieScreen.png?raw=true)
