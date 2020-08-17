part of '../core_ops.dart';

const kTagQ = 'q';

class TagQ {
  final WidgetFactory wf;

  TagQ(this.wf);

  BuildOp get buildOp => BuildOp(
        onPieces: (_, pieces) => _wrapTextBits(
          pieces,
          appendBuilder: (parent) => _TagQBit(parent, isOpening: false),
          prependBuilder: (parent) => _TagQBit(parent, isOpening: true),
        ),
      );
}

class _TagQBit extends TextBit {
  final bool isOpening;

  _TagQBit(TextBits parent, {@required this.isOpening}) : super(parent);

  @override
  String get data => isOpening ? '“' : '”';

  @override
  TextStyleBuilder get tsb => parent.tsb;
}
