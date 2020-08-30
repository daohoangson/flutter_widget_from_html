import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import '../core_data.dart';
import 'margin_vertical.dart';

class Flattener {
  final BuildTree tree;

  List<Flattened> _flattened;
  StringBuffer _buffer, _prevBuffer;
  _Recognizer _recognizer, _prevRecognizer;
  List<dynamic> _spans;
  TextStyleBuilder _tsb, _prevTsb;

  Flattener(this.tree);

  List<Flattened> flatten() {
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
    var isSpanBuilder = false;
    if (bit is BuildBit<Null>) {
      built = bit.buildBit(null);
    } else if (bit is BuildBit<GestureRecognizer>) {
      built = bit.buildBit(_prevRecognizer.value);
    } else if (bit is BuildBit<TextStyleHtml>) {
      // ignore: omit_local_variable_types
      final InlineSpan Function(BuildContext) spanBuilder =
          (context) => bit.buildBit(thisTsb.build(context));
      built = spanBuilder;
      isSpanBuilder = true;
    } else if (bit is BuildBit<TextStyleBuilder>) {
      built = bit.buildBit(thisTsb);
    }

    if (built is GestureRecognizer) {
      _prevRecognizer.value = built;
    } else if (built is InlineSpan || isSpanBuilder) {
      _saveSpan();
      _spans.add(built);
    } else if (built is String) {
      if (built != ' ' || !_loopShouldSkipWhitespace(bit)) {
        _prevBuffer.write(built);
      }
    } else if (built is Widget) {
      _completeLoop();
      _flattened.add(Flattened(widget: built));
    }

    _prevTsb = thisTsb;
  }

  bool _loopShouldSkipWhitespace(BuildBit bit) {
    // special handling for whitespaces
    if (_prevBuffer.isEmpty) {
      if (_spans.isEmpty && _flattened.isEmpty) {
        // skip leading whitespace
        return true;
      }
    }

    final nextBit = bit.next;
    if (nextBit == null) {
      // skip trailing whitespace
      return true;
    } else if (nextBit is WidgetBit) {
      if (!nextBit.isInline) {
        // skip whitespace before a new block
        return true;
      }
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

    Function builder;
    Widget widget;
    if (_spans == null) {
      // intentionally left empty
    } else if (_spans.isNotEmpty || _buffer.isNotEmpty) {
      final scopedSpans = _spans;
      final scopedRecognizer = _recognizer.value;
      final scopedTsb = _tsb;
      final scopedBuffer = _buffer.toString();
      final scopedText = scopedBuffer.replaceAll(RegExp('\n\$'), '');
      if (scopedBuffer == '\n' && scopedSpans.isEmpty) {
        // special handling for paragraph with only one line break
        widget = HeightPlaceholder(CssLength(1, CssLengthUnit.em), scopedTsb);
      } else {
        builder = (context) {
          final children = scopedSpans
              .map<InlineSpan>((s) => s is Function ? s.call(context) : s)
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
        };
      }
    }

    _spans = null;
    if (builder != null || widget != null) {
      _flattened.add(Flattened(builder: builder, widget: widget));
    }
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
      final next = bit.next;
      if (next?.tsb != null) {
        // get the outer-most bits having this as the last bit
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
}

@immutable
class Flattened {
  final Function builder;
  final Widget widget;

  Flattened({this.builder, this.widget});
}

/// A mutable recognizer.
///
/// This class is needed because [GestureRecognizer] is rebuilt
/// but we have to keep track of prev / current recognizer for spans
class _Recognizer {
  GestureRecognizer value;
}
