import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fwfh_url_launcher/fwfh_url_launcher.dart';

import '../../core/test/_.dart' as helper;

const tapText = helper.tapText;

Future<String> explain(WidgetTester tester, String html) async =>
    helper.explain(
      tester,
      null,
      hw: HtmlWidget(
        html,
        key: helper.hwKey,
        factoryBuilder: () => _WidgetFactory(),
      ),
    );

class _WidgetFactory extends WidgetFactory with UrlLauncherFactory {}

const MethodChannel _channel = MethodChannel('plugins.flutter.io/url_launcher');
final _launchUrls = <String>[];

void mockSetup() {
  _launchUrls.clear();

  _channel.setMockMethodCallHandler((methodCall) async {
    switch (methodCall.method) {
      case 'canLaunch':
        return true;
      case 'launch':
        // ignore: avoid_dynamic_calls
        final url = methodCall.arguments['url'];
        if (url is String) {
          _launchUrls.add(url);
        }
    }

    return null;
  });
}

void mockTearDown() {
  _channel.setMockMethodCallHandler(null);
}

Iterable<String> mockGetLaunchUrls() => _launchUrls;
