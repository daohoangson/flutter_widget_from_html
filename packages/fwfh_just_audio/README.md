# JustAudioFactory

[![Flutter](https://github.com/daohoangson/flutter_widget_from_html/actions/workflows/flutter.yml/badge.svg)](https://github.com/daohoangson/flutter_widget_from_html/actions/workflows/flutter.yml)
[![codecov](https://codecov.io/gh/daohoangson/flutter_widget_from_html/branch/master/graph/badge.svg)](https://codecov.io/gh/daohoangson/flutter_widget_from_html)
[![Pub](https://img.shields.io/pub/v/fwfh_just_audio.svg)](https://pub.dev/packages/fwfh_just_audio)

WidgetFactory extension to render AUDIO with the [just_audio](https://pub.dev/packages/just_audio) plugin.
This is a companion add-on for [flutter_widget_from_html_core](https://pub.dev/packages/flutter_widget_from_html_core) package.

Live demo: https://demo.fwfh.dev/#/audio

## Getting Started

Add this to your app's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_widget_from_html_core: any
  fwfh_just_audio: ^0.14.3
```

### Platform specific configuration

#### iOS

This package uses `just_audio` to play audio and this dependency uses a microphone API.
By default, the App Store requires a usage description which can be skipped by editing your `ios/Podfile`.
See the detailed instruction on [its pub.dev page](https://pub.dev/packages/just_audio#ios).

If you don't need `AUDIO` tag support (e.g. your HTML never has that tag), it may be better to switch to
the core package and use it with a subset of the mixins. See [Extensibility](https://pub.dev/packages/flutter_widget_from_html_core#extensibility) for more details.

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
