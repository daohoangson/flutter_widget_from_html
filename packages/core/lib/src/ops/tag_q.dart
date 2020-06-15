part of '../core_widget_factory.dart';

class _TagQ {
  final WidgetFactory wf;

  _TagQ(this.wf);

  BuildOp get buildOp => BuildOp(
        onPieces: (_, pieces) {
          final firstText = pieces.first?.text;
          final lastText = pieces.last?.text;
          if (firstText == lastText && firstText.isEmpty) {
            final text = firstText;
            text
              ..add(_TagQBit(text, isOpening: true))
              ..add(_TagQBit(text, isOpening: false));
            return pieces;
          }

          final firstBit = firstText?.first;
          final firstBp = firstBit?.parent;
          final lastBit = lastText?.last;
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

  @override
  String get data => isOpening ? '“' : '”';

  @override
  TextStyleBuilders get tsb => parent.tsb;
}
