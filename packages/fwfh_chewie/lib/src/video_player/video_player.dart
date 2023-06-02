import 'dart:async';

import 'package:chewie/chewie.dart' as lib;
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
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

  /// A builder function that is called if an error occurs during video loading.
  final Widget Function(BuildContext context, String url, dynamic error)?
      errorBuilder;

  /// A builder that specifies the widget to display to the user while a video
  /// is still loading.
  final Widget Function(BuildContext context, String url, Widget child)?
      loadingBuilder;

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
    this.errorBuilder,
    super.key,
    this.loadingBuilder,
    this.loop = false,
    this.poster,
  });

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  lib.ChewieController? _controller;
  dynamic _error;
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

    Widget? child;
    final controller = _controller;
    if (controller != null) {
      child = lib.Chewie(controller: controller);
    } else if (_error != null) {
      final errorBuilder = widget.errorBuilder;
      if (errorBuilder != null) {
        child = errorBuilder(context, widget.url, _error);
      }
    } else {
      child = placeholder;

      final loadingBuilder = widget.loadingBuilder;
      if (loadingBuilder != null) {
        child = loadingBuilder(context, widget.url, child ?? widget0);
      }
    }

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: child,
    );
  }

  Future<void> _initControllers() async {
    final vpc = _vpc = lib.VideoPlayerController.network(widget.url);
    Object? vpcError;
    try {
      await vpc.initialize();
    } catch (error) {
      vpcError = error;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      if (vpcError != null) {
        _error = vpcError;
        return;
      }

      _controller = lib.ChewieController(
        autoPlay: widget.autoplay,
        looping: widget.loop,
        placeholder: placeholder,
        showControls: widget.controls,
        videoPlayerController: vpc,
      );
    });
  }
}
