# SvgFactory

[![Flutter](https://github.com/daohoangson/flutter_widget_from_html/actions/workflows/flutter.yml/badge.svg)](https://github.com/daohoangson/flutter_widget_from_html/actions/workflows/flutter.yml)
[![Coverage](https://sonarcloud.io/api/project_badges/measure?project=daohoangson_flutter_widget_from_html&metric=coverage)](https://sonarcloud.io/summary/new_code?id=daohoangson_flutter_widget_from_html)
[![Pub](https://img.shields.io/pub/v/fwfh_svg.svg)](https://pub.dev/packages/fwfh_svg)

WidgetFactory extension to render SVG with [flutter_svg](https://pub.dev/packages/flutter_svg) plugin.
This is a companion add-on for [flutter_widget_from_html_core](https://pub.dev/packages/flutter_widget_from_html_core) package.

## Getting Started

Add this to your app's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_widget_from_html_core: any
  fwfh_svg: ^0.16.0
```

## Usage

Then use `HtmlWidget` with a custom factory:

```dart
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fwfh_svg/fwfh_svg.dart';

// ...

HtmlWidget(
  html,
  factoryBuilder: () => MyWidgetFactory(),
)

// ...

class MyWidgetFactory extends WidgetFactory with SvgFactory {
}
```

## Configuration

`SvgFactory` has a few getters to change its behavior.
See the [API reference](https://pub.dev/documentation/fwfh_svg/latest/fwfh_svg/SvgFactory-mixin.html#instance-properties) for the up to date list.
Override them in your factory like this:

```dart
class MyWidgetFactory extends WidgetFactory with SvgFactory {
  @override
  bool get svgAllowDrawingOutsideViewBox => true;
}
```
