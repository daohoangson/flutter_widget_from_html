# Flutter Widget from HTML (core)

![Flutter](https://github.com/daohoangson/flutter_widget_from_html/workflows/Flutter/badge.svg)
[![codecov](https://codecov.io/gh/daohoangson/flutter_widget_from_html/branch/master/graph/badge.svg)](https://codecov.io/gh/daohoangson/flutter_widget_from_html)
[![Pub](https://img.shields.io/pub/v/flutter_widget_from_html_core.svg)](https://pub.dev/packages/flutter_widget_from_html_core)
  
Flutter package to render html as widgets that focuses on correctness and extensibility.
Supports [70+ most popular tags](https://demo.fwfh.dev/supported/tags.html).

| [Live demo](https://demo.fwfh.dev/#/helloworldcore)                                                                                                                 |                                                                                                                                                                     |
|---------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| ![](https://raw.githubusercontent.com/daohoangson/flutter_widget_from_html/bd80e2fef38f8d7ed69c388e2b325ea09aa7b817/demo_app/screenshots/HelloWorldCoreScreen1.gif) | ![](https://raw.githubusercontent.com/daohoangson/flutter_widget_from_html/bd80e2fef38f8d7ed69c388e2b325ea09aa7b817/demo_app/screenshots/HelloWorldCoreScreen2.jpg) |

## Getting Started

Add this to your app's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_widget_from_html_core: ^0.8.5
```

## Usage

Then you have to import the package with:

```dart
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
```

And use `HtmlWidget` where appropriate:

```dart
HtmlWidget(
  // the first parameter (`html`) is required
  '''
  <h1>Heading 1</h1>
  <h2>Heading 2</h2>
  <h3>Heading 3</h3>
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

  // these callbacks are called when a complicated element is loading
  // or failed to render allowing the app to render progress indicator
  // and fallback widget
  onErrorBuilder: (context, element, error) => Text('$element error: $error'),
  onLoadingBuilder: (context, element, loadingProgress) => CircularProgressIndicator(),

  // this callback will be triggered when user taps a link
  onTapUrl: (url) => print('tapped $url'),

  // select the render mode for HTML body
  // by default, a simple `Column` is rendered
  // consider using `ListView` or `SliverList` for better performance
  renderMode: RenderMode.column,

  // set the default styling for text
  textStyle: TextStyle(fontSize: 14),
),
```

## Features

### HTML tags

Below tags are the ones that have special meaning / styling, all other tags will be parsed as text.
[Compare between Flutter rendering and browser's.](https://demo.fwfh.dev/supported/tags.html)

- A: underline, theme accent color with scroll to anchor support
- H1/H2/H3/H4/H5/H6
- IMG with support for asset (`asset://`), data uri, local file (`file://`) and network image
- LI/OL/UL with support for:
  - Attributes: `type`, `start`, `reversed`
  - Inline style `list-style-type` values: `lower-alpha`, `upper-alpha`, `lower-latin`, `upper-latin`, `circle`, `decimal`, `disc`, `lower-roman`, `upper-roman`, `square`
- TABLE/CAPTION/THEAD/TBODY/TFOOT/TR/TD/TH with support for:
  - TABLE attributes `border`, `cellpadding`, `cellspacing`
  - TD/TH attributes `colspan`, `rowspan`, `valign`
- ABBR, ACRONYM, ADDRESS, ARTICLE, ASIDE, B, BIG, BLOCKQUOTE, BR, CENTER, CITE, CODE,
  DD, DEL, DETAILS, DFN, DIV, DL, DT, EM, FIGCAPTION, FIGURE, FONT, FOOTER, HEADER, HR, I, INS,
  KBD, MAIN, MARK, NAV, NOSCRIPT, P, PRE, Q, RP, RT, RUBY, S, SAMP, SECTION, SMALL,
  STRIKE, STRONG, STYLE, SUB, SUMMARY, SUP, TT, U, VAR
- Everything with screenshot: https://demo.fwfh.dev/supported/tags.html
- [Try with fwfh.dev](https://try.fwfh.dev)

These tags requires [flutter_widget_from_html](https://pub.dev/packages/flutter_widget_from_html):

- AUDIO
- IFRAME
- SVG
- VIDEO

These tags and their contents will be ignored:

- SCRIPT
- STYLE

### Attributes

- align: center/end/justify/left/right/start/-moz-center/-webkit-center
- dir: auto/ltr/rtl

### Inline stylings

- background: 1 value (color)
  - background-color
- border: 3 values (width style color), 2 values (width style) or 1 value (width)
  - border-top, border-right, border-bottom, border-left
  - border-block-start, border-block-end
  - border-inline-start, border-inline-end
- border-radius: 4, 3, 2 or 1 values with slash support (e.g. `10px / 20px`)
  - border-top-left-radius: 2 values or 1 value in `em`, `pt` and `px`
  - border-top-right-radius: 2 values or 1 value in `em`, `pt` and `px`
  - border-bottom-right-radius: 2 values or 1 value in `em`, `pt` and `px`
  - border-bottom-left-radius: 2 values or 1 value in `em`, `pt` and `px`
- box-sizing: border-box/content-box
- color: hex values, `rgb()`, `hsl()` or named colors
- direction (similar to `dir` attribute)
- font-family
- font-size: absolute (e.g. `xx-large`), relative (`larger`, `smaller`) or values in `em`, `%`, `pt` and `px`
- font-style: italic/normal
- font-weight: bold/normal/100..900
- line-height: `normal`, number or values in `em`, `%`, `pt` and `px`
- margin: 4 values, 2 values or 1 value in `em`, `pt` and `px`
  - margin-top, margin-right, margin-bottom, margin-left
  - margin-block-start, margin-block-end
  - margin-inline-start, margin-inline-end
- padding: 4 values, 2 values or 1 value in `em`, `pt` and `px`
  - padding-top, padding-right, padding-bottom, padding-left
  - padding-block-start, padding-block-end
  - padding-inline-start, padding-inline-end
- vertical-align: baseline/top/bottom/middle/sub/super
- text-align (similar to `align` attribute)
- text-decoration
  - text-decoration-color
  - text-decoration-line: line-through/none/overline/underline
  - text-decoration-style: dotted/dashed/double/solid
  - text-decoration-thickness, text-decoration-width: values in `%` only
- text-overflow: clip/ellipsis. Note: `text-overflow: ellipsis` should be used in conjuntion with `max-lines` or `-webkit-line-clamp` for better result.
- white-space: normal/pre
- Sizing: `auto` or values in `em`, `%`, `pt` and `px`
  - width, max-width, min-width
  - height, max-height, min-height

<a href="https://www.buymeacoffee.com/daohoangson" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" height="41" width="174"></a>

## Extensibility

This package implements widget building logic with high testing coverage to ensure correctness. It tries to render an optimal tree by using `RichText` with specific `TextStyle`, merging text spans together, showing images in sized box, etc. The idea is to build a solid foundation for apps to customize easily. There are two ways to alter the output widget tree.

1. Use callbacks like `customStylesBuilder` or `customWidgetBuilder` for small changes
2. Use a custom `WidgetFactory` for complete control of the rendering process

The enhanced package ([flutter_widget_from_html](https://pub.dev/packages/flutter_widget_from_html)) uses a custom `WidgetFactory` with pre-built mixins for easy usage:

- [fwfh_cached_network_image](https://pub.dev/packages/fwfh_cached_network_image) for optimized image rendering
- [fwfh_chewie](https://pub.dev/packages/fwfh_chewie) for VIDEO support
- [fwfh_just_audio](https://pub.dev/packages/fwfh_just_audio) for AUDIO support
- [fwfh_selectable_text](https://pub.dev/packages/fwfh_selectable_text) for `SelectableText` support
- [fwfh_svg](https://pub.dev/packages/fwfh_svg) for SVG support
- [fwfh_url_launcher](https://pub.dev/packages/fwfh_url_launcher) to launch URLs
- [fwfh_webview](https://pub.dev/packages/fwfh_webview) for IFRAME support

### Callbacks

For cosmetic changes like color, italic, etc., use `customStylesBuilder` to specify inline styles (see supported list above) for each DOM element. Some common conditionals:

- If HTML tag is H1 `element.localName == 'h1'`
- If the element has `foo` CSS class `element.classes.contains('foo')`
- If an attribute has a specific value `element.attributes['x'] == 'y'`

This example changes the color for a CSS class:

<table><tr><td>

```dart
HtmlWidget(
  'Hello <span class="name">World</span>!',
  customStylesBuilder: (element) {
    if (element.classes.contains('name')) {
      return {'color': 'red'};
    }
    return null;
  },
),
```
  
[Try with fwfh.dev](https://try.fwfh.dev/?id=08173c5e5d837293837c383d00f9f792)

</td>
<td>
  <img src="https://raw.githubusercontent.com/daohoangson/flutter_widget_from_html/bd80e2fef38f8d7ed69c388e2b325ea09aa7b817/demo_app/screenshots/CustomStylesBuilderScreen.jpg" width="200" />
</td>
</tr>
</table>

For fairly simple widget, use `customWidgetBuilder`. You will need to handle the DOM element and its children manually.
This example renders a carousel ([live demo](https://demo.fwfh.dev/#/customwidgetbuilder), [try with fwfh.dev](https://try.fwfh.dev/?id=657d84b28eb0352657400160c97d0f9d)):

<img src="https://raw.githubusercontent.com/daohoangson/flutter_widget_from_html/bd80e2fef38f8d7ed69c388e2b325ea09aa7b817/demo_app/screenshots/CustomWidgetBuilderScreen.gif" width="300" />

### Custom `WidgetFactory`

The HTML string is parsed into DOM elements and each element is visited once to collect `BuildMetadata` and prepare `BuildBit`s. See step by step how it works:

| Step |                                                                          | Integration point                                                                                                   |
|------|--------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------|
| 1    | Parse                                                                    | `WidgetFactory.parse(BuildMetadata)`                                                                                |
| 2    | Inform parents if any                                                    | `BuildOp.onChild(BuildMetadata)`                                                                                    |
| 3    | Populate default styling                                                 | `BuildOp.defaultStyles(Element)`                                                                                    |
| 4    | Populate custom styling                                                  | `HtmlWidget.customStylesBuilder`                                                                                    |
| 5    | Parse styling key+value pairs, `parseStyle` may be called multiple times | `WidgetFactory.parseStyle(BuildMetadata, String, String)`, `WidgetFactory.parseStyleDisplay(BuildMetadata, String)` |
| 6    | a. If a custom widget is provided, go to 7                               | `HtmlWidget.customWidgetBuilder`                                                                                    |
|      | b. Loop through children elements to prepare `BuildBit`s                 |                                                                                                                     |
| 7    | Inform build ops                                                         | `BuildOp.onTree(BuildMetadata, BuildTree)`                                                                          |
| 8    | a. If not a block element, go to 10                                      |                                                                                                                     |
|      | b. Build widgets from bits using a `Flattener`                           | `BuildOp.onTreeFlattening(BuildMetadata, BuildTree)`                                                                |
| 9    | Inform build ops                                                         | `BuildOp.onWidgets(BuildMetadata, Iterable<Widget>)`                                                                |
| 10   | The end                                                                  |                                                                                                                     |

Notes:

- Text related styling can be changed with `TextStyleBuilder`, register your callback to be called when the build context is ready.
  - The first parameter is a `TextStyleHtml` which is immutable and is calculated from the root down to each element, the callback must return a new `TextStyleHtml` by calling `copyWith`. It's recommended to return the same object if no change is needed.
  - Optionally, pass any object on registration and your callback will receive it as the second parameter.

```dart
// example 1: simple callback setting accent color from theme
meta.tsb((parent, _) =>
  parent.copyWith(
    style: parent.style.copyWith(
      color: parent.getDependency<ThemeData>().accentColor,
    ),
  ));

// example 2: callback using second param to set height
TextStyleHtml callback(TextStyleHtml parent, double value) =>
  parent.copyWith(height: value)

// example 2 (continue): register with some value
meta.tsb<double>(callback, 2.0);
```

- The root styling can be customized by overriding `WidgetFactory.onRoot(TextStyleBuilder)`
- Other complicated styling are supported via `BuildOp`

```dart
meta.register(BuildOp(
  onTree: (meta, tree) {
    // can be used to change text, inline contents, etc.
    tree.add(...);
  },
  onWidgets: (meta, widgets) {
    // use this to render special widget, wrap children into something else, etc.
    return widgets.map((widget) => ...);
  },
  // depending on the rendering logic, you may need to adjust the execution order to "jump the line"
  priority: 9999,
));
```

- Each metadata may have as many tsb callbacks and build ops as needed.

The example below replaces smilie inline image with an emoji:

<details>

<summary>smilie.dart</summary>

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
    onTree: (meta, tree) {
      final alt = meta.element.attributes['alt'];
      tree.addText(kSmilies[alt] ?? alt);
    },
  );

  @override
  void parse(BuildMetadata meta) {
    final e = meta.element;
    if (e.localName == 'img' &&
        e.classes.contains('smilie') &&
        e.attributes.containsKey('alt')) {
      meta.register(smilieOp);
      return;
    }

    return super.parse(meta);
  }
}
```

</details>

<img src="https://raw.githubusercontent.com/daohoangson/flutter_widget_from_html/bd80e2fef38f8d7ed69c388e2b325ea09aa7b817/demo_app/screenshots/SmilieScreen.jpg" width="300" />
