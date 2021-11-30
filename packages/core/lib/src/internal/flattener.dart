import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import '../core_data.dart';
import '../core_widget_factory.dart';
import 'core_ops.dart';
import 'margin_vertical.dart';

@immutable
class Flattened {
  final SpanBuilder? spanBuilder;
  final Widget? widget;

  const Flattened._({this.spanBuilder, this.widget});
}

class Flattener {
  final WidgetFactory wf;

  final _flattened = <Flattened>[];
  final _recognizers = <GestureRecognizer>[];

  late _Recognizer _recognizer;
  late _Recognizer _prevRecognizer;
  List<_SpanOrBuilder>? _spans;
  late List<_String> _strings;
  late List<_String> _prevStrings;
  var _swallowWhitespace = false;
  late TextStyleBuilder _tsb;
  late TextStyleBuilder _prevTsb;

  Flattener(this.wf);

  @mustCallSuper
  void dispose() {
    for (final r in _recognizers) {
      r.dispose();
    }
    _recognizers.clear();
  }

  List<Flattened> flatten(BuildTree tree) {
    _resetLoop(tree.tsb);

    final bits = tree.bits.toList(growable: false);

    var min = 0;
    var max = bits.length - 1;
    for (; min <= max; min++) {
      if (bits[min] is! WhitespaceBit) {
        break;
      }
    }
    for (; max >= min; max--) {
      if (bits[max] is! WhitespaceBit) {
        break;
      }
    }

    for (var i = 0; i <= bits.length - 1; i++) {
      _loop(
        bits[i],
        shouldBeTrimmed: i < min || i > max,
      );
    }
    _completeLoop();

    return _flattened;
  }

  void _resetLoop(TextStyleBuilder tsb) {
    _recognizer = _Recognizer();
    _spans = [];
    _strings = [];
    _tsb = tsb;

    _prevRecognizer = _recognizer;
    _prevStrings = _strings;
    _prevTsb = _tsb;
  }

  void _loop(
    final BuildBit bit, {
    required bool shouldBeTrimmed,
  }) {
    final thisTsb = _getBitTsb(bit);
    if (_spans == null) {
      _resetLoop(thisTsb);
    }
    if (!thisTsb.hasSameStyleWith(_prevTsb)) {
      _saveSpan();
    }

    if (bit is BuildBit<GestureRecognizer?, GestureRecognizer?>) {
      _prevRecognizer.value = bit.buildBit(_prevRecognizer.value);
    } else if (bit is BuildBit<TextStyleHtml, InlineSpan>) {
      _saveSpan();
      _spans!.add(
        _SpanOrBuilder.builder(
          (context, _, {bool? isLast}) => bit.buildBit(thisTsb.build(context)),
        ),
      );
    } else if (bit is BuildBit<void, InlineSpan>) {
      _saveSpan();
      _spans!.add(_SpanOrBuilder.span(bit.buildBit(null)));
    } else if (bit is BuildBit<void, String>) {
      _prevStrings.add(
        _String(
          bit,
          shouldBeSwallowed: _shouldSwallow(bit),
          shouldBeTrimmed: shouldBeTrimmed,
        ),
      );
    } else if (bit is BuildBit<void, Widget>) {
      _completeLoop();
      _flattened.add(Flattened._(widget: bit.buildBit(null)));
    }

    _prevTsb = thisTsb;
    _swallowWhitespace = bit.swallowWhitespace ?? _swallowWhitespace;
  }

  bool _shouldSwallow(BuildBit bit) {
    if (bit is! WhitespaceBit) {
      return false;
    }
    if (_swallowWhitespace) {
      return true;
    }

    final next = nextNonWhitespace(bit);
    if (next != null && !next.isInline) {
      // skip whitespace before a new block
      return true;
    }

    return false;
  }

  void _saveSpan() {
    if (_prevStrings != _strings && _prevStrings.isNotEmpty) {
      final scopedRecognizer = _prevRecognizer.value;
      final scopedTsb = _prevTsb;
      final scopedStrings = _prevStrings;

      if (scopedRecognizer != null) {
        _recognizers.add(scopedRecognizer);
      }

      _spans!.add(
        _SpanOrBuilder.builder((context, whitespace, {bool? isLast}) {
          final text = scopedStrings.toText(
            whitespace,
            dropNewLine: isLast != false,
          );
          if (text.isEmpty) {
            return null;
          }

          return wf.buildTextSpan(
            recognizer: scopedRecognizer,
            style: scopedTsb.build(context).style,
            text: text,
          );
        }),
      );
    }

    _prevStrings = [];
    _prevRecognizer = _Recognizer();
  }

