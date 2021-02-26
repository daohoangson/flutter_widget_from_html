# WebViewFactory

![Flutter](https://github.com/daohoangson/flutter_widget_from_html/workflows/Flutter/badge.svg)
[![codecov](https://codecov.io/gh/daohoangson/flutter_widget_from_html/branch/master/graph/badge.svg)](https://codecov.io/gh/daohoangson/flutter_widget_from_html)
[![Pub](https://img.shields.io/pub/v/fwfh_webview.svg)](https://pub.dev/packages/fwfh_webview)

WidgetFactory extension to render IFRAME with the official WebView plugin.
This is a companion add-on for [flutter_widget_from_html_core](https://pub.dev/packages/flutter_widget_from_html_core) package.

## Getting Started

Add this to your app's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_widget_from_html_core: any
  fwfh_webview: 0.0.1
```

## Usage

Then use `HtmlWidget` with a custom factory:

```dart
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fwfh_webview/fwfh_webview.dart';

// ...

HtmlWidget(
  html,
  factoryBuilder: () => MyWidgetFactory(),
)

// ...

class MyWidgetFactory extends WidgetFactory with WebViewFactory {
  // optional: override getter to configure how WebViews are built
  bool get webViewMediaPlaybackAlwaysAllow => true;
  String? get webViewUserAgent => 'My app';
}
```

## Features

Configurable getters:

|                                 | Type   | Default |
|---------------------------------|--------|---------|
| webView                         | bool   | true    |
| webViewDebuggingEnabled         | bool   | false   |
| webViewJs                       | bool   | true    |
| webViewMediaPlaybackAlwaysAllow | bool   | false   |
| webViewUserAgent                | String | null    |

Supported IFRAME attributes:

- src
- width, height
- sandbox
  - allow-scripts
