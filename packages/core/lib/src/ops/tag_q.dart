part of '../core_widget_factory.dart';

const kTagQ = 'q';
const kTagQOpening = '“';
const kTagQClosing = '”';

class _TagQ {
  final WidgetFactory wf;

  _TagQ(this.wf);

  BuildOp get buildOp => BuildOp(
        onPieces: (_, pieces) {
          final firstBlock = pieces.first?.block;
          final lastBlock = pieces.last?.block;
          if (firstBlock == lastBlock && firstBlock.isEmpty) {
            final block = firstBlock;
            block.addBit(DataBit(block, kTagQOpening, block.tsb));
            block.addBit(DataBit(block, kTagQClosing, block.tsb));
            return pieces;
          }

          final firstBit = firstBlock?.first;
          final firstBp = firstBit?.parent;
          final lastBit = lastBlock?.last;
          final lastBp = lastBit?.parent;

          if (firstBp != null && lastBp != null) {
            DataBit(firstBp, kTagQOpening, firstBp.tsb).insertBefore(firstBit);
            DataBit(lastBp, kTagQClosing, lastBp.tsb).insertAfter(lastBit);
          }

          return pieces;
        },
      );
}
