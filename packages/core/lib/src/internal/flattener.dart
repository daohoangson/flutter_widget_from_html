import 'package:flutter/widgets.dart';

import '../core_data.dart';
import '../core_helpers.dart';
import '../core_widget_factory.dart';
import 'margin_vertical.dart';

class Flattener implements Flattened {
  final BuildMetadata meta;
  final BuildTree tree;
  final WidgetFactory wf;
  final _widgets = <WidgetPlaceholder>[];

  List<InlineSpan? Function(BuildContext, {bool? isLast})>? _childrenBuilder;
  late List<_String> _firstStrings;
  late HtmlStyleBuilder _firstTsb;

  late BuildBit _bit;
  var _swallowWhitespace = false;
  late List<_String> _strings;
  late HtmlStyleBuilder _tsb;

  Flattener(this.wf, this.meta, this.tree) {
    _resetLoop(tree.tsb);
    for (final bit in tree.bits) {
      _loop(bit);
    }
    _completeLoop();
  }

  Iterable<WidgetPlaceholder> get widgets => _widgets;

  @override
  void inlineWidget({
    PlaceholderAlignment alignment = PlaceholderAlignment.bottom,
    TextBaseline baseline = TextBaseline.alphabetic,
    required Widget child,
  }) {
    _saveSpan();

    final scopedTsb = _tsb;

    _childrenBuilder?.add(
      (context, {bool? isLast}) {
        final tsh = scopedTsb.build(context);

        Widget? detector;
        if (_needsInlineRecognizer(context, tsh)) {
          detector = wf.buildGestureDetector(meta, child, tsh.onTap!);
        }

        return WidgetSpan(
          alignment: alignment,
          baseline: baseline,
          child: detector ?? child,
        );
      },
    );
  }

  @override
  // ignore: avoid_setters_without_getters
  set text(String value) => _strings.add(_String(value));

  @override
  // ignore: avoid_setters_without_getters
  set widget(Widget value) {
    _completeLoop();

    final placeholder = WidgetPlaceholder.lazy(value);
    final scopedTsb = _tsb;
    placeholder.wrapWith((context, child) {
      final tsh = scopedTsb.build(context);
      final onTap = tsh.onTap;
      final detector =
          onTap != null ? wf.buildGestureDetector(meta, child, onTap) : null;
      return detector ?? child;
    });

    _widgets.add(placeholder);
  }

  @override
  // ignore: avoid_setters_without_getters
  set whitespace(String value) => _strings.add(
        _String(
          value,
          isWhitespace: true,
          shouldBeSwallowed: _shouldSwallow(_bit),
        ),
      );

  void _resetLoop(HtmlStyleBuilder tsb) {
    _childrenBuilder = [];
    _firstStrings = [];
    _firstTsb = tsb;

    _strings = _firstStrings;
    _tsb = _firstTsb;
  }

  void _loop(BuildBit bit) {
    _bit = bit;
    final thisTsb = bit.effectiveTsb ?? _tsb;
    if (_childrenBuilder == null) {
      _resetLoop(thisTsb);
    }
    if (!thisTsb.hasSameStyleWith(_tsb)) {
      _saveSpan();
    }
    _tsb = thisTsb;

    bit.flatten(this);

    _swallowWhitespace = bit.swallowWhitespace ?? _swallowWhitespace;
  }

  bool _shouldSwallow(BuildBit bit) {
    if (_swallowWhitespace) {
      return true;
    }

    final next = bit.nextNonWhitespace;
    if (next != null && !next.isInline) {
      // skip whitespace before a new block
      return true;
    }

    return false;
  }

  void _saveSpan() {
    if (_strings != _firstStrings && _strings.isNotEmpty) {
      final scopedTsb = _tsb;
      final scopedStrings = _strings;

      _childrenBuilder?.add(
        (context, {bool? isLast}) {
          final tsh = scopedTsb.build(context);
          final text = scopedStrings.toText(
            tsh.whitespace,
            isFirst: false,
            isLast: isLast != false,
          );
          if (text.isEmpty) {
            return null;
          }

          return wf.buildTextSpan(
            recognizer: _needsInlineRecognizer(context, tsh)
                ? wf.gestureRecognizer(tsh)
                : null,
            style: tsh.style,
            text: text,
          );
        },
      );
    }

    _strings = [];
  }

