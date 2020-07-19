import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

// https://publish.twitter.com/oembed?url=https%3A%2F%2Ftwitter.com%2FFlutterDev%2Fstatus%2F1271535349664108544
const html = '''
<blockquote class="twitter-tweet">
	<p lang="en" dir="ltr">All AboutDialog 💬
		<br>
		<br>Before you ship your Flutter app, learn how you can easily add formalities such as the legalese, version number, licenses, and other small print with a simple widget.
		<br>
		<br>More <a href="https://twitter.com/hashtag/WidgetoftheWeek?src=hash&ref_src=twsrc%5Etfw">#WidgetoftheWeek</a> → <a href="https://t.co/uuofoT3ciZ">https://t.co/uuofoT3ciZ</a>  <a href="https://t.co/ZBk2nWuiSf">pic.twitter.com/ZBk2nWuiSf</a>
	</p>— Flutter (@FlutterDev) <a href="https://twitter.com/FlutterDev/status/1271535349664108544?ref_src=twsrc%5Etfw">June 12, 2020</a>
</blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>
''';

class IframeTwitterScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<IframeTwitterScreen> {
  bool useApi = true;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('IframeTwitterScreen'),
        ),
        body: ListView(children: <Widget>[
          CheckboxListTile(
            value: useApi,
            onChanged: (v) => setState(() => useApi = v),
            title: HtmlWidget('Use iframe API'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: HtmlWidget(
              html,
              key: ValueKey(useApi),
              customStylesBuilder: (e) =>
                  (e.localName == 'blockquote') ? ['margin', '0'] : null,
              customWidgetBuilder: (e) {
                if (e.localName == 'blockquote' &&
                    e.attributes['class'] == 'twitter-tweet') {
                  final body = html +
                      '<script async src="https://platform.twitter.com/widgets.js"></script>';
                  final apiUrl =
                      'https://html-widget-api.now.sh/iframe.ts?body=${Uri.encodeComponent(body)}';

                  final dataUrl = Uri.dataFromString(
                    '''<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width">
</head>
<body>$body</body>
</html>''',
                    mimeType: 'text/html',
                    encoding: Encoding.getByName('utf-8'),
                  ).toString();

                  return WebView(
                    useApi ? apiUrl : dataUrl,
                    aspectRatio: 16 / 9,
                    getDimensions: true,
                  );
                }

                return null;
              },
              webView: true,
            ),
          ),
        ]),
      );
}