  void _completeLoop() {
    _saveSpan();

    final scopedSpans = _spans;
    if (scopedSpans == null) {
      return;
    }

    _spans = null;
    if (scopedSpans.isEmpty && _strings.isEmpty) {
      return;
    }
    final scopedRecognizer = _recognizer.value;
    final scopedTsb = _tsb;
    final scopedStrings = _strings;

    if (scopedRecognizer != null) {
      _recognizers.add(scopedRecognizer);
    }

    _flattened.add(
      Flattened._(
        spanBuilder: (context, whitespace, {bool? isLast}) {
          final list = scopedSpans.reversed.toList(growable: false);
          final children = <InlineSpan>[];

          var _isLast = isLast != false;
          for (final item in list) {
            final child = item.span ??
                item.builder?.call(context, whitespace, isLast: _isLast);
            if (child != null) {
              _isLast = false;
              children.insert(0, child);
            }
          }

          final text = scopedStrings.toText(whitespace, dropNewLine: _isLast);
          if (text.isEmpty && children.isEmpty) {
            final nonWhitespaceStrings = scopedStrings
                .where((str) => str.bit is! WhitespaceBit)
                .toList(growable: false);
            if (nonWhitespaceStrings.length == 1 &&
                nonWhitespaceStrings[0].bit is TagBrBit) {
              // special handling for paragraph with <BR /> only
              const oneEm = CssLength(1, CssLengthUnit.em);
              return WidgetSpan(child: HeightPlaceholder(oneEm, scopedTsb));
            }

            return null;
          }

          return wf.buildTextSpan(
            children: children,
            recognizer: scopedRecognizer,
            style: scopedTsb.build(context).style,
            text: text,
          );
        },
      ),
    );
  }

  TextStyleBuilder _getBitTsb(BuildBit bit) {
    if (bit is! WhitespaceBit) {
      return bit.tsb;
    }

    // the below code will find the best style for this whitespace bit
    // easy case: whitespace at the beginning of a tag, use the previous style
    final parent = bit.parent;
    if (parent == null || bit == parent.first) {
      return _prevTsb;
    }

    // complicated: whitespace at the end of a tag, try to merge with the next
    // unless it has unrelated style (e.g. next bit is a sibling)
    if (bit == parent.last) {
      final next = nextNonWhitespace(bit);
      if (next != null) {
        var tree = parent;
        while (tree.parent?.last == bit) {
          tree = tree.parent!;
        }

        if (tree.parent == next.parent) {
          return next.tsb;
        } else {
          return _prevTsb;
        }
      }
    }

    // fallback to default (style from parent)
    return parent.tsb;
  }

  static BuildBit? nextNonWhitespace(BuildBit bit) {
    var next = bit.next;
    while (next != null && next is WhitespaceBit) {
      next = next.next;
    }

    return next;
  }
}

typedef SpanBuilder = InlineSpan? Function(
  BuildContext,
  CssWhitespace whitespace, {
  bool? isLast,
});

/// A mutable recognizer.
///
/// This class is needed because [GestureRecognizer] is rebuilt
/// but we have to keep track of prev / current recognizer for spans
class _Recognizer {
  GestureRecognizer? value;
}

@immutable
class _SpanOrBuilder {
  final SpanBuilder? builder;
  final InlineSpan? span;

  const _SpanOrBuilder.builder(this.builder) : span = null;

  const _SpanOrBuilder.span(this.span) : builder = null;
}

@immutable
class _String {
  final BuildBit bit;
  final String data;
  final bool shouldBeSwallowed;
  final bool shouldBeTrimmed;

  _String(
    BuildBit<void, String> bit, {
    this.shouldBeSwallowed = false,
    this.shouldBeTrimmed = false,
  })  : data = bit.buildBit(null),
        // ignore: prefer_initializing_formals
        bit = bit;
}

extension _StringListToText on List<_String> {
  String toText(
    CssWhitespace whitespace, {
    required bool dropNewLine,
  }) {
    if (isEmpty) {
      return '';
    }

    final buffer = StringBuffer();

    var min = 0;
    var max = length - 1;
    if (whitespace != CssWhitespace.pre) {
      for (; min <= max; min++) {
        if (!this[min].shouldBeTrimmed) {
          break;
        }
      }
      for (; max >= min; max--) {
        if (!this[max].shouldBeTrimmed) {
          break;
        }
      }
    }

    for (var i = min; i <= max; i++) {
      final str = this[i];
      if (str.shouldBeSwallowed) {
        continue;
      }

      if (str.bit is WhitespaceBit) {
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

    if (dropNewLine) {
      return result.replaceFirst(RegExp(r'\n$'), '');
    }

    return result;
  }
}
