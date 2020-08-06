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

There are two ways to change the built widget tree.

1. Use callbacks like `customStylesBuilder` or `customWidgetBuilder` for small changes
2. Use a custom `WidgetFactory` for complete control of the rendering process

### Callbacks

For cosmetic changes like color, italic, etc., use `customStylesBuilder` to specify inline styles (see supported list above) for each DOM element. Some common conditionals:

- If HTML tag is H1 `e.localName == 'h1'`
- If the element has `foo` CSS class `e.classes.contains('foo')`
- If an attribute has a specific value `e.attributes['x'] == 'y'`

This example changes the color for a CSS class:

<table><tr><td>

```dart
const kHtml = 'Hello <span class="name">World</span>!';

class CustomStylesBuilderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('CustomStylesBuilderScreen'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: HtmlWidget(
            kHtml,
            customStylesBuilder: (e) =>
                e.classes.contains('name')
                  ? {'color': 'red'}
                  : null,
          ),
        ),
      );
}
```

</td>
<td>
  <img src="../../demo_app/screenshots/CustomStylesBuilderScreen.png?raw=true" width="200" />
</td>
</tr>
</table>

For fairly simple widget, use `customWidgetBuilder`. You will need to handle the DOM element and its children manually. The next example renders a carousel:

```dart
const kHtml = '''
<p>...</p>
<div class="carousel">
  <div class="image">
    <img src="https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba" />
  </div>
  ...
</div>
<p>...</p>
''';

class CustomWidgetBuilderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('CustomStylesBuilderScreen'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: HtmlWidget(
            kHtml,
            customWidgetBuilder: (e) {
              if (!e.classes.contains('carousel')) return null;

              final srcs = <String>[];
              for (final child in e.children) {
                for (final grandChild in child.children) {
                  srcs.add(grandChild.attributes['src']);
                }
              }

              return CarouselSlider(
                options: CarouselOptions(),
                items: srcs.map(_toItem).toList(growable: false),
              );
            },
          ),
        ),
      );

  static Widget _toItem(String src) => Container(
        child: Center(
          child: Image.network(src, fit: BoxFit.cover, width: 1000),
        ),
      );
}
```

<img src="../../demo_app/screenshots/CustomWidgetBuilderScreen.gif?raw=true" width="300" />

### Custom `WidgetFactory`

The HTML string is parsed into DOM elements and each element is visited once to populate a `NodeMetadata` and collect `BuiltPiece`s. See step by step how it works:

| Step | | Integration point |
| --- | --- | --- |
| 1 | Parse the tag and attributes map | `WidgetFactory.parseTag(NodeMetadata, String, Map)` |
| 2 | Inform parents if any | `BuildOp.onChild(NodeMetadata, Element)` |
| 3 | Populate default inline style key+value pairs | `BuildOp.defaultStyles(NodeMetadata, Element)` |
| 4 | `HtmlWidget.customStyleBuilder` / `HtmlWidget.customWidgetBuilder` will be called if configured | |
| 5 | Parse inline style key+value pairs | `WidgetFactory.parseStyle(NodeMetadata, String, String)` |
| 6 | Repeat with children elements to collect `BuiltPiece`s | |
| 7 | Inform build ops | `BuildOp.onPieces(NodeMetadata, Iterable<BuiltPiece>)` |
| 8 | a. If not a block element, go to 10 | |
|   | b. Build widgets from pieces | |
| 9 | Inform build ops | `BuildOp.onWidgets(NodeMetadata, Iterable<Widget>)` |
| 10 | The end | |

Notes:

- Text related styling can be changed with `TextStyleBuilder`, just register your callback and it will be called when the build context is ready.
  - The second parameter is a `TextStyleHtml` which is immutable and is calculated from the root down to your element, your callback must return a `TextStyleHtml` by calling `copyWith` or simply return the parent itself.
  - Optionally, pass any object on registration and your callback will receive it as the third parameter.

```dart
// simple callback: set text color to accent color
meta.tsb((context, parent, _) =>
  parent.copyWith(
    style: parent.style.copyWith(
      color: Theme.of(context).accentColor,
    ),
  ));

// callback using third param: set height to input value
TextStyleHtml callback(BuildContext _, TextStyleHtml parent, double value) =>
  parent.copyWith(height: value)

// register with some value
meta.tsb<bool>(callback, 2);
```

- Other complicated styling are supported via `BuildOp`

```dart
meta.op = BuildOp(
  onPieces: (meta, pieces) => pieces,
  onWidgets: (meta, widgets) => widgets,
  ...,
  priority: 9999,
);
```

- Each metadata can has multiple text style builder callbacks and build ops.
- There are two types of `BuiltPiece`:
  - `BuiltPiece.text()` contains a `TextBits`
  - `BuiltPiece.widgets()` contains widgets
- `TextBits` is a list of `TextBit`, there are four subclasses of `TextBit`:
  - `TextBits` is actually a `TextBit`, that means a `TextBits` can contains multiple sub-`TextBits`
  - `TextData` is a string of text
  - `TextWhitespace` is a whitespace
  - `TextWidget` is an inline widget

The example below replaces smilie inline image with an emoji:

```dart
const kHtml = """
<p>Hello <img class="smilie smilie-1" alt=":)" src="http://domain.com/sprites.png" />!</p>
<p>How are you <img class="smilie smilie-2" alt=":P" src="http://domain.com/sprites.png" />?
""";

const kSmilies = {':)': '🙂'};

class SmilieScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('SmilieScreen'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: HtmlWidget(
            kHtml,
            factoryBuilder: () => _SmiliesWidgetFactory(),
          ),
        ),
      );
}

class _SmiliesWidgetFactory extends WidgetFactory {
  final smilieOp = BuildOp(
    onPieces: (meta, pieces) {
      final alt = meta.domElement.attributes['alt'];
      final text = kSmilies.containsKey(alt) ? kSmilies[alt] : alt;
      return pieces..first?.text?.addText(text);
    },
  );

  @override
  void parseTag(NodeMetadata meta, String tag, Map<dynamic, String> attrs) {
    if (tag == 'img' &&
        attrs.containsKey('alt') &&
        attrs.containsKey('class') &&
        attrs['class'].contains('smilie')) {
      meta.op = smilieOp;
      return;
    }

    return super.parseTag(meta, tag, attrs);
  }
}
```

<img src="../../demo_app/screenshots/SmilieScreen.png?raw=true" width="300" />
