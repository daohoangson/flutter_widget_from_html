import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart'
    as core;
import 'package:html/dom.dart' as dom;
import 'package:url_launcher/url_launcher.dart';

import 'data.dart';
import 'helpers.dart';
import 'html_widget.dart';

part 'ops/tag_a_enhanced.dart';
part 'ops/tag_iframe.dart';
part 'ops/tag_svg.dart';
part 'ops/tag_video.dart';

/// A factory to build widget for HTML elements
/// with support for [WebView] and [VideoPlayer] etc.
class WidgetFactory extends core.WidgetFactory {
  BuildOp _tagIframe;
  BuildOp _tagSvg;
  HtmlWidget _widget;

  @override
  Widget buildDivider() => const Divider(height: 1);

  @override
  Widget buildGestureDetector(Widget child, GestureTapCallback onTap) =>
      InkWell(child: child, onTap: onTap);

  @override
  GestureTapCallback buildGestureTapCallbackForUrl(String url) {
    if (url == null) return null;
    final callback = _widget?.onTapUrl ?? _defaultGestureTapCallbackForUrl;
    return () => callback(url);
  }

  Future<void> _defaultGestureTapCallbackForUrl(String url) async {
    final ok = await canLaunch(url);
    if (ok) return launch(url);
    print("[flutter_widget_from_html] Tapped url $url (couldn't launch)");
  }

  @override
  Widget buildImage(Object provider, ImgMetadata img) {
    var built = super.buildImage(provider, img);

    if (built == null && provider is PictureProvider) {
      built = SvgPicture(provider);
    }

    if (img.title != null && built != null) {
      built = Tooltip(child: built, message: img.title);
    }

    return built;
  }

  @override
  Object buildImageProvider(String url) =>
      url?.startsWith('data:image/svg+xml') == true
          ? buildSvgMemoryPicture(url)
          : url != null &&
                  Uri.tryParse(url)?.path?.toLowerCase()?.endsWith('.svg') ==
                      true
              ? buildSvgPictureProvider(url)
              : super.buildImageProvider(url);

  PictureProvider buildSvgMemoryPicture(String dataUri) {
    final bytes = buildImageBytes(dataUri);
    return bytes != null
        ? MemoryPicture(SvgPicture.svgByteDecoder, bytes)
        : null;
  }

  PictureProvider buildSvgPictureProvider(String url) {
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
  ImageProvider buildImageFromUrl(String url) =>
      url?.isNotEmpty == true ? CachedNetworkImageProvider(url) : null;

  @override
  Widget buildTable(NodeMetadata meta, TableData table) {
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

    final layoutGrid = LayoutGrid(
      children: table.slots.map((slot) {
        Widget cell = SizedBox.expand(child: slot.cell.child);

        if (border != null) {
          cell = Container(
            child: cell,
            decoration: border,
          );
        }

        return cell.withGridPlacement(
          columnStart: slot.col,
          columnSpan: slot.cell.colspan,
          rowStart: slot.row,
          rowSpan: slot.cell.rowspan,
        );
      }).toList(growable: false),
      columnGap: -(table.border?.width ?? 0),
      gridFit: GridFit.passthrough,
      rowGap: -(table.border?.width ?? 0),
      templateColumnSizes: templateColumnSizes,
      templateRowSizes: templateRowSizes,
    );

    if (border == null) return layoutGrid;

    return buildStack(
      meta,
      <Widget>[
        layoutGrid,
        Positioned.fill(child: Container(decoration: border))
      ],
    );
  }

  Widget buildVideoPlayer(
    String url, {
    bool autoplay,
    bool controls,
    double height,
    bool loop,
    String posterUrl,
    double width,
  }) {
    final dimensOk = height != null && height > 0 && width != null && width > 0;
    return VideoPlayer(
      url,
      aspectRatio: dimensOk ? width / height : 16 / 9,
      autoResize: !dimensOk,
      autoplay: autoplay,
      controls: controls,
      loop: loop,
      poster: posterUrl != null
          ? buildImage(
              buildImageProvider(posterUrl),
              ImgMetadata(url: posterUrl),
            )
          : null,
    );
  }

  Widget buildWebView(
    String url, {
    double height,
    double width,
  }) {
    if (_widget?.webView != true) return buildWebViewLinkOnly(url);

    final dimensOk = height != null && height > 0 && width != null && width > 0;
    return WebView(
      url,
      aspectRatio: dimensOk ? width / height : 16 / 9,
      getDimensions: !dimensOk && _widget.webViewJs == true,
      interceptNavigationRequest: (newUrl) {
        if (newUrl == url) return false;

        buildGestureTapCallbackForUrl(newUrl)();
        return true;
      },
      js: _widget.webViewJs == true,
      unsupportedWorkaroundForIssue37:
          _widget.unsupportedWebViewWorkaroundForIssue37 == true,
    );
  }

  Widget buildWebViewLinkOnly(String url) => GestureDetector(
        child: Text(url),
        onTap: buildGestureTapCallbackForUrl(url),
      );

  @override
  List<HtmlWidgetDependency> getDependencies(BuildContext context) =>
      super.getDependencies(context)
        ..add(HtmlWidgetDependency<ThemeData>(Theme.of(context)));

  @override
  void parseTag(
    NodeMetadata meta,
    String tag,
    Map<dynamic, String> attributes,
  ) {
    switch (tag) {
      case 'a':
        meta.tsb(_TagAEnhanced.setAccentColor);
        break;
      case 'iframe':
        meta.op = tagIframe();
        // return asap to avoid being disabled by core
        return;
      case 'svg':
        meta.op = tagSvg();
        // return asap to avoid being disabled by core
        return;
      case 'video':
        meta.op = tagVideo(meta);
        break;
    }

    return super.parseTag(meta, tag, attributes);
  }

  @override
  void reset(core.HtmlWidget widget) {
    if (widget is HtmlWidget) _widget = widget;
    super.reset(widget);
  }

  BuildOp tagIframe() {
    _tagIframe ??= _TagIframe(this).buildOp;
    return _tagIframe;
  }

  BuildOp tagSvg() {
    _tagSvg ??= _TagSvg(this).buildOp;
    return _tagSvg;
  }

  BuildOp tagVideo(NodeMetadata meta) => _TagVideo(this, meta);
}
