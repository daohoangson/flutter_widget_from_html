import 'dart:async';

import 'package:chewie/chewie.dart' as lib;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
  VideoPlayer(
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
      defaultTargetPlatform == TargetPlatform.android ||
              defaultTargetPlatform == TargetPlatform.iOS ||
              kIsWeb
          ? _VideoPlayerState()
          : _PlaceholderState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  var hasError = false;

  lib.ChewieController? _controller;
  lib.VideoPlayerController? _vpc;

  Widget? get placeholder =>
      widget.poster != null ? Center(child: widget.poster) : null;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  @override
  void dispose() {
    _vpc?.dispose();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final aspectRatio = ((widget.autoResize && _controller != null)
            ? _vpc?.value.aspectRatio
            : null) ??
        widget.aspectRatio;

    late Widget child;
    if (_controller != null) {
      child = lib.Chewie(controller: _controller!);
    } else if (hasError) {
      child = const Center(child: Text('❌'));
    } else {
      child = placeholder ?? const CircularProgressIndicator.adaptive();
    }

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: child,
    );
  }

  Future<void> _initControllers() async {
    final vpc = _vpc = lib.VideoPlayerController.network(widget.url);
    try {
      await vpc.initialize();
    } catch (error) {
      print('Video initialize error: $error');
      setState(() => hasError = true);
      return;
    }

    setState(
      () => _controller = lib.ChewieController(
        autoPlay: widget.autoplay,
        looping: widget.loop,
        placeholder: placeholder,
        showControls: widget.controls,
        videoPlayerController: vpc,
      ),
    );
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
