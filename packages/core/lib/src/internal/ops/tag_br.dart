part of '../core_ops.dart';

const kTagBr = 'br';

extension TagBr on WidgetFactory {
  BuildOp get tagBr => const BuildOp.v2(
        debugLabel: kTagBr,
        onParsed: _onParsed,
        priority: Priority.tagBr,
      );

  static BuildTree _onParsed(BuildTree tree) => tree..append(TagBrBit(tree));
}

class TagBrBit extends BuildBit {
  @override
  final BuildTree parent;

  const TagBrBit(this.parent);

  @override
  bool? get swallowWhitespace => true;

  @override
  BuildBit copyWith({BuildTree? parent}) => TagBrBit(parent ?? this.parent);

  @override
  void flatten(Flattened f) {
    final next = _nextNonWhitespace;
    if (next != null && next.isInline == false) {
      // Keep behavior of skipping a single BR before a block, but convert
      // additional BRs to vertical spacing outside RichText to avoid
      // WidgetSpan line-metric artifacts.
      final prev = _prevNonWhitespace;
      if (prev is TagBrBit || prev?.isInline == false) {
        const oneEm = CssLength(1, CssLengthUnit.em);
        f.widget(
          HeightPlaceholder(
            oneEm,
            parent.inheritanceResolvers,
            debugLabel: '${parent.element.localName}--$oneEm',
          ),
        );
      }
      return;
    }

    f.write(text: '\n');
  }

  BuildBit? get _nextNonWhitespace {
    var next = this.next;
    while (next is WhitespaceBit) {
      next = next.next;
    }
    return next;
  }

  BuildBit? get _prevNonWhitespace {
    var prev = this.prev;
    while (prev is WhitespaceBit) {
      prev = prev.prev;
    }
    return prev;
  }

  @override
  String toString() => '<BR />';
}