  void _completeLoop() {
    _saveSpan();

    final scopedChildrenBuilder = _childrenBuilder;
    if (scopedChildrenBuilder == null) {
      return;
    }

    _childrenBuilder = null;
    if (scopedChildrenBuilder.isEmpty && _firstStrings.isEmpty) {
      return;
    }
    final scopedStrings = _firstStrings;
    final scopedTsb = _firstTsb;

    _widgets.add(
      WidgetPlaceholder(
        builder: (context, _) {
          final tsh = scopedTsb.build(context);
          final reversedbuilders =
              scopedChildrenBuilder.reversed.toList(growable: false);
          final children = <InlineSpan>[];

          var _isLast = true;
          for (final builder in reversedbuilders) {
            final child = builder(context, isLast: _isLast);
            if (child != null) {
              _isLast = false;
              children.insert(0, child);
            }
          }

          final text = scopedStrings.toText(
            tsh.whitespace,
            isFirst: true,
            isLast: _isLast,
          );
          InlineSpan? span;
          if (text.isEmpty && children.isEmpty) {
            final nonWhitespaceStrings = scopedStrings
                .where((str) => !str.isWhitespace)
                .toList(growable: false);
            if (nonWhitespaceStrings.length == 1 &&
                nonWhitespaceStrings[0].data == '\n') {
              // special handling for paragraph with <BR /> only
              const oneEm = CssLength(1, CssLengthUnit.em);
              span = WidgetSpan(child: HeightPlaceholder(oneEm, scopedTsb));
            }
          } else {
            span = wf.buildTextSpan(
              children: children,
              recognizer: _needsInlineRecognizer(context, tsh)
                  ? wf.gestureRecognizer(tsh)
                  : null,
              style: tsh.style,
              text: text,
            );
          }

          if (span == null) {
            return widget0;
          }

          final textAlign = tsh.textAlign ?? TextAlign.start;
          if (span is WidgetSpan && textAlign == TextAlign.start) {
            return span.child;
          }

          return wf.buildText(meta, tsh, span);
        },
        localName: 'text',
      ),
    );
  }

  bool _needsInlineRecognizer(BuildContext context, HtmlStyle style) {
    final rootStyle = tree.tsb.build(context);
    return style.onTap != null && !identical(style.onTap, rootStyle.onTap);
  }
}

extension _BuildBit on BuildBit {
  HtmlStyleBuilder? get effectiveTsb {
    if (this is! WhitespaceBit) {
      return tsb;
    }

    // the below code will find the best style for this whitespace bit
    // easy case: whitespace at the beginning of a tag, use the previous style
    final parent = this.parent;
    if (parent == null || this == parent.first) {
      return null;
    }

    // complicated: whitespace at the end of a tag, try to merge with the next
    // unless it has unrelated style (e.g. next bit is a sibling)
    if (this == parent.last) {
      final next = nextNonWhitespace;
      if (next != null) {
        var tree = parent;
        while (tree.parent?.last == this) {
          tree = tree.parent!;
        }

        if (tree.parent == next.parent) {
          return next.tsb;
        } else {
          return null;
        }
      }
    }

    // fallback to parent's
    return parent.tsb;
  }

  BuildBit? get nextNonWhitespace {
    var next = this.next;
    while (next != null && next is WhitespaceBit) {
      next = next.next;
    }

    return next;
  }
}

@immutable
class _String {
  final String data;
  final bool isWhitespace;
  final bool shouldBeSwallowed;
  final bool shouldBeTrimmed;

  const _String(
    this.data, {
    this.isWhitespace = false,
    this.shouldBeSwallowed = false,
    this.shouldBeTrimmed = false,
  });
}

extension _StringListToText on List<_String> {
  String toText(
    CssWhitespace whitespace, {
    required bool isFirst,
    required bool isLast,
  }) {
    if (isEmpty) {
      return '';
    }

    final buffer = StringBuffer();

    var min = 0;
    var max = length - 1;
    if (whitespace != CssWhitespace.pre) {
      if (isFirst) {
        for (; min <= max; min++) {
          if (!this[min].isWhitespace) {
            break;
          }
        }
      }
      if (isLast) {
        for (; max >= min; max--) {
          if (!this[max].isWhitespace) {
            break;
          }
        }
      }
    }

    for (var i = min; i <= max; i++) {
      final str = this[i];
      if (str.shouldBeSwallowed) {
        continue;
      }

      if (str.isWhitespace) {
        if (whitespace == CssWhitespace.pre) {
          buffer.write(str.data);
        } else {
          buffer.write(' ');
        }
      } else {
        buffer.write(str.data);
      }
    }

    final result = buffer.toString();

    if (whitespace == CssWhitespace.pre) {
      return result;
    }

    if (isLast) {
      return result.replaceFirst(RegExp(r'\n$'), '');
    }

    return result;
  }
}
