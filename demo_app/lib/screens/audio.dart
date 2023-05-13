import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class AudioScreen extends StatefulWidget {
  const AudioScreen({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<AudioScreen> {
  bool autoplay = false;
  bool loop = false;
  bool muted = false;
  bool preload = false;

  String _html = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _setState(() {}));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('AudioScreen'),
        ),
        body: ListView(
          children: <Widget>[
            CheckboxListTile(
              value: autoplay,
              onChanged: (v) => _setState(() => autoplay = v == true),
              title: const Text('autoplay'),
            ),
            CheckboxListTile(
              value: loop,
              onChanged: (v) => _setState(() => loop = v == true),
              title: const Text('loop'),
            ),
            CheckboxListTile(
              value: muted,
              onChanged: (v) => _setState(() => muted = v == true),
              title: const Text('muted'),
            ),
            CheckboxListTile(
              value: preload,
              onChanged: (v) => _setState(() => preload = v == true),
              title: const Text('preload'),
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
                  'https://interactive-examples.mdn.mozilla.net/pages/tabbed/audio.html',
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
        if (loop) {
          attributes.add('loop');
        }
        if (muted) {
          attributes.add('muted');
        }
        if (preload) {
          attributes.add('preload');
        }

        _html = '''
<figure>
  <audio src="/media/cc0-audio/t-rex-roar.mp3" ${attributes.join(' ')}>
    Sorry, <code>AUDIO</code> tag is not supported.
  </audio>
  <figcaption>Source: <a href="https://developer.mozilla.org/en-US/docs/Web/HTML/Element/audio">developer.mozilla.org</a></figcaption>
</figure>
''';
      });
}
