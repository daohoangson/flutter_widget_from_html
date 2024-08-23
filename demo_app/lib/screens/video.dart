import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<VideoScreen> {
  bool autoplay = false;
  bool controls = false;
  bool loop = false;
  bool poster = false;
  bool widthHeight = false;

  String _html = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _setState(() {}));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('VideoScreen'),
        ),
        body: ListView(
          children: <Widget>[
            CheckboxListTile(
              value: autoplay,
              onChanged: (v) => _setState(() => autoplay = v == true),
              title: const Text('autoplay'),
            ),
            CheckboxListTile(
              value: controls,
              onChanged: (v) => _setState(() => controls = v == true),
              title: const Text('controls'),
            ),
            CheckboxListTile(
              value: loop,
              onChanged: (v) => _setState(() => loop = v == true),
              title: const Text('loop'),
            ),
            CheckboxListTile(
              value: poster,
              onChanged: (v) => _setState(() => poster = v == true),
              title: const Text('poster'),
            ),
            CheckboxListTile(
              value: widthHeight,
              onChanged: (v) => _setState(() => widthHeight = v == true),
              title: const Text('width & height'),
            ),
            ListTile(
              title: const Text('HTML:'),
              subtitle: Text(_html),
            ),
            ListTile(
              title: const Text('Rendered:'),
              subtitle: HtmlWidget(
                _html,
                key: Key(_html),
                baseUrl: Uri.parse(
                  'https://files.daohoangson.com/public/fwfh/',
                ),
              ),
            ),
            const Center(child: Text('----')),
          ],
        ),
      );

  void _setState(VoidCallback callback) => setState(() {
        callback();

        final attributes = <String>[];
        if (autoplay) {
          attributes.add('autoplay');
        }
        if (controls) {
          attributes.add('controls');
        }
        if (loop) {
          attributes.add('loop');
        }
        if (poster) {
          attributes.add('poster="asset:logos/icon.png"');
        }
        if (widthHeight) {
          attributes.add('width="320" height="180"');
        }

        _html = """
<figure>
  <video ${attributes.join(' ')}>
    <source src="flower.mp4" type="video/mp4">
    <code>VIDEO</code> support is not enabled.
  </video>
  <figcaption>Source: <a href="https://developer.mozilla.org/en-US/docs/Web/HTML/Element/video">developer.mozilla.org</a></figcaption>
</figure>
""";
      });
}
