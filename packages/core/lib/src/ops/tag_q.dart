part of '../core_helpers.dart';

const kTagQ = 'q';

class TagQ {
  final WidgetFactory wf;

  TagQ(this.wf);

  BuildOp get buildOp => BuildOp(
        onPieces: (_, pieces) {
          final first = pieces.first.block;
          if (first?.isNotEmpty != true) return pieces;

          final last = pieces.last.block;
          if (last?.isNotEmpty != true) return pieces;
          final lastHasTrailingSpace = last.iterable.last.isSpace;

          first.rebuildBits(
            (firstBit) => firstBit.rebuild(
                  data: firstBit.isSpace ? ' “' : '“${firstBit.data}',
                  style: firstBit.style ?? first.style,
                ),
            start: first.indexStart,
            end: first.indexStart + 1,
          );

          last.rebuildBits(
            (lastBit) => lastBit.rebuild(
                  data: (lastBit.data ?? '') + '”',
                  style: lastBit.style ?? last.style,
                ),
            start: last.indexEnd - 1,
            end: last.indexEnd,
          );

          if (lastHasTrailingSpace) {
            last.addSpace();
          }

          return pieces;
        },
      );
}
