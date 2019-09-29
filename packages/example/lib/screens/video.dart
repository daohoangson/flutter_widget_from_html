import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class VideoScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<VideoScreen> {
  bool autoplay = false;
  bool controls = false;
  bool loop = false;
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
          title: Text('VideoScreen'),
        ),
        body: ListView(children: <Widget>[
          CheckboxListTile(
            value: autoplay,
            onChanged: (v) => _setState(() => autoplay = v),
            title: const Text('autoplay'),
          ),
          CheckboxListTile(
            value: controls,
            onChanged: (v) => _setState(() => controls = v),
            title: const Text('controls'),
          ),
          CheckboxListTile(
            value: loop,
            onChanged: (v) => _setState(() => loop = v),
            title: const Text('loop'),
          ),
          CheckboxListTile(
            value: widthHeight,
            onChanged: (v) => _setState(() => widthHeight = v),
            title: const Text('width & height'),
          ),
          ListTile(
            title: Text('HTML:'),
            subtitle: Text(_html),
          ),
          ListTile(
            title: Text('Rendered:'),
            subtitle: HtmlWidget(
              _html,
              key: Key(_html),
              baseUrl: Uri.parse('https://www.w3schools.com/html/'),
            ),
          ),
          Center(child: Text('----')),
        ]),
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
        if (widthHeight) {
          attributes.add('width="320" height="176"');
        }

        _html = """
<figure>
  <video ${attributes.join(' ')}>
    <source src="mov_bbb.mp4" type="video/mp4">
    <source src="mov_bbb.ogg" type="video/ogg">
    Your browser does not support HTML5 video.
  </video>
  <figcaption>Source: <a href="https://www.w3schools.com/html/html5_video.asp">w3schools</a></figcaption>
</figure>
""";
      });
}
