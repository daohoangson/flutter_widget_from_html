part of '../core_widget_factory.dart';

const kTagQ = 'q';
const kTagQOpening = '“';
const kTagQClosing = '”';

class _TagQ {
  final WidgetFactory wf;

  _TagQ(this.wf);

  BuildOp get buildOp => BuildOp(
        onPieces: (_, pieces) {
          final first = pieces.first.block;
          if (first?.isNotEmpty != true) return pieces;

          final last = pieces.last.block;
          if (last?.isNotEmpty != true) return pieces;

          var addedOpening = false;
          var addedClosing = false;
          first.forEachBit((bit, i) {
            if (!bit.isSpace) {
              final bb = bit.block;
              bb.addBit(TextBit.text(bb, kTagQOpening, bb.style), index: i);
              addedOpening = true;
              return false;
            }

            return null;
          });
          if (!addedOpening)
            first.addBit(
              TextBit.text(first, kTagQOpening, first.style),
              index: 0,
            );

          last.forEachBit((bit, i) {
            if (!bit.isSpace) {
              final bb = bit.block;
              bb.addBit(TextBit.text(bb, kTagQClosing, bb.style), index: i + 1);
              addedClosing = true;
              return false;
            }

            return null;
          }, reversed: true);
          if (!addedClosing) last.addText(kTagQClosing);

          return pieces;
        },
      );
}
