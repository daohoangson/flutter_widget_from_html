import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart'
    as core;
import 'package:flutter_widget_from_html_core/src/internal/core_ops.dart';
import 'package:url_launcher/url_launcher.dart';

import 'internal/ops.dart';
import 'data.dart';
import 'html_widget.dart';
import 'internal/video_player.dart';
import 'internal/web_view.dart';

/// A factory to build widgets with [WebView], [VideoPlayer], etc.
class WidgetFactory extends core.WidgetFactory {
  State<core.HtmlWidget> _state;
  BuildOp _tagIframe;
  BuildOp _tagSvg;
  TextStyleHtml Function(TextStyleHtml, dynamic) _tsbTagA;

  HtmlWidget get _widget {
    final candidate = _state.widget;
    return candidate is HtmlWidget ? candidate : null;
  }

  /// Builds [Divider].
  @override
  Widget buildDivider(NodeMetadata meta) => const Divider(height: 1);

  /// Builds [InkWell].
  @override
  Widget buildGestureDetector(
          NodeMetadata meta, Widget child, GestureTapCallback onTap) =>
      InkWell(child: child, onTap: onTap);

  /// Builds [SvgPicture] or [Image].
  @override
  Widget buildImage(NodeMetadata meta, Object provider, ImageMetadata image) {
    var built = super.buildImage(meta, provider, image);

    if (built == null && provider is PictureProvider) {
      built = SvgPicture(provider);
    }

    if (image.title != null && built != null) {
      built = Tooltip(child: built, message: image.title);
    }

    return built;
  }

  /// Builds [LayoutGrid].
  @override
  Widget buildTable(NodeMetadata node, TableMetadata table) {
    final cols = table.cols;
    if (cols == 0) return null;
    final templateColumnSizes = List<TrackSize>(cols);
    for (var c = 0; c < cols; c++) {
      templateColumnSizes[c] = FlexibleTrackSize(1);
    }

    final rows = table.rows;
    if (rows == 0) return null;
    final templateRowSizes = List<TrackSize>(rows);
    for (var r = 0; r < rows; r++) {
      templateRowSizes[r] = IntrinsicContentTrackSize();
    }

    final border = table.border != null
        ? BoxDecoration(border: Border.fromBorderSide(table.border))
        : null;

    final children = <Widget>[];
    table.visitCells((col, row, widget, colspan, rowspan) {
      Widget child = SizedBox.expand(child: widget);

      if (border != null) {
        child = Container(
          child: child,
          decoration: border,
        );
      }

      child = child.withGridPlacement(
        columnStart: col,
        columnSpan: colspan,
        rowStart: row,
        rowSpan: rowspan,
      );

      children.add(child);
    });

    final layoutGrid = LayoutGrid(
      children: children,
      columnGap: -(table.border?.width ?? 0),
      gridFit: GridFit.passthrough,
      rowGap: -(table.border?.width ?? 0),
      templateColumnSizes: templateColumnSizes,
      templateRowSizes: templateRowSizes,
    );

    if (border == null) return layoutGrid;

    return buildStack(
      node,
      <Widget>[
        layoutGrid,
        Positioned.fill(child: Container(decoration: border))
      ],
    );
  }

  /// Builds [VideoPlayer].
  Widget buildVideoPlayer(
    NodeMetadata meta,
    String url, {
    bool autoplay,
    bool controls,
    double height,
    bool loop,
    String posterUrl,
    double width,
  }) {
    final dimensOk = height != null && height > 0 && width != null && width > 0;
    final posterImgSrc = posterUrl != null ? ImageSource(posterUrl) : null;
    return VideoPlayer(
      url,
      aspectRatio: dimensOk ? width / height : 16 / 9,
      autoResize: !dimensOk,
      autoplay: autoplay,
      controls: controls,
      loop: loop,
      poster: posterImgSrc != null
          ? buildImage(
              meta,
              imageProvider(posterImgSrc),
              ImageMetadata(sources: [posterImgSrc]),
            )
          : null,
    );
  }

