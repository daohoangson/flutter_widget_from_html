part of '../core_wf.dart';

class TagA {
  final WidgetFactory wf;

  TagA(this.wf);

  BuildOp get buildOp => BuildOp(
        collectMetadata: (meta) => lazySet(meta, decorationUnderline: true),
        onPieces: (meta, pieces) {
          final tap = _buildGestureTapCallback(meta);
          if (tap == null) return pieces;

          return pieces.map(
            (p) => p.hasWidgets
                ? BuiltPieceSimple(widgets: <Widget>[_buildGd(p.widgets, tap)])
                : _buildBlock(p, tap),
          );
        },
      );

  BuiltPiece _buildBlock(BuiltPiece piece, GestureTapCallback onTap) =>
      piece..block.rebuildBits((bit) => bit.rebuild(onTap: onTap));

  Widget _buildGd(List<Widget> widgets, GestureTapCallback onTap) =>
      wf.buildGestureDetector(wf.buildColumn(widgets), onTap);

  GestureTapCallback _buildGestureTapCallback(NodeMetadata meta) {
    final attrs = meta.buildOpElement.attributes;
    final href = attrs.containsKey('href') ? attrs['href'] : '';
    final url = wf.constructFullUrl(href) ?? href;
    return wf.buildGestureTapCallbackForUrl(url);
  }
}
