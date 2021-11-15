# FwfhTextStyle

![Flutter](https://github.com/daohoangson/flutter_widget_from_html/workflows/Flutter/badge.svg)
[![codecov](https://codecov.io/gh/daohoangson/flutter_widget_from_html/branch/master/graph/badge.svg)](https://codecov.io/gh/daohoangson/flutter_widget_from_html)
[![Pub](https://img.shields.io/pub/v/fwfh_text_style.svg)](https://pub.dev/packages/fwfh_text_style)

A `TextStyle` replacement that allows resetting .height to null.
This is a companion add-on for [flutter_widget_from_html](https://pub.dev/packages/flutter_widget_from_html) package.

See [flutter/flutter#58765](https://github.com/flutter/flutter/issues/58765)
and [flutter/flutter#58766](https://github.com/flutter/flutter/pull/58766) for more information.

## Getting Started

Add this to your app's `pubspec.yaml` file:

```yaml
dependencies:
  fwfh_text_style: ^2.5.0
```

## Usage

```dart
TextStyle style = DefaultTextStyle.of(context);
style = FwfhTextStyle.from(style);

// ...

// reset .height to null (normal line height behavior)
style = style.copyWith(height: null);
```