  /// Builds [WebView].
  Widget buildWebView(
    NodeMetadata meta,
    String url, {
    double height,
    double width,
  }) {
    final widget = _widget;
    if (widget?.webView != true) return buildWebViewLinkOnly(meta, url);

    final dimensOk = height != null && height > 0 && width != null && width > 0;
    return WebView(
      url,
      aspectRatio: dimensOk ? width / height : 16 / 9,
      getDimensions: !dimensOk && widget.webViewJs == true,
      interceptNavigationRequest: (newUrl) {
        if (newUrl == url) return false;

        gestureTapCallback(newUrl)();
        return true;
      },
      js: widget.webViewJs == true,
      unsupportedWorkaroundForIssue37:
          widget.unsupportedWebViewWorkaroundForIssue37 == true,
    );
  }

  /// Builds fallback link when [HtmlWidget.webView] is disabled.
  Widget buildWebViewLinkOnly(NodeMetadata meta, String url) => GestureDetector(
        child: Text(url),
        onTap: gestureTapCallback(url),
      );

  @override
  GestureTapCallback gestureTapCallback(String url) {
    if (url == null) return null;
    final callback = _widget?.onTapUrl ?? _gestureTapCallbackDefault;
    return () => callback(url);
  }

  Future<void> _gestureTapCallbackDefault(String url) async {
    final ok = await canLaunch(url);
    if (ok) return launch(url);
    print("[flutter_widget_from_html] Tapped url $url (couldn't launch)");
  }

  @override
  List<HtmlWidgetDependency> getDependencies(BuildContext context) =>
      super.getDependencies(context)
        ..add(HtmlWidgetDependency<ThemeData>(Theme.of(context)));

  /// Returns flutter_svg.[PictureProvider] or [ImageProvider].
  @override
  Object imageProvider(ImageSource imgSrc) {
    if (imgSrc == null) return super.imageProvider(imgSrc);
    final url = imgSrc.url;

    if (Uri.tryParse(url)?.path?.toLowerCase()?.endsWith('.svg') == true) {
      return _imageSvgPictureProvider(url);
    }

    if (url.startsWith('data:image/svg+xml')) {
      return _imageSvgMemoryPicture(url);
    }

    if (url.startsWith('http')) {
      return _imageFromUrl(url);
    }

    return super.imageProvider(imgSrc);
  }

  Object _imageFromUrl(String url) =>
      url?.isNotEmpty == true ? CachedNetworkImageProvider(url) : null;

  Object _imageSvgMemoryPicture(String dataUri) {
    final bytes = bytesFromDataUri(dataUri);
    return bytes != null
        ? MemoryPicture(SvgPicture.svgByteDecoder, bytes)
        : null;
  }

  Object _imageSvgPictureProvider(String url) {
    if (url?.startsWith('asset:') == true) {
      final uri = url?.isNotEmpty == true ? Uri.tryParse(url) : null;
      if (uri?.scheme != 'asset') return null;

      final assetName = uri.path;
      if (assetName?.isNotEmpty != true) return null;

      final package = uri.queryParameters?.containsKey('package') == true
          ? uri.queryParameters['package']
          : null;

      return ExactAssetPicture(
        SvgPicture.svgStringDecoder,
        assetName,
        package: package,
      );
    }

    return NetworkPicture(SvgPicture.svgByteDecoder, url);
  }

  @override
  void parse(NodeMetadata meta) {
    switch (meta.domElement.localName) {
      case 'a':
        _tsbTagA ??= (p, _) => p.copyWith(
            style: p.style
                .copyWith(color: p.getDependency<ThemeData>().accentColor));
        meta.tsb(_tsbTagA);
        break;
      case kTagIframe:
        _tagIframe ??= TagIframe(this).buildOp;
        meta.register(_tagIframe);
        // return asap to avoid being disabled by core
        return;
      case kTagSvg:
        _tagSvg ??= TagSvg(this).buildOp;
        meta.register(_tagSvg);
        // return asap to avoid being disabled by core
        return;
      case kTagVideo:
        meta.register(TagVideo(this, meta).op);
        break;
    }

    return super.parse(meta);
  }

  @override
  void reset(State<core.HtmlWidget> state) {
    _state = state;
    super.reset(state);
  }
}
