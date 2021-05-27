import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:just_audio/just_audio.dart' as lib;
import 'package:rxdart/rxdart.dart';

/// An audio player.
class AudioPlayer extends StatefulWidget {
  /// The source URL.
  final String url;

  /// Controls whether to play audio automatically.
  ///
  /// Default: `false`.
  final bool autoplay;

  /// Controls whether to play audio in loops.
  ///
  /// Default: `false`.
  final bool loop;

  /// Controls whether to mute initially.
  ///
  /// Default: `false`.
  final bool muted;

  /// Controls whether to preload audio data.
  ///
  /// Default: `false`.
  final bool preload;

  /// Creates a player.
  AudioPlayer(
    this.url, {
    this.autoplay = false,
    Key? key,
    this.loop = false,
    this.muted = false,
    this.preload = false,
  }) : super(key: key);

  @override
  State<AudioPlayer> createState() => _AudioPlayerState();
}

class _AudioPlayerState extends State<AudioPlayer> {
  late final lib.AudioPlayer _player;
  late final StreamSubscription _processingStateStreamSub;

  @override
  void initState() {
    super.initState();

    _player = lib.AudioPlayer();
    _processingStateStreamSub =
        _player.processingStateStream.listen((processingState) {
      if (!mounted) return;
      if (processingState == lib.ProcessingState.completed) {
        _player.pause();
        _player.seek(Duration.zero);
      }
    });

    _player
      ..setUrl(widget.url, preload: widget.preload)
      ..setLoopMode(widget.loop ? lib.LoopMode.one : lib.LoopMode.off);
  }

  @override
  void dispose() {
    _processingStateStreamSub.cancel();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Row(
        children: [
          _AudioPlayButton(
            pause: _player.pause,
            play: _player.play,
            stream: _player.playingStream,
          ),
          Expanded(
            child: _PositionSlider(
              durationStream: _player.durationStream,
              positionStream: _player.positionStream,
              seek: _player.seek,
            ),
          ),
          _DurationText(_player.durationStream),
        ],
      );
}

class _AudioPlayButton extends StatelessWidget {
  final VoidCallback pause;
  final VoidCallback play;
  final Stream<bool> stream;

  const _AudioPlayButton({
    Key? key,
    required this.pause,
    required this.play,
    required this.stream,
  }) : super(key: key);

  @override
  Widget build(BuildContext _) => StreamBuilder<bool>(
        builder: (_, snapshot) {
          final isPlaying = snapshot.data ?? false;
          return IconButton(
            onPressed: isPlaying ? pause : play,
            icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
          );
        },
        stream: stream,
      );
}

class _DurationText extends StatelessWidget {
  final Stream<Duration?> stream;

  const _DurationText(this.stream, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext _) => StreamBuilder<Duration?>(
        builder: (_, snapshot) {
          final duration = snapshot.data?.inSeconds ?? -1;
          final minutes = duration ~/ 60;
          final seconds = duration % 60;
          return Text(
            duration >= 0
                ? '--:--'
                : (minutes.toString().padLeft(2, '0') +
                    ':' +
                    seconds.toString().padLeft(2, '0')),
          );
        },
        stream: stream,
      );
}

class _PositionSlider extends StatelessWidget {
  final Stream<Duration?> durationStream;
  final Stream<Duration> positionStream;
  final void Function(Duration) seek;

  const _PositionSlider({
    Key? key,
    required this.durationStream,
    required this.positionStream,
    required this.seek,
  }) : super(key: key);

  @override
  Widget build(BuildContext _) => StreamBuilder<_PositionData>(
        builder: (_, snapshot) {
          final data = snapshot.data;
          final max = data?.max?.inMilliseconds.toDouble();
          if (max == null) return widget0;

          final value = data?.value.inMilliseconds.toDouble();
          if (value == null) return widget0;

          return Slider.adaptive(
            max: max,
            onChanged: onChanged,
            value: value,
          );
        },
        stream: positionStream.withLatestFrom<Duration?, _PositionData>(
          durationStream,
          (value, max) => _PositionData(value, max),
        ),
      );

  void onChanged(double ms) => seek(Duration(milliseconds: ms.toInt()));
}

class _PositionData {
  final Duration value;
  final Duration? max;

  _PositionData(this.value, this.max);
}
