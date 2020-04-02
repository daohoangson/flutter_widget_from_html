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
      onPieces: (_, pieces) {
        for (final piece in pieces) {
          if (rtText == null) continue;
          final _rtText = rtText;
          rtText = null;

          final text = piece.text;
          final cloned = text.clone(parent: text.parent);
          TextBits.trimRight(cloned);
          if (cloned.isEmpty) break;

          text.children
            ..clear()
            ..add(_buildWidgetBit(text, cloned, _rtText));
        }

        return pieces;
      },
    );
  }

  TextBit _buildWidgetBit(TextBits parent, TextBits ruby, TextBits rt) =>
      _WidgetBit(
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
