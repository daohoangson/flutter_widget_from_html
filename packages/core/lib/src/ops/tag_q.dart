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
          TextBit firstBit;
          first.forEachBit((bit, i) {
            firstBit ??= bit;

            if (!bit.hasTrailingSpace) {
              final bb = bit.block;
              bb.addBit(DataBit(bb, kTagQOpening, bb.tsb), index: i);
              addedOpening = true;
              return false;
            }

            return null;
          });

          var addedClosing = false;
          TextBit lastBit;
          last.forEachBit((bit, i) {
            lastBit ??= bit;

            if (!bit.hasTrailingSpace) {
              final bb = bit.block;
              bb.addBit(DataBit(bb, kTagQClosing, bb.tsb), index: i + 1);
              addedClosing = true;
              return false;
            }

            return null;
          }, reversed: true);

          if (!addedOpening) {
            first.addBit(DataBit(first, kTagQOpening, first.tsb), index: 0);
            if (firstBit?.hasTrailingSpace == true)
              first.addBit(SpaceBit(first), index: 0);
          }
          if (!addedClosing) {
            last.addText(kTagQClosing);
            if (lastBit?.hasTrailingSpace == true) last.addBit(SpaceBit(last));
          }

          return pieces;
        },
      );
}
