import 'package:flutter/widgets.dart';

import '../core_data.dart';
import 'margin_vertical.dart';

class Flattener {
  final BuildTree tree;

  List<Flattened> _flattened;
  List<Function> _builders;
  StringBuffer _buffer, _prevBuffer;
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
    _builders = [];
    _buffer = StringBuffer();
    _tsb = tsb;

    _prevBuffer = _buffer;
    _prevTsb = _tsb;
  }

  void _loop(final BuildBit bit) {
    final tsb = _getBitTsb(bit);
    if (_builders == null) _resetLoop(tsb);

    final thisTsb = tsb ?? _prevTsb;
    if (thisTsb?.hasSameStyleWith(_prevTsb) == false) _saveSpan();

    var built;
    if (bit is BuildBit<Null>) {
      built = bit.buildBit(null);
    } else if (bit is BuildBit<TextStyleHtml>) {
      built = (context) => bit.buildBit(thisTsb?.build(context));
    } else if (bit is BuildBit<TextStyleBuilder>) {
      built = bit.buildBit(thisTsb);
    }

    if (built is InlineSpan) {
      _saveSpan();
      _builders.add((_) => built);
    } else if (built is String) {
      if (built != ' ' || !_loopShouldSkipWhitespace(bit)) {
        _prevBuffer.write(built);
      }
    } else if (built is Function) {
      _saveSpan();
      _builders.add(built);
    } else if (built is Widget) {
      _completeLoop();
      _flattened.add(Flattened(widget: built));
    }

    _prevTsb = thisTsb;
  }

  bool _loopShouldSkipWhitespace(BuildBit bit) {
    // special handling for whitespaces
    if (_prevBuffer.isEmpty) {
      if (_builders.isEmpty && _flattened.isEmpty) {
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
      final scopedTsb = _prevTsb;
      final scopedText = _prevBuffer.toString();
      _builders.add((context) => TextSpan(
            style: scopedTsb?.build(context)?.styleWithHeight,
            text: scopedText,
          ));
    }
    _prevBuffer = StringBuffer();
  }

  void _completeLoop() {
    _saveSpan();

    Function builder;
    Widget widget;
    if (_builders == null) {
      // intentionally left empty
    } else if (_builders.isNotEmpty || _buffer.isNotEmpty) {
      final scopedBuilders = _builders;
      final scopedTsb = _tsb;
      final scopedBuffer = _buffer.toString();
      final scopedText = scopedBuffer.replaceAll(RegExp('\n\$'), '');
      if (scopedBuffer == '\n' && scopedBuilders.isEmpty) {
        widget = HeightPlaceholder(CssLength(1, CssLengthUnit.em), scopedTsb);
      } else {
        builder = (context) {
          final children = scopedBuilders
              .map((spanBuilder) => spanBuilder(context))
              .whereType<InlineSpan>()
              .toList(growable: false);
          if (scopedText.isEmpty) {
            if (children.isEmpty) return null;
            if (children.length == 1) return children.first;
          }

          return TextSpan(
            children: children,
            style: scopedTsb?.build(context)?.styleWithHeight,
            text: scopedText,
          );
        };
      }
    }

    _builders = null;
    if (builder != null) {
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

  @override
  String toString() => (widget ?? builder).toString();
}
