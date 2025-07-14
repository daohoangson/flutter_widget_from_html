# WebViewFactory

[![Flutter](https://github.com/daohoangson/flutter_widget_from_html/actions/workflows/flutter.yml/badge.svg)](https://github.com/daohoangson/flutter_widget_from_html/actions/workflows/flutter.yml)
[![Coverage](https://sonarcloud.io/api/project_badges/measure?project=daohoangson_flutter_widget_from_html&metric=coverage)](https://sonarcloud.io/summary/new_code?id=daohoangson_flutter_widget_from_html)
[![Pub](https://img.shields.io/pub/v/fwfh_webview.svg)](https://pub.dev/packages/fwfh_webview)

WidgetFactory extension to render IFRAME with the official WebView plugin.
This is a companion add-on for [flutter_widget_from_html_core](https://pub.dev/packages/flutter_widget_from_html_core) package.

Live demo: https://demo.fwfh.dev/#/iframe

## Getting Started

Add this to your app's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_widget_from_html_core: any
  fwfh_webview: ^0.15.4
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

|                                        | Type     | Default |
| -------------------------------------- | -------- | ------- |
| webView                                | bool     | true    |
| webViewDebuggingEnabled                | bool     | false   |
| webViewGestureRecognizers              | Set      | empty   |
| webViewJs                              | bool     | true    |
| webViewMediaPlaybackAlwaysAllow        | bool     | false   |
| webViewOnAndroidHideCustomWidget       | Function | null    |
| webViewOnAndroidShowCustomWidget       | Function | null    |
| webViewUnsupportedWorkaroundForIssue37 | bool     | true    |
| webViewUserAgent                       | String?  | null    |

Supported IFRAME attributes:

- src
- width, height
- sandbox
  - allow-scripts
