import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

const kHtml = '''
<figure>
    <figcaption>Listen to the T-Rex:</figcaption>
    <audio
        controls
        src="/media/cc0-audio/t-rex-roar.mp3">
            Your browser does not support the
            <code>audio</code> element.
    </audio>
</figure>

<p>Source: <a href="https://developer.mozilla.org/en-US/docs/Web/HTML/Element/audio">developer.mozilla.org</a>.</p>
''';

final baseUrl = Uri.https(
    'interactive-examples.mdn.mozilla.net', '/pages/tabbed/audio.html');

class AudioScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('AudioScreen'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Text(
                  'Without custom WidgetFactory',
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(height: 16),
                HtmlWidget(
                  kHtml,
                  baseUrl: baseUrl,
                ),
                Divider(),
                Text(
                  'With custom WidgetFactory',
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(height: 16),
                HtmlWidget(
                  kHtml,
                  baseUrl: baseUrl,
                  factoryBuilder: () => _AudioWidgetFactory(),
                ),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          ),
        ),
      );
}

class _AudioWidgetFactory extends WidgetFactory {
  @override
  void parse(BuildMetadata meta) {
    if (meta.element.localName == 'audio') {
      meta.register(audioOp(meta));
      return;
    }

    return super.parse(meta);
  }

  BuildOp audioOp(BuildMetadata meta) {
    final e = meta.element;
    final attrs = e.attributes;
    final url = urlFull(attrs['src']);
    if (url == null) return null;

    return BuildOp(onWidgets: (_, __) => [_AudioPlayer(url)]);
  }
}

class _AudioPlayer extends StatefulWidget {
  final String url;

  const _AudioPlayer(this.url, {Key key}) : super(key: key);

  @override
  State<_AudioPlayer> createState() => _AudioState();
}

class _AudioState extends State<_AudioPlayer> {
  final player = AudioPlayer();

  @override
  void dispose() {
    player.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Row(
        children: [
          StreamBuilder<AudioPlayerState>(
            builder: (_, snapshot) => _buildIconButton(snapshot.data),
            initialData: AudioPlayerState.STOPPED,
            stream: player.onPlayerStateChanged,
          ),
          Expanded(
            child: StreamBuilder<Duration>(
              builder: (_, duration) => StreamBuilder<Duration>(
                builder: (_, position) =>
                    _buildProgressBar(position.data, duration.data),
                initialData: Duration.zero,
                stream: player.onAudioPositionChanged,
              ),
              initialData: Duration.zero,
              stream: player.onDurationChanged,
            ),
          ),
        ],
      );

  Widget _buildIconButton(AudioPlayerState state) {
    VoidCallback callback;
    IconData icon;
    switch (state) {
      case AudioPlayerState.PLAYING:
        callback = _pause;
        icon = Icons.pause;
        break;
      case AudioPlayerState.PAUSED:
        callback = _resume;
        icon = Icons.play_arrow;
        break;
      case AudioPlayerState.COMPLETED:
      case AudioPlayerState.STOPPED:
        callback = _play;
        icon = Icons.play_arrow;
        break;
    }

    return IconButton(
      onPressed: callback,
      icon: Icon(icon),
    );
  }

  Widget _buildProgressBar(Duration position, Duration duration) => Slider(
        max: duration.inMilliseconds.toDouble(),
        onChanged: (ms) => _seek(Duration(milliseconds: ms.toInt())),
        value: position.inMilliseconds.toDouble(),
      );

  void _play() => player.play(widget.url);

  void _resume() => player.play(widget.url);

  void _pause() => player.pause();

  void _seek(Duration position) => player.seek(position);
}
