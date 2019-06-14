import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart' as lib;
import 'package:video_player/video_player.dart' as lib;

class VideoPlayer extends StatefulWidget {
  final String url;

  final double aspectRatio;
  final bool autoResize;
  final bool autoplay;
  final bool controls;
  final bool loop;

  VideoPlayer(
    this.url, {
    this.aspectRatio,
    this.autoResize = true,
    this.autoplay = false,
    this.controls = false,
    this.loop = false,
    Key key,
  })  : assert(url != null),
        assert(aspectRatio != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  lib.VideoPlayerController _vpc;
  lib.ChewieController _cc;

  double _aspectRatio;
  VoidCallback _aspectRatioListener;

  bool get needSizing => widget.autoResize == true && _aspectRatio == null;

  @override
  void initState() {
    super.initState();

    _vpc = lib.VideoPlayerController.network(widget.url);

    if (needSizing) {
      _aspectRatioListener = () {
        if (_aspectRatio == null) {
          final vpv = _vpc.value;
          if (!vpv.initialized) return;

          setState(() {
            _aspectRatio = vpv.aspectRatio;
            _initChewieController();
          });
        }

        _vpc.removeListener(_aspectRatioListener);
      };
      _vpc.addListener(_aspectRatioListener);
    }

    _initChewieController();
  }

  @override
  void dispose() {
    _vpc.dispose();
    _cc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => lib.Chewie(
        controller: _cc,
        key: ValueKey(_cc),
      );

  void _initChewieController() {
    _cc?.dispose();

    _cc = lib.ChewieController(
      aspectRatio: _aspectRatio ?? widget.aspectRatio,
      autoInitialize: true,
      autoPlay: widget.autoplay == true,
      looping: widget.loop == true,
      showControls: widget.controls == true && !needSizing,
      videoPlayerController: _vpc,
    );
  }
}
