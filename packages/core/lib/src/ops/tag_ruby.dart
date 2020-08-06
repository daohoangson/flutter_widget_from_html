part of '../core_widget_factory.dart';

const _kTagRuby = 'ruby';
const _kTagRp = 'rp';
const _kTagRt = 'rt';

class _TagRuby {
  final WidgetFactory wf;

  _TagRuby(this.wf);

  BuildOp get buildOp {
    if (!wf.widget.useWidgetSpan) return null;

    TextBits rtText;

    return BuildOp(
      onChild: (meta, e) {
        switch (e.localName) {
          case _kTagRp:
            meta.styles = [_kCssDisplay, _kCssDisplayNone];
            break;
          case _kTagRt:
            meta
              ..op = BuildOp(
                onPieces: (_, pieces) {
                  for (final piece in pieces) {
                    if (piece.hasWidgets) continue;
                    rtText = piece.text..detach();
                    break;
                  }

                  return [];
                },
              )
              ..styles = [_kCssFontSize, '0.5em'];
            break;
        }

        return meta;
      },
      onPieces: (_, pieces) => pieces.map((piece) {
        if (piece.hasWidgets || rtText == null) return piece;
        final _rtText = rtText;
        rtText = null;

        final rtBuilt = wf.buildText(_rtText);
        if (rtBuilt == null) return piece;

        final text = piece.text;
        final built = wf.buildText(text);
        if (built == null) return piece;

        final parent = text.parent;
        final replacement = parent.sub(text.tsb)..detach();
        text.replaceWith(replacement);

        replacement.add(_buildTextBit(parent, built, rtBuilt, _rtText.tsb));

        return BuiltPiece.text(replacement);
      }),
    );
  }

  TextBit _buildTextBit(
    TextBits parent,
    Widget ruby,
    Widget rt,
    TextStyleBuilder rtTsb,
  ) =>
      TextWidget(
        parent,
        WidgetPlaceholder<_TagRuby>(builder: (context, _, __) {
          final rtTsh = rtTsb.build(context);
          final padding = EdgeInsets.symmetric(
              vertical: rtTsh.style.fontSize *
                  .75 *
                  MediaQuery.of(context).textScaleFactor);

          return [
            Stack(
              children: <Widget>[
                wf.buildPadding(ruby, padding),
                Positioned(
                  child: Center(child: rt),
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
