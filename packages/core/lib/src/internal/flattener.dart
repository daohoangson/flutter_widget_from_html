import 'package:flutter/gestures.dart';
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

  List<_SpanOrBuilder>? _children;
  late _GestureRecognizer _firstRecognizer;
  late List<_String> _firstStrings;
  late TextStyleBuilder _firstTsb;

  late BuildBit _bit;
  var _swallowWhitespace = false;
  late _GestureRecognizer _recognizer;
  late List<_String> _strings;
  late TextStyleBuilder _tsb;

  Flattener(this.wf, this.meta, this.tree) {
    _resetLoop(tree.tsb);
    for (final bit in tree.bits) {
      _loop(bit);
    }
    _completeLoop();
  }

  Iterable<WidgetPlaceholder> get widgets => _widgets;

  @override
  GestureRecognizer? get recognizer => _recognizer.value;

  @override
  set recognizer(GestureRecognizer? value) => _recognizer.value = value;

  @override
  // ignore: avoid_setters_without_getters
  set span(InlineSpan value) {
    _saveSpan();
    _children?.add(_SpanOrBuilder.span(value));
  }

  @override
  // ignore: avoid_setters_without_getters
  set text(String value) => _strings.add(_String(value));

  @override
  // ignore: avoid_setters_without_getters
  set widget(Widget value) {
    _completeLoop();
    _widgets.add(WidgetPlaceholder.lazy(value));
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

  void _resetLoop(TextStyleBuilder tsb) {
    _firstRecognizer = _GestureRecognizer();
    _children = [];
    _firstStrings = [];
    _firstTsb = tsb;

    _recognizer = _firstRecognizer;
    _strings = _firstStrings;
    _tsb = _firstTsb;
  }

  void _loop(BuildBit bit) {
    _bit = bit;
    final thisTsb = bit.effectiveTsb ?? _tsb;
    if (_children == null) {
      _resetLoop(thisTsb);
    }
    if (!thisTsb.hasSameStyleWith(_tsb)) {
      _saveSpan();
    }

    bit.flatten(this);

    _tsb = thisTsb;
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
      final scopedRecognizer = _recognizer.value;
      final scopedTsb = _tsb;
      final scopedStrings = _strings;

      _children?.add(
        _SpanOrBuilder.builder((context, {bool? isLast}) {
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
            recognizer: scopedRecognizer,
            style: tsh.style,
            text: text,
          );
        }),
      );
    }

    _strings = [];
    _recognizer = _GestureRecognizer();
  }

  void _completeLoop() {
    _saveSpan();

    final scopedChildren = _children;
    if (scopedChildren == null) {
      return;
    }

    _children = null;
    if (scopedChildren.isEmpty && _firstStrings.isEmpty) {
      return;
    }
    final scopedRecognizer = _firstRecognizer.value;
    final scopedStrings = _firstStrings;
    final scopedTsb = _firstTsb;

    _widgets.add(
      WidgetPlaceholder(
        builder: (context, _) {
          final tsh = scopedTsb.build(context);
          final list = scopedChildren.reversed.toList(growable: false);
          final children = <InlineSpan>[];

          var isLast_ = true;
          for (final item in list) {
            final child =
                item.span ?? item.builder?.call(context, isLast: isLast_);
            if (child != null) {
              isLast_ = false;
              children.insert(0, child);
            }
          }

          final text = scopedStrings.toText(
            tsh.whitespace,
            isFirst: true,
            isLast: isLast_,
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
              recognizer: scopedRecognizer,
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
}

extension _BuildBit on BuildBit {
  TextStyleBuilder? get effectiveTsb {
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

class _GestureRecognizer {
  GestureRecognizer? value;
}

@immutable
class _SpanOrBuilder {
  final InlineSpan? Function(BuildContext, {bool? isLast})? builder;
  final InlineSpan? span;

  const _SpanOrBuilder.builder(this.builder) : span = null;

  const _SpanOrBuilder.span(this.span) : builder = null;
}

@immutable
class _String {
  final String data;
  final bool isWhitespace;
  final bool shouldBeSwallowed;

  const _String(
    this.data, {
    this.isWhitespace = false,
    this.shouldBeSwallowed = false,
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
