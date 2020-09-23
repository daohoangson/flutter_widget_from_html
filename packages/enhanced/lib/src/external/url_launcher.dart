import 'package:url_launcher/url_launcher.dart';

Future<bool> launchUrl(String url) async {
  final ok = await canLaunch(url);
  if (!ok) {
    print("[HtmlWidget] onTapUrl($url) couldn't launch");
    return false;
  }

  return launch(url);
}
