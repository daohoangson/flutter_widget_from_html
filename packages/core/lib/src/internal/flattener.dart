import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import '../core_data.dart';
import '../core_widget_factory.dart';
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
  CssWhitespace whitespace,
);

class Flattener {
  final WidgetFactory wf;

  final _flattened = <Flattened>[];
  final _recognizers = <GestureRecognizer>[];

  late _Recognizer _recognizer;
  late _Recognizer _prevRecognizer;
  List<SpanBuilder>? _spans;
  late List<_String> _strings;
  late List<_String> _prevStrings;
  late bool _swallowWhitespace;
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

    _flatten(tree, trim: true);

    _completeLoop();

    return _flattened;
  }

  void _flatten(BuildTree tree, {bool trim = false}) {
    for (final subTree in tree.subTrees.toList(growable: false).reversed) {
      subTree.onFlattening();
    }

    final bits = tree.bits.toList(growable: false);

    var min = 0;
    var max = bits.length - 1;
    if (trim) {
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
    }

    for (var i = min; i <= max; i++) {
      _loop(bits[i]);
    }
  }

  void _resetLoop(TextStyleBuilder tsb) {
    _recognizer = _Recognizer();
    _spans = [];
    _strings = [];
    _swallowWhitespace = true;
    _tsb = tsb;

    _prevRecognizer = _recognizer;
    _prevStrings = _strings;
    _prevTsb = _tsb;
  }

  void _loop(final BuildBit bit) {
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
      InlineSpan? spanBuilder(BuildContext context, CssWhitespace _) =>
          bit.buildBit(thisTsb.build(context));
      built = spanBuilder;
    } else if (bit is BuildBit<void, dynamic>) {
      built = bit.buildBit(null);
    }

    if (built is GestureRecognizer) {
      _prevRecognizer.value = built;
    } else if (built is InlineSpan) {
      _saveSpan();

      final inlineSpan = built;
      _spans!.add((_, __) => inlineSpan);
    } else if (built is SpanBuilder) {
      _saveSpan();
      _spans!.add(built);
    } else if (built is String) {
      if (bit is WhitespaceBit) {
        if (!_loopShouldSwallowWhitespace(bit)) {
          _prevStrings.add(_String(built, isWhitespace: true));
        }
      } else {
        _prevStrings.add(_String(built));
      }
    } else if (built is Widget) {
      _completeLoop();
      _flattened.add(Flattened._(widget: built));
    } else if (built is WidgetBuilder) {
      _completeLoop();
      _flattened.add(Flattened._(widgetBuilder: built));
    }

    _prevTsb = thisTsb;
    _swallowWhitespace = bit.swallowWhitespace ?? _swallowWhitespace;

    if (built is BuildTree) {
      _flatten(built);
    }
  }

  bool _loopShouldSwallowWhitespace(BuildBit bit) {
    // special handling for whitespaces
    if (_swallowWhitespace) {
      return true;
    }

    final next = nextNonWhitespace(bit);
    if (next == null) {
      // skip trailing whitespace
      return true;
    } else if (!next.isInline) {
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
        (context, whitespace) => wf.buildTextSpan(
          recognizer: scopedRecognizer,
          style: scopedTsb.build(context).styleWithHeight,
          text: scopedStrings.toText(whitespace: whitespace),
        ),
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

    if (scopedSpans.isEmpty &&
        scopedStrings.length == 1 &&
        scopedStrings[0].isNewLine) {
      // special handling for paragraph with only one line break
      _flattened.add(
        Flattened._(
          widget: HeightPlaceholder(
            const CssLength(1, CssLengthUnit.em),
            scopedTsb,
          ),
        ),
      );
      return;
    }

    _flattened.add(
      Flattened._(
        spanBuilder: (context, whitespace) {
          final text = scopedStrings.toText(
            dropNewLine: scopedSpans.isEmpty,
            whitespace: whitespace,
          );

          final children = scopedSpans
              .map((s) => s(context, whitespace))
              .whereType<InlineSpan>()
              .toList(growable: false);

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
  final String data;
  final bool isWhitespace;

  _String(this.data, {this.isWhitespace = false});

  bool get isNewLine => data == '\n';
}

extension _StringListToText on List<_String> {
  String toText({
    bool dropNewLine = false,
    required CssWhitespace whitespace,
  }) {
    if (isEmpty) {
      return '';
    }

    if (dropNewLine && last.isNewLine) {
      removeLast();
      if (isEmpty) {
        return '';
      }
    }

    final buffer = StringBuffer();
    for (final str in this) {
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

    return buffer.toString();
  }
}
