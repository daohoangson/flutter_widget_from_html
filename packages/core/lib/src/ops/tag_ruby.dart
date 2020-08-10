part of '../core_widget_factory.dart';

const _kTagRuby = 'ruby';
const _kTagRp = 'rp';
const _kTagRt = 'rt';

class _TagRuby extends BuildOp {
  final NodeMetadata rubyMeta;
  final WidgetFactory wf;

  BuildOp _rtOp;
  TextBits _rtText;

  _TagRuby(this.wf, this.rubyMeta);

  @override
  bool get hasOnChild => true;

  @override
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
          ..op = _rtOp
          ..addStyle(_kCssFontSize, '0.5em');
        break;
    }
  }

  @override
  Iterable<BuiltPiece> onPieces(
    NodeMetadata meta,
    Iterable<BuiltPiece> pieces,
  ) {
    if (_rtText == null) return pieces;
    var processed = false;

    return pieces.map((piece) {
      if (piece.hasWidgets || processed) return piece;
      processed = true;

      final rtBuilt = wf.buildText(_rtText);
      if (rtBuilt == null) return piece;

      final text = piece.text;
      final built = wf.buildText(text);
      if (built == null) return piece;

      final parent = text.parent;
      final replacement = parent.sub(text.tsb)..detach();
      text.replaceWith(replacement);

      replacement.add(_buildTextBit(parent, built, rtBuilt));

      return BuiltPiece.text(replacement);
    }).toList(growable: false);
  }

  TextBit _buildTextBit(
    TextBits parent,
    Widget ruby,
    Widget rt,
  ) =>
      TextWidget(
        parent,
        WidgetPlaceholder<_TagRuby>(
          child: Builder(
            builder: (context) => Stack(
              children: <Widget>[
                wf.buildPadding(
                  ruby,
                  EdgeInsets.symmetric(
                    vertical: _rtText.tsb.build(context).style.fontSize *
                        .75 *
                        MediaQuery.of(context).textScaleFactor,
                  ),
                ),
                Positioned.fill(bottom: null, child: Center(child: rt)),
              ],
              overflow: Overflow.visible,
            ),
          ),
          generator: this,
        ),
        alignment: PlaceholderAlignment.middle,
      );
}
