import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:url_launcher/url_launcher.dart';

/// A mixin that can launch A tag via `url_launcher` plugin.
mixin UrlLauncherFactory on WidgetFactory {
  @override
  Future<bool> onTapUrl(String url) async {
    final result = await super.onTapUrl(url);
    if (result) {
      return result;
    }

    // TODO: remove lint ignores when mininum url_launcher version >= 6.1.0
    // ignore: deprecated_member_use
    final ok = await canLaunch(url);
    if (!ok) {
      return false;
    }

    // ignore: deprecated_member_use
    return launch(url);
  }
}
