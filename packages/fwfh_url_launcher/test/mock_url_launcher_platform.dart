import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

Iterable<String> get mockLaunchedUrls {
  final instance = UrlLauncherPlatform.instance;
  if (instance is _FakeUrlLauncherPlatform) {
    return instance.urls;
  }

  return [];
}

void mockUrlLauncherPlatform() => _FakeUrlLauncherPlatform();

class _FakeUrlLauncherPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {
  final List<String> urls = [];

  _FakeUrlLauncherPlatform() {
    UrlLauncherPlatform.instance = this;
  }

  @override
  Future<bool> canLaunch(String url) async {
    return true;
  }

  @override
  Future<bool> launch(
    String url, {
    required bool useSafariVC,
    required bool useWebView,
    required bool enableJavaScript,
    required bool enableDomStorage,
    required bool universalLinksOnly,
    required Map<String, String> headers,
    String? webOnlyWindowName,
  }) async {
    urls.add(url);
    return true;
  }
}
