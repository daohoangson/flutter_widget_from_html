import 'package:flutter/widgets.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:url_launcher/url_launcher.dart';

/// A mixin that can launch A tag via `url_launcher` plugin.
mixin UrlLauncherFactory on WidgetFactory {
  @override
  GestureTapCallback? gestureTapCallback(String url) {
    final callback = super.gestureTapCallback(url);
    if (callback == null) return null;
    if (!url.startsWith('http')) return callback;

    return () async {
      final ok = await canLaunch(url);
      if (ok) {
        await launch(url);
        return;
      }

      callback();
    };
  }
}
