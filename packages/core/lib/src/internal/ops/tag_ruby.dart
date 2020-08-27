part of '../core_ops.dart';

const kTagRuby = 'ruby';
const kTagRp = 'rp';
const kTagRt = 'rt';

class TagRuby {
  final BuildMetadata rubyMeta;
  final WidgetFactory wf;

  BuildOp _rubyOp;
  BuildOp _rtOp;

  TagRuby(this.wf, this.rubyMeta);

  BuildOp get op {
    _rubyOp ??= BuildOp(onChild: onChild, onPieces: onPieces);
    return _rubyOp;
  }

  void onChild(BuildMetadata childMeta) {
    final e = childMeta.element;
    if (e.parent != rubyMeta.element) return;

    switch (e.localName) {
      case kTagRp:
        childMeta[kCssDisplay] = kCssDisplayNone;
        break;
      case kTagRt:
        _rtOp ??= BuildOp(
          onPieces: (rtMeta, pieces) {
            // assume that the first piece is always a text piece
            // this is a fairly dangerous assumption
            final text = pieces.first.text;

            for (final _ in text.bits) {
              // RT tag contains something!
              text.replaceWith(_RtBit(rtMeta, text));

              // keep the first piece only for now (TODO?)
              return [pieces.first];
            }

            // RT tag is empty, do nothing
            return pieces;
          },
        );

        childMeta
          ..[kCssFontSize] = '0.5em'
          ..register(_rtOp);
        break;
    }
  }

  Iterable<BuiltPiece> onPieces(BuildMetadata _, Iterable<BuiltPiece> pieces) {
    for (final piece in pieces) {
      if (piece.text == null) continue;

      final prev = <TextBit>[];
      final bits = piece.text.bits.toList(growable: false);
      for (final bit in bits) {
        if (prev.isEmpty && bit.tsb == null) {
          // the first bit is whitespace, just ignore it
          continue;
        }
        if (bit is! _RtBit || prev.isEmpty) {
          prev.add(bit);
          continue;
        }

        final rt = bit as _RtBit;
        final prevFirst = prev.first;

        final rubyBits = TextBits(prevFirst.tsb);
        final placeholder = WidgetPlaceholder<TextBits>(rubyBits)
          ..wrapWith((_, __) => _RubyWidget(
                wf.buildText(rubyMeta, rubyBits) ?? widget0,
                wf.buildText(rt.rtMeta, rt.bits) ?? widget0,
              ));
        final replacement = TextWidget(prevFirst.parent, placeholder,
            alignment: PlaceholderAlignment.middle);
        prevFirst.replaceWith(replacement);

        for (final prevBit in prev) {
          rubyBits.add(prevBit.copyWith(parent: rubyBits));
          prevBit.detach();
        }
        bit.detach();
        prev.clear();
      }
    }

    return pieces;
  }
}

class _RubyWidget extends MultiChildRenderObjectWidget {
  final Widget ruby;
  final Widget rt;

  _RubyWidget(this.ruby, this.rt, {Key key})
      : super(children: [ruby, rt], key: key);

  @override
  RenderObject createRenderObject(BuildContext _) => _RubyRenderObject();
}

class _RubyParentData extends ContainerBoxParentData<RenderBox> {}

class _RubyRenderObject extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _RubyParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _RubyParentData> {
  @override
  double computeDistanceToActualBaseline(TextBaseline baseline) =>
      defaultComputeDistanceToHighestActualBaseline(baseline);

  @override
  double computeMaxIntrinsicHeight(double width) {
    final ruby = firstChild;
    final rubyValue = ruby.computeMaxIntrinsicHeight(width);

    final rt = (ruby.parentData as _RubyParentData).nextSibling;
    final rtValue = rt.computeMaxIntrinsicHeight(width);

    return rubyValue + 2 * rtValue;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    final ruby = firstChild;
    final rubyValue = ruby.computeMaxIntrinsicWidth(height);

    final rt = (ruby.parentData as _RubyParentData).nextSibling;
    final rtValue = rt.computeMaxIntrinsicWidth(height);

    return max(rubyValue, rtValue);
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    final ruby = firstChild;
    final rubyValue = ruby.computeMinIntrinsicHeight(width);

    final rt = (ruby.parentData as _RubyParentData).nextSibling;
    final rtValue = rt.computeMinIntrinsicHeight(width);

    return rubyValue + 2 * rtValue;
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    final ruby = firstChild;
    final rubyValue = ruby.getMinIntrinsicWidth(height);

    final rt = (ruby.parentData as _RubyParentData).nextSibling;
    final rtValue = rt.getMinIntrinsicWidth(height);

    return min(rubyValue, rtValue);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }

  @override
  void performLayout() {
    final ruby = firstChild;
    final rubyData = ruby.parentData as _RubyParentData;
    ruby.layout(constraints, parentUsesSize: true);
    final rubySize = ruby.size;

    final rt = rubyData.nextSibling;
    final rtData = rt.parentData as _RubyParentData;
    rt.layout(constraints, parentUsesSize: true);
    final rtSize = rt.size;

    size = Size(
      max(rubySize.width, rtSize.width),
      rubySize.height + 2 * rtSize.height,
    );

    rubyData.offset = Offset((size.width - rubySize.width) / 2, rtSize.height);
    rtData.offset = Offset((size.width - rtSize.width) / 2, 0);
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _RubyParentData) {
      child.parentData = _RubyParentData();
    }
  }
}

class _RtBit extends TextBit<void, void> {
  final TextBits bits;
  final BuildMetadata rtMeta;

  _RtBit(this.rtMeta, this.bits, {TextBits parent, TextStyleBuilder tsb})
      : super(parent ?? bits.parent, tsb ?? bits.tsb);

  @override
  void compile(void _) => null;

  @override
  TextBit copyWith({TextBits parent, TextStyleBuilder tsb}) =>
      _RtBit(rtMeta, bits, parent: parent ?? this.parent, tsb: tsb ?? this.tsb);
}
