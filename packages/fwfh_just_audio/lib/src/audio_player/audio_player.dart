import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:just_audio/just_audio.dart' as lib;

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
  const AudioPlayer(
    this.url, {
    this.autoplay = false,
    super.key,
    this.loop = false,
    this.muted = false,
    this.preload = false,
  });

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
      if (!mounted) {
        return;
      }

      if (processingState == lib.ProcessingState.completed) {
        _player.pause();
        _player.seek(Duration.zero);
      }
    });

    _player
      ..setUrl(widget.url, preload: widget.preload)
      ..setLoopMode(widget.loop ? lib.LoopMode.one : lib.LoopMode.off);

    if (widget.autoplay) {
      _player.play();
    }

    if (widget.muted) {
      _player.setVolume(0);
    }
  }

  @override
  void dispose() {
    _processingStateStreamSub.cancel();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (_, bc) {
          final isNarrow = bc.hasBoundedWidth && bc.maxWidth <= 320;
          final theme = Theme.of(context);
          final fontSize = DefaultTextStyle.of(context).style.fontSize ?? 14.0;
          final tsf = MediaQuery.textScaleFactorOf(context);
          final iconSize = fontSize * tsf;

          return DecoratedBox(
            decoration: BoxDecoration(
              color: theme.brightness == Brightness.light
                  ? const Color.fromRGBO(0, 0, 0, .1)
                  : const Color.fromRGBO(255, 255, 255, .1),
              borderRadius: BorderRadius.circular(iconSize * 2),
            ),
            child: Row(
              children: [
                _PlayButton(
                  pause: _player.pause,
                  play: _player.play,
                  size: iconSize,
                  stream: _player.playingStream,
                ),
                _PositionText(
                  durationStream: _player.durationStream,
                  isNarrow: isNarrow,
                  positionStream: _player.positionStream,
                  size: iconSize,
                ),
                Expanded(
                  child: _PositionSlider(
                    durationStream: _player.durationStream,
                    positionStream: _player.positionStream,
                    seek: _player.seek,
                    size: iconSize,
                  ),
                ),
                _MuteButton(
                  setVolume: _player.setVolume,
                  size: iconSize,
                  stream: _player.volumeStream,
                ),
              ],
            ),
          );
        },
      );
}

class _PlayButton extends StatelessWidget {
  final VoidCallback pause;
  final VoidCallback play;
  final double size;
  final Stream<bool> stream;

  const _PlayButton({
    required this.pause,
    required this.play,
    required this.size,
    required this.stream,
  });

  @override
  Widget build(BuildContext _) => StreamBuilder<bool>(
        builder: (_, snapshot) {
          final isPlaying = snapshot.data ?? false;
          return IconButton(
            onPressed: isPlaying ? pause : play,
            icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
            iconSize: size * 2,
          );
        },
        stream: stream,
      );
}

class _PositionText extends StatelessWidget {
  final Stream<Duration?> durationStream;
  final bool isNarrow;
  final Stream<Duration> positionStream;
  final double size;

  const _PositionText({
    required this.durationStream,
    required this.isNarrow,
    required this.positionStream,
    required this.size,
  });

  @override
  Widget build(BuildContext _) => StreamBuilder<Duration?>(
        builder: (_, duration) => StreamBuilder<Duration>(
          builder: (_, position) {
            final max = duration.data?.inSeconds ?? -1;
            final value = position.data?.inSeconds ?? -1;
            final remaining = max > value ? max - value : 0;
            final text = isNarrow
                ? '-${_secondsToString(remaining)}'
                : '${_secondsToString(value)} / '
                    '${_secondsToString(max)}';
            return Text(
              text,
              style: TextStyle(fontSize: size),
              textScaleFactor: 1,
            );
          },
          stream: positionStream,
        ),
        stream: durationStream,
      );

  String _secondsToString(int value) {
    if (value < 0) {
      return '0:00';
    }

    final m = value ~/ 60;
    final s = value % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }
}

class _PositionSlider extends StatelessWidget {
  final Stream<Duration?> durationStream;
  final Stream<Duration> positionStream;
  final void Function(Duration) seek;
  final double size;

  const _PositionSlider({
    required this.durationStream,
    required this.positionStream,
    required this.seek,
    required this.size,
  });

  @override
  Widget build(BuildContext context) => StreamBuilder<Duration?>(
        builder: (_, duration) => StreamBuilder<Duration>(
          builder: (_, position) {
            final max = duration.data?.inMilliseconds.toDouble();
            if (max == null) {
              return widget0;
            }

            final value = position.data?.inMilliseconds.toDouble() ?? 0.0;

            return SliderTheme(
              data: SliderTheme.of(context).copyWith(
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: size / 2),
              ),
              child: Slider.adaptive(
                max: max,
                onChanged: onChanged,
                value: value,
              ),
            );
          },
          stream: positionStream,
        ),
        stream: durationStream,
      );

  void onChanged(double ms) => seek(Duration(milliseconds: ms.toInt()));
}

class _MuteButton extends StatelessWidget {
  final Future<void> Function(double) setVolume;
  final double size;
  final Stream<double> stream;

  const _MuteButton({
    required this.setVolume,
    required this.size,
    required this.stream,
  });

  @override
  Widget build(BuildContext _) => StreamBuilder<double>(
        builder: (_, snapshot) {
          final isMuted = (snapshot.data ?? 1.0) == 0;
          return IconButton(
            onPressed: isMuted ? unmute : mute,
            icon: Icon(isMuted ? Icons.volume_off_outlined : Icons.volume_up),
            iconSize: size * 2,
          );
        },
        stream: stream,
      );

  void mute() => setVolume(0);

  void unmute() => setVolume(1);
}
