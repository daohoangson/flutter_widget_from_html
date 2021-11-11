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
  final _widgets = <WidgetPlaceholder>[];

  List<_SpanOrBuilder>? _children;
  GestureRecognizer? _firstRecognizer;
  late List<_String> _firstStrings;
  late TextStyleBuilder _firstTsb;

  late bool _shouldBeTrimmed;
  var _swallowWhitespace = false;
  GestureRecognizer? _recognizer;
  late List<_String> _strings;
  late TextStyleBuilder _tsb;

  Flattener(this.wf, this.meta, this.tree) {
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
  }

  Iterable<WidgetPlaceholder> get widgets => _widgets;

  @override
  GestureRecognizer? get recognizer => _recognizer;

  @override
  set recognizer(GestureRecognizer? value) => _recognizer = value;

  @override
  bool get swallowWhitespace => _swallowWhitespace;

  @override
  void addSpan(InlineSpan value) {
    _saveSpan();
    _children?.add(_SpanOrBuilder.span(value));
  }

  @override
  void addText(String value) => _strings.add(_String(value));

  @override
  void addWhitespace(String value, {required bool shouldBeSwallowed}) =>
      _strings.add(
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
    _widgets.add(WidgetPlaceholder.lazy(value));
  }

  void _resetLoop(TextStyleBuilder tsb) {
    _firstRecognizer = null;
    _children = [];
    _firstStrings = [];
    _firstTsb = tsb;

    _recognizer = _firstRecognizer;
    _strings = _firstStrings;
    _tsb = _firstTsb;
  }

  void _loop(BuildBit bit) {
    final thisTsb = bit.tsb ?? _tsb;
    if (_children == null) {
      _resetLoop(thisTsb);
    }
    if (!thisTsb.hasSameStyleWith(_tsb)) {
      _saveSpan();
    }

    bit.onFlatten(this);

    _tsb = thisTsb;
    _swallowWhitespace = bit.swallowWhitespace ?? _swallowWhitespace;
  }

  void _saveSpan() {
    if (_strings != _firstStrings && _strings.isNotEmpty) {
      final scopedRecognizer = _recognizer;
      final scopedTsb = _tsb;
      final scopedStrings = _strings;

      _children?.add(
        _SpanOrBuilder.builder((context, {bool? isLast}) {
          final tsh = scopedTsb.build(context);
          final text = scopedStrings.toText(
            tsh.whitespace,
            dropNewLine: isLast != false,
          );
          if (text.isEmpty) {
            return null;
          }

          return wf.buildTextSpan(
            recognizer: scopedRecognizer,
            style: tsh.styleWithHeight,
            text: text,
          );
        }),
      );
    }

    _strings = [];
    _recognizer = null;
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
    final scopedRecognizer = _firstRecognizer;
    final scopedStrings = _firstStrings;
    final scopedTsb = _firstTsb;

    _widgets.add(
      WidgetPlaceholder(
        builder: (context, _) {
          final tsh = scopedTsb.build(context);
          final list = scopedChildren.reversed.toList(growable: false);
          final children = <InlineSpan>[];

          var _isLast = true;
          for (final item in list) {
            final child =
                item.span ?? item.builder?.call(context, isLast: _isLast);
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
