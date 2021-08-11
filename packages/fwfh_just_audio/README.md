# JustAudioFactory

![Flutter](https://github.com/daohoangson/flutter_widget_from_html/workflows/Flutter/badge.svg)
[![codecov](https://codecov.io/gh/daohoangson/flutter_widget_from_html/branch/master/graph/badge.svg)](https://codecov.io/gh/daohoangson/flutter_widget_from_html)
[![Pub](https://img.shields.io/pub/v/fwfh_just_audio.svg)](https://pub.dev/packages/fwfh_just_audio)

WidgetFactory extension to render AUDIO with the [just_audio](https://pub.dev/packages/just_audio) plugin.
This is a companion add-on for [flutter_widget_from_html_core](https://pub.dev/packages/flutter_widget_from_html_core) package.

## Getting Started

Add this to your app's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_widget_from_html_core: any
  fwfh_just_audio: ^0.6.2
```

## Usage

Then use `HtmlWidget` with a custom factory:

```dart
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fwfh_just_audio/fwfh_just_audio.dart';

// ...

HtmlWidget(
  html,
  factoryBuilder: () => MyWidgetFactory(),
)

// ...

class MyWidgetFactory extends WidgetFactory with JustAudioFactory {
}
```
