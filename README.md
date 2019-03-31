# Flutter Widget from HTML

[![CircleCI](https://circleci.com/gh/daohoangson/flutter_widget_from_html.svg?style=svg)](https://circleci.com/gh/daohoangson/flutter_widget_from_html)
[![codecov](https://codecov.io/gh/daohoangson/flutter_widget_from_html/branch/master/graph/badge.svg)](https://codecov.io/gh/daohoangson/flutter_widget_from_html)

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

This package has all the features of [`flutter_widget_from_html_core`](https://pub.dartlang.org/packages/flutter_widget_from_html_core) and some nice extras:

- Renders A tag with theme accent color, launch url via [`url_launcher`](https://pub.dartlang.org/packages/url_launcher)
- Renders IMG tag with [`CachedNetworkImage`](https://pub.dartlang.org/packages/cached_network_image) and padding (`Config.imagePadding`)
- Renders lists (OL/UL) with marker and padding (`Config.listBullet`, `Config.listPaddingLeft`)
- Renders texts with padding (`Config.textPadding`)
- Supports relative url (A href, IMG src)
