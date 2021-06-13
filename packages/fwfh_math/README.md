# MathFactory

![Flutter](https://github.com/daohoangson/flutter_widget_from_html/workflows/Flutter/badge.svg)
[![codecov](https://codecov.io/gh/daohoangson/flutter_widget_from_html/branch/master/graph/badge.svg)](https://codecov.io/gh/daohoangson/flutter_widget_from_html)
[![Pub](https://img.shields.io/pub/v/fwfh_math.svg)](https://pub.dev/packages/fwfh_math)

WidgetFactory extension to render math equation with [flutter_math](https://pub.dev/packages/flutter_math) package.
This is a companion add-on for [flutter_widget_from_html_core](https://pub.dev/packages/flutter_widget_from_html_core) package.

## Getting Started

Add this to your app's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_widget_from_html_core: any
  fwfh_math: ^0.6.0
```

## Usage

Then use `HtmlWidget` with a custom factory:

```dart
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fwfh_math/fwfh_math.dart';

// ...

HtmlWidget(
  html,
  factoryBuilder: () => MyWidgetFactory(),
)

// ...

class MyWidgetFactory extends WidgetFactory with MathFactory {
}
```
