import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import '../core_data.dart';
import '../core_helpers.dart';
import '../core_widget_factory.dart';
import 'margin_vertical.dart';

class Flattener implements FlattenState {
  final BuildMetadata meta;
  final BuildTree tree;
  final WidgetFactory wf;

  final _flattened = <WidgetPlaceholder>[];
  final _recognizersNeedDisposing = <GestureRecognizer>[];

  late _Recognizer _recognizer;
  late _Recognizer _prevRecognizer;
  List<_SpanOrBuilder>? _spans;
  late List<_String> _strings;
  late List<_String> _prevStrings;
  late bool _shouldBeTrimmed;
  var _swallowWhitespace = false;
  late TextStyleBuilder _tsb;
  late TextStyleBuilder _prevTsb;

  Flattener(this.wf, this.meta, this.tree);

  @mustCallSuper
  void dispose() {
    for (final r in _recognizersNeedDisposing) {
      r.dispose();
    }
    _recognizersNeedDisposing.clear();
  }

  List<WidgetPlaceholder> flatten() {
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
      _shouldBeTrimmed = i < min || i > max;
      _loop(bits[i]);
    }
    _completeLoop();

    return _flattened;
  }

  @override
  GestureRecognizer? get recognizer => _prevRecognizer.value;

  @override
  bool get swallowWhitespace => _swallowWhitespace;

  @override
  void addInlineSpan(InlineSpan value) {
    _saveSpan();
    _spans!.add(_SpanOrBuilder.span(value));
  }

  @override
  void addSpanBuilder(SpanBuilder value) {
    _saveSpan();
    _spans!.add(_SpanOrBuilder.builder(value));
  }

  @override
  void addText(String value) => _prevStrings.add(_String(value));

  @override
  void addWhitespace(String value, {required bool shouldBeSwallowed}) =>
      _prevStrings.add(
        _String(
          value,
          isWhitespace: true,
          shouldBeSwallowed: shouldBeSwallowed,
          shouldBeTrimmed: _shouldBeTrimmed,
        ),
      );

  @override
  void addWidget(Widget value) {
    _completeLoop();
    _flattened.add(WidgetPlaceholder.lazy(value));
  }

  @override
  void setRecognizer(GestureRecognizer? value, {bool autoDispose = true}) {
    _prevRecognizer.value = value;
    if (autoDispose && value != null) {
      _recognizersNeedDisposing.add(value);
    }
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

  void _loop(BuildBit bit) {
    final thisTsb = bit.tsb ?? _prevTsb;
    if (_spans == null) {
      _resetLoop(thisTsb);
    }
    if (!thisTsb.hasSameStyleWith(_prevTsb)) {
      _saveSpan();
    }

    bit.onFlatten(this);

    _prevTsb = thisTsb;
    _swallowWhitespace = bit.swallowWhitespace ?? _swallowWhitespace;
  }

  void _saveSpan() {
    if (_prevStrings != _strings && _prevStrings.isNotEmpty) {
      final scopedRecognizer = _prevRecognizer.value;
      final scopedTsb = _prevTsb;
      final scopedStrings = _prevStrings;

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
            style: scopedTsb.build(context).styleWithHeight,
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

    _flattened.add(
      WidgetPlaceholder(
        builder: (context, _) {
          final tsh = scopedTsb.build(context);

          final list = scopedSpans.reversed.toList(growable: false);
          final children = <InlineSpan>[];

          var _isLast = true;
          for (final item in list) {
            final child = item.span ??
                item.builder?.call(context, tsh.whitespace, isLast: _isLast);
            if (child != null) {
              _isLast = false;
              children.insert(0, child);
            }
          }

          final text =
              scopedStrings.toText(tsh.whitespace, dropNewLine: _isLast);
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
              style: scopedTsb.build(context).styleWithHeight,
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

    if (dropNewLine) {
      return result.replaceFirst(RegExp(r'\n$'), '');
    }

    return result;
  }
}
