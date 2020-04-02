part of '../core_widget_factory.dart';

class _TagQ {
  final WidgetFactory wf;

  _TagQ(this.wf);

  BuildOp get buildOp => BuildOp(
        onPieces: (_, pieces) {
          final firstBlock = pieces.first?.block;
          final lastBlock = pieces.last?.block;
          if (firstBlock == lastBlock && firstBlock.isEmpty) {
            final block = firstBlock;
            block.add(_TagQBit(block, isOpening: true));
            block.add(_TagQBit(block, isOpening: false));
            return pieces;
          }

          final firstBit = firstBlock?.first;
          final firstBp = firstBit?.parent;
          final lastBit = lastBlock?.last;
          final lastBp = lastBit?.parent;

          if (firstBp != null && lastBp != null) {
            _TagQBit(firstBp, isOpening: true).insertBefore(firstBit);
            _TagQBit(lastBp, isOpening: false).insertAfter(lastBit);
          }

          return pieces;
        },
      );
}

class _TagQBit extends TextBit {
  final bool isOpening;

  _TagQBit(TextBits parent, {@required this.isOpening}) : super(parent);

  String get data => isOpening ? '“' : '”';

  TextStyleBuilders get tsb => parent.tsb;

  @override
  _TagQBit clone({TextBits parent}) => _TagQBit(parent, isOpening: isOpening);
}
