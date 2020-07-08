import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart'
    as core;
import 'package:url_launcher/url_launcher.dart';

import 'builder.dart';
import 'data.dart';
import 'helpers.dart';
import 'html_widget.dart';

part 'ops/tag_a_extended.dart';
part 'ops/tag_iframe.dart';
part 'ops/tag_svg.dart';
part 'ops/tag_video.dart';

/// A factory to build widget for HTML elements
/// with support for [WebView] and [VideoPlayer] etc.
class WidgetFactory extends core.WidgetFactory {
  BuildOp _tagAExtended;
  BuildOp _tagIframe;
  BuildOp _tagSvg;
  BuildOp _tagVideo;
  HtmlWidget _widget;

  @override
  Widget buildDivider() => const Divider(height: 1);

  @override
  Iterable<Widget> buildGestureDetectors(
    BuildContext _,
    Iterable<Widget> widgets,
    GestureTapCallback onTap,
  ) =>
      widgets?.map((widget) => InkWell(child: widget, onTap: onTap));

  @override
  GestureTapCallback buildGestureTapCallbackForUrl(String url) {
    if (url == null) return null;
    if (_widget?.onTapUrl == null) {
      return () => canLaunch(url).then((ok) => ok ? launch(url) : null);
    }
    return () => _widget.onTapUrl(url);
  }

  @override
  ImageProvider buildImageFromUrl(String url) =>
      url?.isNotEmpty == true ? CachedNetworkImageProvider(url) : null;

  @override
  Widget buildTable(TableData table) {
    final cols = table.cols;
    final templateColumnSizes = List<TrackSize>(cols);
    for (var c = 0; c < cols; c++) {
      templateColumnSizes[c] = const FlexibleTrackSize(1);
    }

    final rows = table.rows;
    final templateRowSizes = List<TrackSize>(rows);
    for (var r = 0; r < rows; r++) {
      templateRowSizes[r] = const IntrinsicContentTrackSize();
    }

    final border = table.border != null
        ? BoxDecoration(border: Border.fromBorderSide(table.border))
        : null;

    final layoutGrid = LayoutGrid(
      children: table.slots.map((slot) {
        Widget cell = SizedBox.expand(child: buildColumn(slot.cell.children));

        if (border != null) {
          cell = Container(
            child: cell,
            decoration: border,
          );
        }

        return GridPlacement(
          columnStart: slot.col,
          columnSpan: slot.cell.colspan,
          rowStart: slot.row,
          rowSpan: slot.cell.rowspan,
          child: cell,
        );
      }).toList(growable: false),
      gap: -(table.border?.width ?? 0),
      templateColumnSizes: templateColumnSizes,
      templateRowSizes: templateRowSizes,
    );

    if (border == null) return layoutGrid;

    return Stack(
      children: <Widget>[
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
      poster: posterUrl != null ? buildImage(posterUrl) : null,
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
  void parseTag(
    NodeMetadata meta,
    String tag,
    Map<dynamic, String> attributes,
  ) {
    switch (tag) {
      case 'a':
        meta.op = tagAExtended();
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
        meta.op = tagVideo();
        break;
    }

    return super.parseTag(meta, tag, attributes);
  }

  @override
  void reset(core.HtmlWidget widget) {
    if (widget is HtmlWidget) _widget = widget;
    super.reset(widget);
  }

  BuildOp tagAExtended() {
    _tagAExtended ??= _TagAExtended().buildOp;
    return _tagAExtended;
  }

  BuildOp tagIframe() {
    _tagIframe ??= _TagIframe(this).buildOp;
    return _tagIframe;
  }

  BuildOp tagSvg() {
    _tagSvg ??= _TagSvg(this).buildOp;
    return _tagSvg;
  }

  BuildOp tagVideo() {
    _tagVideo ??= _TagVideo(this).buildOp;
    return _tagVideo;
  }
}
