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

  @override
  void initState() {
    super.initState();

    _vpc = lib.VideoPlayerController.network(widget.url);

    if (widget.autoResize) {
      _aspectRatioListener = () {
        if (_aspectRatio == null) {
          final vpv = _vpc.value;
          if (!vpv.initialized) return;
          setState(() => _aspectRatio = vpv.aspectRatio);
        }

        _vpc.removeListener(_aspectRatioListener);
      };
      _vpc.addListener(_aspectRatioListener);
    }

    _cc = lib.ChewieController(
      aspectRatio: widget.autoResize ? null : widget.aspectRatio,
      autoInitialize: true,
      autoPlay: widget.autoplay == true,
      looping: widget.loop == true,
      showControls: widget.controls == true,
      videoPlayerController: _vpc,
    );
  }

  @override
  void dispose() {
    _vpc.dispose();
    _cc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AspectRatio(
        aspectRatio: _aspectRatio ?? widget.aspectRatio,
        child: lib.Chewie(controller: _cc),
      );
}
