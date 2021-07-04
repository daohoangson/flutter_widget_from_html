import 'package:chewie/chewie.dart' as lib;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:video_player/video_player.dart' as lib;

/// A video player.
class VideoPlayer extends StatefulWidget {
  /// The source URL.
  final String url;

  /// The initial aspect ratio.
  final double aspectRatio;

  /// Controls whether to resize automatically.
  ///
  /// Default: `true`.
  final bool autoResize;

  /// Controls whether to play video automatically.
  ///
  /// Default: `false`.
  final bool autoplay;

  /// Controls whether to show video controls.
  ///
  /// Default: `false`.
  final bool controls;

  /// Controls whether to play video in loops.
  ///
  /// Default: `false`.
  final bool loop;

  /// The widget to be shown before video is loaded.
  final Widget? poster;

  /// Creates a player.
  const VideoPlayer(
    this.url, {
    required this.aspectRatio,
    this.autoResize = true,
    this.autoplay = false,
    this.controls = false,
    Key? key,
    this.loop = false,
    this.poster,
  }) : super(key: key);

  @override
  State<VideoPlayer> createState() =>
      // ignore: no_logic_in_create_state
      defaultTargetPlatform == TargetPlatform.android ||
              defaultTargetPlatform == TargetPlatform.iOS ||
              kIsWeb
          ? _VideoPlayerState()
          : _PlaceholderState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late lib.ChewieController _controller;

  @override
  void initState() {
    super.initState();
    _controller = _Controller(this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AspectRatio(
        aspectRatio: _controller.aspectRatio!,
        child: lib.Chewie(controller: _controller),
      );

  void _onAspectRatioUpdated() => setState(() {});
}

class _Controller extends lib.ChewieController {
  final _VideoPlayerState vps;

  double? _aspectRatio;

  _Controller(this.vps)
      : super(
          autoInitialize: true,
          autoPlay: vps.widget.autoplay,
          looping: vps.widget.loop,
          placeholder: vps.widget.poster != null
              ? Center(child: vps.widget.poster)
              : null,
          showControls: vps.widget.controls,
          videoPlayerController:
              lib.VideoPlayerController.network(vps.widget.url),
        ) {
    if (vps.widget.autoResize) {
      _setupAspectRatioListener();
    }
  }

  @override
  double get aspectRatio => _aspectRatio ?? vps.widget.aspectRatio;

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
  }

  void _setupAspectRatioListener() {
    late VoidCallback listener;

    listener = () {
      if (_aspectRatio == null) {
        final vpv = videoPlayerController.value;
        if (!vpv.isInitialized) return;

        _aspectRatio = vpv.aspectRatio;
        vps._onAspectRatioUpdated();
      }

      videoPlayerController.removeListener(listener);
    };

    videoPlayerController.addListener(listener);
  }
}

class _PlaceholderState extends State<VideoPlayer> {
  @override
  Widget build(BuildContext _) => AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: DecoratedBox(
        decoration: const BoxDecoration(color: Color.fromRGBO(0, 0, 0, .5)),
        child: Center(child: Text('platform=$defaultTargetPlatform')),
      ));
}
