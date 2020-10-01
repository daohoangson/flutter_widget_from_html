import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import '../core_data.dart';
import 'margin_vertical.dart';

List<Flattened> flatten(BuildTree tree) => _instance.flatten(tree);

@immutable
class Flattened {
  final SpanBuilder spanBuilder;
  final Widget widget;
  final WidgetBuilder widgetBuilder;

  Flattened._({this.spanBuilder, this.widget, this.widgetBuilder});
}

typedef SpanBuilder = InlineSpan Function(BuildContext);

final _instance = _Flattener();

class _Flattener {
  List<Flattened> _flattened;
  StringBuffer _buffer, _prevBuffer;
  _Recognizer _recognizer, _prevRecognizer;
  List<dynamic> _spans;
  bool _swallowWhitespace;
  TextStyleBuilder _tsb, _prevTsb;

  List<Flattened> flatten(BuildTree tree) {
    _flattened = [];

    _resetLoop(tree.tsb);
    for (final bit in tree.bits) {
      _loop(bit);
    }
    _completeLoop();

    return _flattened;
  }

  void _resetLoop(TextStyleBuilder tsb) {
    _buffer = StringBuffer();
    _recognizer = _Recognizer();
    _spans = [];
    _swallowWhitespace = true;
    _tsb = tsb;

    _prevBuffer = _buffer;
    _prevRecognizer = _recognizer;
    _prevTsb = _tsb;
  }

  void _loop(final BuildBit bit) {
    final tsb = _getBitTsb(bit);
    if (_spans == null) _resetLoop(tsb);

    final thisTsb = tsb ?? _prevTsb;
    if (thisTsb?.hasSameStyleWith(_prevTsb) == false) _saveSpan();

    var built;
    if (bit is BuildBit<Null, dynamic>) {
      built = bit.buildBit(null);
    } else if (bit is BuildBit<BuildContext, Widget>) {
      // ignore: omit_local_variable_types
      final WidgetBuilder widgetBuilder = (c) => bit.buildBit(c);
      built = widgetBuilder;
    } else if (bit is BuildBit<GestureRecognizer, dynamic>) {
      built = bit.buildBit(_prevRecognizer.value);
    } else if (bit is BuildBit<TextStyleHtml, InlineSpan>) {
      // ignore: omit_local_variable_types
      final SpanBuilder spanBuilder = (c) => bit.buildBit(thisTsb.build(c));
      built = spanBuilder;
    }

    if (built is GestureRecognizer) {
      _prevRecognizer.value = built;
    } else if (built is InlineSpan || built is SpanBuilder) {
      _saveSpan();
      _spans.add(built);
    } else if (built is String) {
      if (built != ' ' || !_loopShouldSwallowWhitespace(bit)) {
        _prevBuffer.write(built);
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
      for (final subBit in built.bits) {
        _loop(subBit);
      }
    }
  }

  bool _loopShouldSwallowWhitespace(BuildBit bit) {
    // special handling for whitespaces
    if (_swallowWhitespace) return true;

    final next = nextWithTsb(bit);
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
    if (_prevBuffer != _buffer && _prevBuffer.length > 0) {
      final scopedRecognizer = _prevRecognizer.value;
      final scopedTsb = _prevTsb;
      final scopedText = _prevBuffer.toString();
      _spans.add((context) => TextSpan(
            recognizer: scopedRecognizer,
            style: scopedTsb?.build(context)?.styleWithHeight,
            text: scopedText,
          ));
    }
    _prevBuffer = StringBuffer();
    _prevRecognizer = _Recognizer();
  }

  void _completeLoop() {
    _saveSpan();

    if (_spans == null) return;

    final scopedSpans = _spans;
    _spans = null;
    if (scopedSpans.isEmpty && _buffer.isEmpty) return;
    final scopedRecognizer = _recognizer.value;
    final scopedTsb = _tsb;
    final scopedBuffer = _buffer.toString();

    // trim the last new line if any
    final scopedText = scopedSpans.isEmpty
        ? scopedBuffer.replaceAll(RegExp('\n\$'), '')
        : scopedBuffer;

    if (scopedBuffer == '\n' && scopedSpans.isEmpty) {
      // special handling for paragraph with only one line break
      _flattened.add(Flattened._(
        widget: HeightPlaceholder(CssLength(1, CssLengthUnit.em), scopedTsb),
      ));
      return;
    }

    _flattened.add(Flattened._(spanBuilder: (context) {
      final children = scopedSpans
          .map((s) => s is SpanBuilder ? s.call(context) : s)
          .whereType<InlineSpan>()
          .toList(growable: false);
      if (scopedText.isEmpty) {
        if (children.isEmpty) return null;
        if (children.length == 1) return children.first;
      }

      return TextSpan(
        children: children,
        recognizer: scopedRecognizer,
        style: scopedTsb?.build(context)?.styleWithHeight,
        text: scopedText,
      );
    }));
  }

  static TextStyleBuilder _getBitTsb(BuildBit bit) {
    if (bit.tsb != null) return bit.tsb;

    // the below code will find the best style for this whitespace bit
    // easy case: whitespace at the beginning of a tag, use the previous style
    final parent = bit.parent;
    if (parent == null || bit == parent.first) return null;

    // complicated: whitespace at the end of a tag, try to merge with the next
    // unless it has unrelated style (e.g. next bit is a sibling)
    if (bit == parent.last) {
      final next = nextWithTsb(bit);
      if (next != null) {
        var tree = parent;
        while (true) {
          final bitsParentLast = tree.parent?.last;
          if (bitsParentLast != bit) break;
          tree = tree.parent;
        }

        if (tree.parent == next.parent) {
          return next.tsb;
        } else {
          return null;
        }
      }
    }

    // fallback to default (style from parent)
    return parent.tsb;
  }

  static BuildBit nextWithTsb(BuildBit bit) {
    var next = bit.next;
    while (next != null && next.tsb == null) {
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
  GestureRecognizer value;
}
