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
  final WidgetBuilder? widgetBuilder;

  const Flattened._({this.spanBuilder, this.widget, this.widgetBuilder});
}

typedef SpanBuilder = InlineSpan? Function(
  BuildContext,
  CssWhitespace whitespace, {
  bool? isLast,
});

class Flattener {
  final WidgetFactory wf;

  final _flattened = <Flattened>[];
  final _recognizers = <GestureRecognizer>[];

  late _Recognizer _recognizer;
  late _Recognizer _prevRecognizer;
  List<SpanBuilder>? _spans;
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

    dynamic built;
    if (bit is BuildBit<BuildContext, Widget>) {
      Widget widgetBuilder(BuildContext context) => bit.buildBit(context);
      built = widgetBuilder;
    } else if (bit is BuildBit<GestureRecognizer?, dynamic>) {
      built = bit.buildBit(_prevRecognizer.value);
    } else if (bit is BuildBit<TextStyleHtml, InlineSpan>) {
      // ignore: prefer_function_declarations_over_variables
      final SpanBuilder spanBuilder =
          (context, _, {bool? isLast}) => bit.buildBit(thisTsb.build(context));
      built = spanBuilder;
    } else if (bit is BuildBit<void, dynamic>) {
      built = bit.buildBit(null);
    }

    if (built is GestureRecognizer) {
      _prevRecognizer.value = built;
    } else if (built is InlineSpan) {
      _saveSpan();

      final inlineSpan = built;
      _spans!.add((_, __, {bool? isLast}) => inlineSpan);
    } else if (built is SpanBuilder) {
      _saveSpan();
      _spans!.add(built);
    } else if (built is String) {
      _prevStrings.add(
        _String(
          bit,
          built,
          shouldBeSwallowed: _shouldSwallow(bit),
          shouldBeTrimmed: shouldBeTrimmed,
        ),
      );
    } else if (built is Widget) {
      _completeLoop();
      _flattened.add(Flattened._(widget: built));
    } else if (built is WidgetBuilder) {
      _completeLoop();
      _flattened.add(Flattened._(widgetBuilder: built));
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
        (context, whitespace, {bool? isLast}) {
          final text = scopedStrings.toText(
            whitespace,
            dropNewLine: isLast != false,
          );
          if (text.isEmpty) {
            return null;
          }

          return wf.buildTextSpan(
            recognizer: scopedRecognizer,
            style: scopedTsb.build(context).styleWithHeight,
            text: text,
          );
        },
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
          final spanBuilders = scopedSpans.reversed.toList(growable: false);
          final children = <InlineSpan>[];

          var _isLast = isLast != false;
          for (final spanBuilder in spanBuilders) {
            final child = spanBuilder(context, whitespace, isLast: _isLast);
            if (child != null) {
              _isLast = false;
              children.insert(0, child);
            }
          }

          final text = scopedStrings.toText(whitespace, dropNewLine: _isLast);
          if (text.isEmpty && children.isEmpty) {
            if (scopedStrings.length == 1 && scopedStrings[0].bit is TagBrBit) {
              // special handling for paragraph with <BR /> only
              const oneEm = CssLength(1, CssLengthUnit.em);
              return WidgetSpan(child: HeightPlaceholder(oneEm, scopedTsb));
            }

            return null;
          }

          return wf.buildTextSpan(
            children: children,
            recognizer: scopedRecognizer,
            style: scopedTsb.build(context).styleWithHeight,
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

/// A mutable recognizer.
///
/// This class is needed because [GestureRecognizer] is rebuilt
/// but we have to keep track of prev / current recognizer for spans
class _Recognizer {
  GestureRecognizer? value;
}

class _String {
  final BuildBit bit;
  final String data;
  final bool shouldBeSwallowed;
  final bool shouldBeTrimmed;

  _String(
    this.bit,
    this.data, {
    this.shouldBeSwallowed = false,
    this.shouldBeTrimmed = false,
  });
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

    final str = buffer.toString();

    if (whitespace == CssWhitespace.pre) {
      return str;
    }

    if (dropNewLine) {
      return str.replaceFirst(RegExp(r'\n$'), '');
    }

    return str;
  }
}
