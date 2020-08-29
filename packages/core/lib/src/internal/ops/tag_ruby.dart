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
    _rubyOp ??= BuildOp(onChild: onChild, onProcessed: onProcessed);
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
          onProcessed: (rtMeta, rtTree) {
            if (rtTree.isEmpty) return;
            final rtBit = _RtBit(rtTree, rtTree.tsb, rtMeta, rtTree.copyWith());
            rtTree.replaceWith(rtBit);
          },
        );

        childMeta
          ..[kCssFontSize] = '0.5em'
          ..register(_rtOp);
        break;
    }
  }

  void onProcessed(BuildMetadata _, BuildTree tree) {
    final rubyBits = <BuildBit>[];
    for (final bit in tree.bits.toList(growable: false)) {
      if (rubyBits.isEmpty && bit.tsb == null) {
        // the first bit is whitespace, just ignore it
        continue;
      }
      if (bit is! _RtBit || rubyBits.isEmpty) {
        rubyBits.add(bit);
        continue;
      }

      final rtBit = bit as _RtBit;
      final rubyTree = tree.sub(tree.tsb);
      final placeholder =
          WidgetPlaceholder<List<BuildTree>>([rubyTree, rtBit.tree])
            ..wrapWith((context, __) {
              final tsh = rubyTree.tsb.build(context);

              final ruby = wf.buildColumnWidget(
                  rubyMeta, tsh, rubyTree.build().toList(growable: false));
              final rt = wf.buildColumnWidget(
                  rtBit.meta, tsh, rtBit.tree.build().toList(growable: false));

              return _RubyWidget(ruby ?? widget0, rt ?? widget0);
            });

      final anchorBit = rubyBits.first;
      WidgetBit.inline(anchorBit.parent, placeholder,
              alignment: PlaceholderAlignment.middle)
          .insertBefore(anchorBit);

      for (final rubyBit in rubyBits) {
        rubyTree.add(rubyBit.copyWith(parent: rubyTree));
        rubyBit.detach();
      }
      rubyBits.clear();
      rtBit.detach();
    }
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
  bool hitTestChildren(BoxHitTestResult result, {Offset position}) =>
      defaultHitTestChildren(result, position: position);

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

class _RtBit extends BuildBit<Null> {
  final BuildMetadata meta;
  final BuildTree tree;

  _RtBit(BuildTree parent, TextStyleBuilder tsb, this.meta, this.tree)
      : super(parent, tsb);

  @override
  void buildBit(Null _) => '';

  @override
  BuildBit copyWith({BuildTree parent, TextStyleBuilder tsb}) =>
      _RtBit(parent ?? this.parent, tsb ?? this.tsb, meta, tree);
}
