import 'package:flutter/foundation.dart';
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

    try {
      final uri = Uri.parse(url);
      final ok = await canLaunchUrl(uri);
      if (!ok) {
        debugPrint('Could not launch "$url": unsupported');
        return false;
      }

      return await launchUrl(uri);
    } catch (error) {
      debugPrint('Could not launch "$url": $error');
      return false;
    }
  }
}
