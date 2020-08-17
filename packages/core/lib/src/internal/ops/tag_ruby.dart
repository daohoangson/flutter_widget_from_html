part of '../core_ops.dart';

const kTagRuby = 'ruby';
const kTagRp = 'rp';
const kTagRt = 'rt';

class TagRuby {
  final NodeMetadata rubyMeta;
  final WidgetFactory wf;

  BuildOp _rubyOp;
  BuildOp _rtOp;
  TextBits _rtText;

  TagRuby(this.wf, this.rubyMeta);

  BuildOp get op {
    _rubyOp ??= BuildOp(
      onChild: onChild,
      onPieces: onPieces,
    );
    return _rubyOp;
  }

  void onChild(NodeMetadata childMeta) {
    final e = childMeta.domElement;
    if (e.parent != rubyMeta.domElement) return;

    switch (e.localName) {
      case kTagRp:
        childMeta[kCssDisplay] = kCssDisplayNone;
        break;
      case kTagRt:
        _rtOp ??= BuildOp(
          onPieces: (_, pieces) {
            for (final piece in pieces) {
              if (piece.hasWidgets) continue;
              _rtText = piece.text..detach();
            }

            return [];
          },
        );

        childMeta
          ..[kCssFontSize] = '0.5em'
          ..register(_rtOp);
        break;
    }
  }

  Iterable<BuiltPiece> onPieces(
      NodeMetadata meta, Iterable<BuiltPiece> pieces) {
    if (_rtText == null) return pieces;
    var processed = false;

    return pieces.map((piece) {
      if (piece.hasWidgets || processed) return piece;
      processed = true;

      final rtBuilt = wf.buildText(meta, _rtText);
      if (rtBuilt == null) return piece;

      final text = piece.text;
      final built = wf.buildText(meta, text);
      if (built == null) return piece;

      final parent = text.parent;
      final replacement = parent.sub(text.tsb)..detach();
      text.replaceWith(replacement);

      replacement.add(_buildTextBit(parent, built, rtBuilt));

      return BuiltPiece.text(replacement);
    }).toList(growable: false);
  }

  TextBit _buildTextBit(TextBits parent, Widget ruby, Widget rt) {
    final tsh = _rtText.tsb.build();
    final padding = tsh.style.fontSize *
        .75 *
        tsh.deps.getValue<MediaQueryData>().textScaleFactor;

    final widget = WidgetPlaceholder<NodeMetadata>(
      child: wf.buildStack(
        rubyMeta,
        <Widget>[
          wf.buildPadding(
              rubyMeta, ruby, EdgeInsets.symmetric(vertical: padding)),
          Positioned.fill(bottom: null, child: Center(child: rt)),
        ],
      ),
      generator: rubyMeta,
    );

    return TextWidget(parent, widget, alignment: PlaceholderAlignment.middle);
  }
}
