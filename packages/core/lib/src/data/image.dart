part of '../core_data.dart';

/// An image.
@immutable
class ImageMetadata {
  /// The image alternative text.
  final String alt;

  /// The image sources.
  final Iterable<ImageSource> sources;

  /// The image title.
  final String title;

  /// Creates an image.
  ImageMetadata({this.alt, this.sources, this.title});

  @override
  String toString() {
    final attrs = <String>[];
    if (alt != null) attrs.add('alt: "$alt"');
    if (sources != null) attrs.add('sources: $sources');
    if (title != null) attrs.add('title: "$title"');

    return 'ImageMetadata(${attrs.join(', ')})';
  }
}

/// An image source.
@immutable
class ImageSource {
  /// The image height.
  final double height;

  /// The image URL.
  final String url;

  /// The image width.
  final double width;

  /// Creates a source.
  ImageSource(this.url, {this.height, this.width}) : assert(url != null);

  @override
  String toString() =>
      'ImageSource("$url"' +
      (height != null ? 'height: $height' : '') +
      (width != null ? 'width: $width' : '') +
      ')';
}
