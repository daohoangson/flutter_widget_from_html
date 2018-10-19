# Flutter Widget from HTML (core)

A Flutter plugin for building Flutter-widget tree from html.

This `core` package implements html parsing and widget building logic so it's easy to extend and fit your app's use case. It tries to render an optimal tree: use `Text` instead of `RichText` as much as possible, merge text spans together, show images in `AspectRatio`, etc.

If this is your first time here, consider using the [`flutter_widget_from_html`](https://pub.dartlang.org/packages/flutter_widget_from_html) package as a quick starting point.

## Usage

To use this plugin, add `flutter_widget_from_html_core` as a [dependency in your pubspec.yaml file](https://flutter.io/using-packages/).

### Example

```dart
class HelloWorldScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('HelloWorldScreen'),
        ),
        body: HtmlWidget("""<h1>Heading 1</h1>
<h2>Heading 2</h2>
<h3>Heading 3</h3>
<h4>Heading 4</h4>
<h5>Heading 5</h5>
<h6>Heading 6</h6>
<p>A paragraph with <strong>strong</strong> <em>emphasized</em> text.</p>
<p>And of course, cat image: <img src="https://media.giphy.com/media/6VoDJzfRjJNbG/giphy-downsized.gif" /></p>
<div style="text-align: center">Source: <a href="https://gph.is/QFgPA0">https://gph.is/QFgPA0</a></div>
"""),
      );
}
```

![](../../example/screenshots/core/HelloWorldScreen.jpg?raw=true)

## Features

### HTML tags

Below tags are the ones that have special meaning / styling, all other tag will be parsed as text.

- A: underline without color, no action on tap (use [`flutter_widget_from_html`](https://pub.dartlang.org/packages/flutter_widget_from_html) for that)
- B
- BR
- CODE
- DIV
- EM
- H1/H2/H3/H4/H5/H6
- I
- IMG: no caching, no relative url support (use [`flutter_widget_from_html`](https://pub.dartlang.org/packages/flutter_widget_from_html) for that)
- LI/OL/UL: no marker (use [`flutter_widget_from_html`](https://pub.dartlang.org/packages/flutter_widget_from_html) for that)
- P
- PRE
- STRONG
- U

### Inline stylings

- color: hex code only
- font-family
- font-style: italic/normal
- font-weight: bold/normal/100..900
- text-align: center/justify/left/right
- text-decoration: line-through/none/overline/underline

## Extensibility

As previously mentioned, this package focuses on the core parsing-building routine with lots of tests to make sure it works correctly. If the [`flutter_widget_from_html`](https://pub.dartlang.org/packages/flutter_widget_from_html) package does not suite your need or you don't like any of the dependencies included in that package, it's time to extend `flutter_widget_from_html_core` and make it work for you.

Here is how it works:

1. `HtmlWidget` parses input html into dom nodes
2. `Builder` loops through each node, looking for `NodeMetadata` (text size, styling, hyperlink or image source, etc.)
3. Use the metadata to build widget via `WidgetFactory`

If you want to, you can change the way metadata is collected (in step 2) and build widget however you like (in step 3) by extending the `WidgetFactory` and give it to `HtmlWidget`. The example below replace smilie inline image with an emoji:

```dart
class SmilieScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('SmilieScreen'),
        ),
        body: HtmlWidget(
          '<p>Hello <img class="smilie smilie-1" alt=":)" src="http://domain.com/sprites.png" />!</p>',
          wfBuilder: (context) => SmilieWf(context),
        ),
      );
}

const _kSmilies = {':)': '🙂'};

class SmilieWf extends WidgetFactory {
  SmilieWf(BuildContext context) : super(context);

  @override
  NodeMetadata collectMetadata(dom.Element e) {
    var meta = super.collectMetadata(e);

    if (e.classes.contains('smilie')) {
      meta = lazySet(meta, display: DisplayType.Inline);

      final alt = e.attributes['alt'];
      if (_kSmilies.containsKey(alt)) {
        meta = lazyAddNode(meta, text: _kSmilies[alt]);
      } else {
        // render alt text if mapping not found
        // because inline image is not supported
        meta = lazyAddNode(meta, text: alt);
      }
    }

    return meta;
  }
}
```

![](../../example/screenshots/core/SmilieScreen.png?raw=true)
