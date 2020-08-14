part of '../core_widget_factory.dart';

const _kTagRuby = 'ruby';
const _kTagRp = 'rp';
const _kTagRt = 'rt';

class _TagRuby {
  final NodeMetadata rubyMeta;
  final WidgetFactory wf;

  BuildOp _rubyOp;
  BuildOp _rtOp;
  TextBits _rtText;

  _TagRuby(this.wf, this.rubyMeta);

  BuildOp get op {
    _rubyOp ??= BuildOp(
      onChild: onChild,
      onPieces: onPieces,
    );
    return _rubyOp;
  }

  void onChild(NodeMetadata childMeta, dom.Element e) {
    if (e.parent != rubyMeta.domElement) return;

    switch (e.localName) {
      case _kTagRp:
        childMeta.addStyle(_kCssDisplay, _kCssDisplayNone);
        break;
      case _kTagRt:
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
          ..addStyle(_kCssFontSize, '0.5em')
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

      final replacement = text.parent.sub(text.tsb)..detach();
      text.replaceWith(replacement);
      replacement.add(_buildTextBit(replacement, built, rtBuilt));

      return BuiltPiece.text(replacement);
    }).toList(growable: false);
  }

  TextBit _buildTextBit(TextBits parent, Widget ruby, Widget rt) {
    final tsh = _rtText.tsb.build();
    final padding = tsh.style.fontSize *
        .75 *
        tsh.getDependency<MediaQueryData>().textScaleFactor;

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
