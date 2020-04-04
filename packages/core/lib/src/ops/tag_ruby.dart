part of '../core_widget_factory.dart';

const kTagRuby = 'ruby';
const kTagRp = 'rp';
const kTagRt = 'rt';

class _TagRuby {
  final WidgetFactory wf;

  _TagRuby(this.wf);

  BuildOp get buildOp {
    TextBits rtText;

    return BuildOp(
      onChild: (meta, e) {
        switch (e.localName) {
          case kTagRp:
            meta = lazySet(meta, styles: [kCssDisplay, kCssDisplayNone]);
            break;
          case kTagRt:
            meta = lazySet(
              meta,
              buildOp: BuildOp(
                onPieces: (_, pieces) {
                  for (final piece in pieces) {
                    if (piece.hasWidgets) continue;
                    rtText = piece.text..detach();
                    break;
                  }

                  return [];
                },
              ),
              styles: [kCssFontSize, '0.5em'],
            );
            break;
        }

        return meta;
      },
      onPieces: (_, pieces) => pieces.map((piece) {
        if (piece.hasWidgets || rtText == null) return piece;
        final _rtText = rtText;
        rtText = null;

        final text = piece.text..trimRight();
        if (text.isEmpty) return piece;

        final parent = text.parent;
        final replacement = parent.sub(text.tsb)..detach();
        text.replaceWith(replacement);

        replacement.add(_buildWidgetBit(parent, text, _rtText));

        return BuiltPieceSimple(text: replacement);
      }),
    );
  }

  TextBit _buildWidgetBit(TextBits parent, TextBits ruby, TextBits rt) =>
      WidgetBit(
        parent,
        WidgetPlaceholder<_TagRuby>(builder: (bc, _, __) {
          final rubyText = wf.buildText(bc, null, ruby);
          final rtText = wf.buildText(bc, null, rt);
          final rtStyle = rt.tsb.build(bc);
          final padding = EdgeInsets.symmetric(
              vertical: rtStyle.fontSize *
                  .75 *
                  MediaQuery.of(bc.context).textScaleFactor);

          return [
            Stack(
              children: <Widget>[
                wf.buildPadding(wf.buildColumn(rubyText), padding),
                Positioned(
                  child: Center(child: wf.buildColumn(rtText)),
                  left: 0,
                  right: 0,
                  top: 0,
                ),
              ],
              overflow: Overflow.visible,
            )
          ];
        }),
        alignment: PlaceholderAlignment.middle,
      );
}
