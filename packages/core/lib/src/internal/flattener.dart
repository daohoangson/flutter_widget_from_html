import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';

import '../core_data.dart';
import '../core_helpers.dart';
import '../core_widget_factory.dart';
import 'margin_vertical.dart';

final _logger = Logger('fwfh.Flattener');

class Flattener implements Flattened {
  final BuildTree tree;
  final WidgetFactory wf;
  final _widgets = <WidgetPlaceholder>[];

  List<InlineSpan? Function(BuildContext, {bool? isLast})>? _childrenBuilder;
  late List<_String> _firstStrings;
  late HtmlStyleBuilder _firstStyleBuilder;

  late BuildBit _bit;
  var _swallowWhitespace = false;
  late List<_String> _strings;
  late HtmlStyleBuilder _styleBuilder;

  Flattener(this.wf, this.tree) {
    _loopSubTree(tree, flatten: false);

    _resetLoop(tree.styleBuilder);
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

    final scopedTree = _bit.parent!;
    final scopedStyleBuilder = _styleBuilder;
    final placeholder = WidgetPlaceholder.lazy(
      child,
      debugLabel: '${_bit.parent?.element.localName}--Flattener.inlineWidget',
    );

    placeholder.wrapWith((context, widget) {
      final style = scopedStyleBuilder.build(context);
      final recognizer = style.gestureRecognizer;
      if (recognizer != null && _needsInlineRecognizer(context, style)) {
        return wf.buildGestureDetector(scopedTree, widget, recognizer);
      }

      return widget;
    });

    _childrenBuilder?.add(
      (_, {bool? isLast}) => WidgetSpan(
        alignment: alignment,
        baseline: baseline,
        child: placeholder,
      ),
    );
  }

  @override
  void widget(Widget value) {
    _completeLoop();

    final placeholder = WidgetPlaceholder.lazy(
      value,
      debugLabel: '${_bit.parent?.element.localName}--Flattener.widget',
    );
    final scopedStyleBuilder = _styleBuilder;
    placeholder.wrapWith((context, child) {
      final style = scopedStyleBuilder.build(context);
      final recognizer = style.gestureRecognizer;
      final detector = recognizer != null
          ? wf.buildGestureDetector(tree, child, recognizer)
          : null;
      return detector ?? child;
    });

    _widgets.add(placeholder);
    _logger.finest('Added ${placeholder.debugLabel} widget');
  }

  @override
  void write({String? text, String? whitespace}) {
    if (text != null) {
      _strings.add(_String(text));
    }

    if (whitespace != null) {
      _strings.add(
        _String(
          whitespace,
          isWhitespace: true,
          shouldBeSwallowed: _shouldSwallow(_bit),
        ),
      );
    }
  }

  void _resetLoop(HtmlStyleBuilder styleBuilder) {
    _childrenBuilder = [];
    _firstStrings = [];
    _firstStyleBuilder = styleBuilder;

    _strings = _firstStrings;
    _styleBuilder = _firstStyleBuilder;
  }

  void _loopSubTree(BuildTree someTree, {required bool flatten}) {
    for (final child in someTree.children) {
      if (child is BuildTree) {
        _loopSubTree(child, flatten: true);
      }
    }

    if (flatten) {
      someTree.flatten(this);
    }
  }

  void _loop(BuildBit bit) {
    _bit = bit;
    final thisStyleBulder = bit.effectiveStyleBulder ?? _styleBuilder;
    if (_childrenBuilder == null) {
      _resetLoop(thisStyleBulder);
    }
    if (!thisStyleBulder.hasSameStyleWith(_styleBuilder)) {
      _saveSpan();
    }
    _styleBuilder = thisStyleBulder;

    bit.flatten(this);

    _swallowWhitespace = bit.swallowWhitespace ?? _swallowWhitespace;
  }

  bool _shouldSwallow(BuildBit bit) {
    if (_swallowWhitespace) {
      return true;
    }

    final next = bit.nextNonWhitespace;
    if (next != null && next.isInline == false) {
      // skip whitespace before a new block
      return true;
    }

    return false;
  }

  void _saveSpan() {
    if (_strings != _firstStrings && _strings.isNotEmpty) {
      final scopedStyleBuilder = _styleBuilder;
      final scopedStrings = _strings;

      _childrenBuilder?.add(
        (context, {bool? isLast}) {
          final style = scopedStyleBuilder.build(context);
          final text = scopedStrings.toText(
            style.whitespace,
            isFirst: false,
            isLast: isLast != false,
          );
          if (text.isEmpty) {
            return null;
          }

          return wf.buildTextSpan(
            recognizer: _needsInlineRecognizer(context, style)
                ? style.gestureRecognizer
                : null,
            style: style.textStyle,
            text: text,
          );
        },
      );
    }

    _strings = [];
  }

  void _completeLoop() {
    _saveSpan();

    final reversedBuilders = _childrenBuilder?.reversed.toList(growable: false);
    if (reversedBuilders == null) {
      return;
    }

    _childrenBuilder = null;
    if (reversedBuilders.isEmpty && _firstStrings.isEmpty) {
      return;
    }
    final scopedStrings = _firstStrings;
    final scopedStyleBulder = _firstStyleBuilder;

    final placeholder = WidgetPlaceholder(
      builder: (context, _) {
        final style = scopedStyleBulder.build(context);
        final children = <InlineSpan>[];

        var isLast_ = true;
        for (final builder in reversedBuilders) {
          final child = builder(context, isLast: isLast_);
          if (child != null) {
            isLast_ = false;
            children.insert(0, child);
          }
        }

        final text = scopedStrings.toText(
          style.whitespace,
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
            span = WidgetSpan(
              child: HeightPlaceholder(
                oneEm,
                scopedStyleBulder,
                debugLabel: '${tree.element.localName}--$oneEm',
              ),
            );
          }
        } else {
          span = wf.buildTextSpan(
            children: children,
            recognizer: _needsInlineRecognizer(context, style)
                ? style.gestureRecognizer
                : null,
            style: style.textStyle,
            text: text,
          );
        }

        if (span == null) {
          return widget0;
        }

        final textAlign = style.textAlign ?? TextAlign.start;
        if (span is WidgetSpan && textAlign == TextAlign.start) {
          return span.child;
        }

        return wf.buildText(tree, style, span);
      },
      debugLabel: '${tree.element.localName}--text',
    );

    _widgets.add(placeholder);
    _logger.finest('Added ${placeholder.debugLabel} widget');
  }

  bool _needsInlineRecognizer(BuildContext context, HtmlStyle style) {
    final rootStyle = tree.styleBuilder.build(context);
    return style.gestureRecognizer != null &&
        !identical(style.gestureRecognizer, rootStyle.gestureRecognizer);
  }
}

extension on BuildBit {
  HtmlStyleBuilder? get effectiveStyleBulder {
    // the below code will find the best style for this whitespace bit
    // easy case: whitespace at the beginning of a tag, use the previous style
    final parent = this.parent;
    if (parent == null) {
      return null;
    }
    if (this is! WhitespaceBit) {
      return parent.styleBuilder;
    }
    if (this == parent.first) {
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
          return next.parent!.styleBuilder;
        } else {
          return null;
        }
      }
    }

    // fallback to parent's
    return parent.styleBuilder;
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

  const _String(
    this.data, {
    this.isWhitespace = false,
    this.shouldBeSwallowed = false,
  });
}

extension on List<_String> {
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
