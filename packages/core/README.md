# Flutter Widget from HTML (core)

![Flutter](https://github.com/daohoangson/flutter_widget_from_html/workflows/Flutter/badge.svg)
[![codecov](https://codecov.io/gh/daohoangson/flutter_widget_from_html/branch/master/graph/badge.svg)](https://codecov.io/gh/daohoangson/flutter_widget_from_html)
[![Pub](https://img.shields.io/pub/v/flutter_widget_from_html_core.svg)](https://pub.dev/packages/flutter_widget_from_html_core)

A Flutter package for building Flutter widget tree from HTML (supports most popular tags and stylings).

This `core` package implements html parsing and widget building logic so it's easy to extend and fit your app's use case. It tries to render an optimal tree: use `RichText` with specific `TextStyle`, merge spans together, show images in `AspectRatio`, etc.

If this is your first time here, consider using the [`flutter_widget_from_html`](https://pub.dev/packages/flutter_widget_from_html) package as a quick starting point.

## Usage

To use this package, add `flutter_widget_from_html_core` as a [dependency in your pubspec.yaml file](https://flutter.io/using-packages/).

See the [Demo app](https://github.com/daohoangson/flutter_widget_from_html/tree/master/demo_app) for inspiration.

### Example

```dart
const kHtml = '''<h1>Heading 1</h1>
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
''';

class HelloWorldCoreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('HelloWorldCoreScreen'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: HtmlWidget(
            kHtml,
            onTapUrl: (url) => showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text('onTapUrl'),
                content: Text(url),
              ),
            ),
          ),
        ),
      );
}

void main() => runApp(WidgetsApp(home: HelloWorldCoreScreen()));
```

<img src="../../demo_app/screenshots/HelloWorldCoreScreen.gif?raw=true" width="300" />

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
  - TABLE attributes (`border`, `cellpadding`) and inline style (`border`)
  - TD/TH attributes `colspan`, `rowspan` are parsed but ignored during rendering, use [`flutter_widget_from_html`](https://pub.dev/packages/flutter_widget_from_html) if you need them
- ABBR, ACRONYM, ADDRESS, ARTICLE, ASIDE, B, BIG, BLOCKQUOTE, BR, CENTER, CITE, CODE,
  DD, DEL, DFN, DIV, DL, DT, EM, FIGCAPTION, FIGURE, FONT, FOOTER, HEADER, HR, I, IMG, INS,
  KBD, MAIN, NAV, P, PRE, Q, RP, RT, RUBY, S, SAMP, SECTION, STRIKE, STRONG, SUB, SUP, TT, U, VAR

However, these tags and their contents will be ignored:

- IFRAME (use [`flutter_widget_from_html`](https://pub.dev/packages/flutter_widget_from_html) for web view support)
- SCRIPT
- STYLE
- SVG (use [`flutter_widget_from_html`](https://pub.dev/packages/flutter_widget_from_html) for SVG support)

### Attributes

- dir: `auto`, `ltr` and `rtl`

### Inline stylings

- border-top, border-bottom: overline/underline with support for dashed/dotted/double/solid style
- color: hex values, `rgb()`, `hsl()` or named colors
- direction (similar to `dir` attribute)
- font-family
- font-size: absolute (e.g. `xx-large`), relative (`larger`, `smaller`) and values (in `em`, `%` and `px`)
- font-style: italic/normal
- font-weight: bold/normal/100..900
- line-height: number, values (in `em`, `%` and `px`) or `normal`
- margin and margin-xxx (values in `px`, `em`)
- padding and padding-xxx (values in `px`, `em`)
- vertical-align: baseline/top/bottom/middle/sub/super
- text-align: center/justify/left/right
- text-decoration: line-through/none/overline/underline
- text-overflow: clip/ellipsis. Note: `text-overflow: ellipsis` should be used in conjuntion with `max-lines` or `-webkit-line-clamp` for better result.
- Sizing (width & height, max-xxx, min-xxx) with values in `px`, `em`

## Extensibility

As previously mentioned, this package focuses on the core parsing-building routine with lots of tests to make sure it works correctly. If the [`flutter_widget_from_html`](https://pub.dev/packages/flutter_widget_from_html) package does not suite your need or you don't like any of the dependencies included in that package, it's time to extend `flutter_widget_from_html_core`.

Here is how it works:

1. `HtmlWidget` parses input html into dom nodes
2. `HtmlBuilder` loops through each node, looking for `NodeMetadata` (text size, styling, hyperlink or image source, etc.)
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
      return pieces..first?.text?.addText(text);
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

![](../../demo_app/screenshots/SmilieScreen.png?raw=true)
