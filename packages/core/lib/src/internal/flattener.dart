import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';

import '../core_data.dart';
import '../core_helpers.dart';
import '../core_widget_factory.dart';
import 'core_ops.dart';

final _logger = Logger('fwfh.Flattener');

class Flattener implements Flattened {
  final BuildTree tree;
  final WidgetFactory wf;
  final _widgets = <WidgetPlaceholder>[];

  List<InlineSpan? Function(BuildContext context, {bool? isLast})>?
      _childrenBuilder;
  late InheritanceResolvers _firstInheritanceResolvers;
  late List<_String> _firstStrings;

  late BuildBit _bit;
  late InheritanceResolvers _inheritanceResolvers;
  var _hasInlineContent = false;
  InheritanceResolvers? _lastInlineContentResolvers;
  final _pending = <_PendingString>[];
  var _swallowWhitespace = false;
  late List<_String> _strings;

  Flattener(this.wf, this.tree) {
    _loopSubTree(tree, flatten: false);

    _resetLoop(tree.inheritanceResolvers);
    for (final bit in tree.bits) {
      _loop(bit);
    }
    _completeLoop();
  }

  Iterable<WidgetPlaceholder> get widgets => _widgets;

  void _lineBreak() {
    _pending.add(
      _PendingString(
        _inheritanceResolvers,
        const _String('\n', isLineBreak: true),
      ),
    );
  }

  @override
  void inlineWidget({
    PlaceholderAlignment alignment = PlaceholderAlignment.baseline,
    TextBaseline baseline = TextBaseline.alphabetic,
    required Widget child,
  }) {
    _flushPending();
    _saveSpan();
    _hasInlineContent = true;
    _lastInlineContentResolvers = _inheritanceResolvers;

    final scopedTree = _bit.parent;
    final scopedInheritanceResolvers = _inheritanceResolvers;
    final placeholder = WidgetPlaceholder.lazy(
      child,
      debugLabel: '${scopedTree.element.localName}--Flattener.inlineWidget',
    );

    placeholder.wrapWith((context, widget) {
      final resolved = scopedInheritanceResolvers.resolve(context);
      final recognizer = _getInlineRecognizer(context, resolved);
      if (recognizer != null) {
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

    final debugLabel = '${_bit.parent.element.localName}--Flattener.widget';
    final placeholder = WidgetPlaceholder.lazy(value, debugLabel: debugLabel);
    _widgets.add(placeholder);
    _logger.finest('Added ${placeholder.debugLabel} widget');
  }

  @override
  void write({String? text, String? whitespace}) {
    if (text != null) {
      _flushPending();
      _strings.add(_String(text));
      _hasInlineContent = true;
      _lastInlineContentResolvers = _inheritanceResolvers;
    }

    if (whitespace != null) {
      final string = _String(
        whitespace,
        isWhitespace: true,
        shouldBeSwallowed: _shouldSwallow(_bit),
      );
      if (_pending.isNotEmpty) {
        _pending.add(_PendingString(_inheritanceResolvers, string));
      } else {
        _strings.add(string);
      }
    }
  }

  void _flushPending() {
    if (_pending.isEmpty) {
      return;
    }

    final canAppend = _pending.every(
      (pending) =>
          pending.inheritanceResolvers.isIdenticalWith(_inheritanceResolvers),
    );
    if (canAppend) {
      _strings.addAll(_pending.map((pending) => pending.string));
      _pending.clear();
      return;
    }

    final canAppendToFirst = _childrenBuilder?.isEmpty == true &&
        _pending.every(
          (pending) => pending.inheritanceResolvers.isIdenticalWith(
            _firstInheritanceResolvers,
          ),
        );
    if (canAppendToFirst) {
      _firstStrings.addAll(_pending.map((pending) => pending.string));
      _pending.clear();
      return;
    }

    _saveSpan();
    var start = 0;
    while (start < _pending.length) {
      final inheritanceResolvers = _pending[start].inheritanceResolvers;
      var end = start + 1;
      while (end < _pending.length &&
          _pending[end].inheritanceResolvers.isIdenticalWith(
                inheritanceResolvers,
              )) {
        end++;
      }

      _addTextBuilder(inheritanceResolvers, [
        for (var i = start; i < end; i++) _pending[i].string,
      ]);
      start = end;
    }

    _pending.clear();
  }

  void _resetLoop(InheritanceResolvers inheritanceResolvers) {
    _childrenBuilder = [];
    _firstInheritanceResolvers = inheritanceResolvers;
    _firstStrings = [];

    _inheritanceResolvers = _firstInheritanceResolvers;
    _strings = _firstStrings;
    _lastInlineContentResolvers = null;
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
    final thisInheritanceResolvers =
        bit.effectiveInheritanceResolvers ?? _inheritanceResolvers;
    if (_childrenBuilder == null) {
      _resetLoop(thisInheritanceResolvers);
    }
    if (!thisInheritanceResolvers.isIdenticalWith(_inheritanceResolvers)) {
      _saveSpan();
    }
    _inheritanceResolvers = thisInheritanceResolvers;

    if (bit is TagBrBit) {
      _lineBreak();
    } else {
      bit.flatten(this);
    }

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
      _addTextBuilder(_inheritanceResolvers, _strings);
    }

    _strings = [];
  }

  void _addTextBuilder(
    InheritanceResolvers inheritanceResolvers,
    List<_String> strings,
  ) {
    _childrenBuilder?.add((context, {bool? isLast}) {
      final resolved = inheritanceResolvers.resolve(context);
      final text = strings.toText(
        resolved.whitespaceOrNormal,
        isFirst: false,
        isLast: isLast != false,
      );
      if (text.isEmpty) {
        return null;
      }

      return wf.buildTextSpan(
        recognizer: _getInlineRecognizer(context, resolved),
        style: resolved.prepareTextStyle(),
        text: text,
      );
    });
  }

  void _completeLoop() {
    final hasInlineContent = _hasInlineContent;
    final lastInlineContentResolvers = _lastInlineContentResolvers;
    final pending = _pending.toList(growable: false);
    _pending.clear();
    _hasInlineContent = false;
    _lastInlineContentResolvers = null;

    _addPendingLineMetrics(
      pending,
      hasInlineContent: hasInlineContent,
      lastInlineContentResolvers: lastInlineContentResolvers,
    );
    _saveSpan();

    final reversedBuilders = _childrenBuilder?.reversed.toList(growable: false);
    if (reversedBuilders == null) {
      _addPendingLineBoxes(
        pending,
        hasInlineContent: hasInlineContent,
      );
      return;
    }

    _childrenBuilder = null;
    if (reversedBuilders.isNotEmpty || _firstStrings.isNotEmpty) {
      final scopedStrings = _firstStrings;
      final scopedInheritanceResolvers = _firstInheritanceResolvers;

      final placeholder = WidgetPlaceholder(
        builder: (context, _) {
          final resolved = scopedInheritanceResolvers.resolve(context);
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
            resolved.whitespaceOrNormal,
            isFirst: true,
            isLast: isLast_,
          );
          if (text.isEmpty && children.isEmpty) {
            return widget0;
          }
          final span = wf.buildTextSpan(
            children: children,
            recognizer: _getInlineRecognizer(context, resolved),
            style: resolved.prepareTextStyle(),
            text: text,
          );
          if (span == null) {
            return widget0;
          }

          final textAlign = resolved.get<TextAlign>() ?? TextAlign.start;
          if (span is WidgetSpan && textAlign == TextAlign.start) {
            return span.child;
          }

          return wf.buildText(tree, resolved, span);
        },
        debugLabel: '${tree.element.localName}--text',
      );

      _widgets.add(placeholder);
      _logger.finest('Added ${placeholder.debugLabel} widget');
    }

    _addPendingLineBoxes(
      pending,
      hasInlineContent: hasInlineContent,
    );
  }

  void _addPendingLineMetrics(
    List<_PendingString> pending, {
    required bool hasInlineContent,
    required InheritanceResolvers? lastInlineContentResolvers,
  }) {
    if (!hasInlineContent ||
        lastInlineContentResolvers == null ||
        pending.isEmpty ||
        !pending.first.string.isLineBreak) {
      return;
    }

    final inheritanceResolvers = pending.first.inheritanceResolvers;
    if (inheritanceResolvers.isIdenticalWith(lastInlineContentResolvers)) {
      return;
    }
    _childrenBuilder?.add((context, {bool? isLast}) {
      final resolved = inheritanceResolvers.resolve(context);
      if (resolved.whitespaceOrNormal == CssWhitespace.pre) {
        return null;
      }

      return wf.buildTextSpan(
        style: resolved.prepareTextStyle(),
        text: '\u200B',
      );
    });
  }

  void _addPendingLineBoxes(
    List<_PendingString> pending, {
    required bool hasInlineContent,
  }) {
    final maxLines = tree.maxLines;
    if (maxLines > 0) {
      _addLimitedLineBoxes(
        pending,
        hasInlineContent: hasInlineContent,
        maxLines: maxLines,
      );
      return;
    }

    var isFirstLineBreak = true;
    for (final item in pending) {
      final string = item.string;
      if (string.isLineBreak) {
        final skipNormally = isFirstLineBreak && hasInlineContent;
        isFirstLineBreak = false;
        _addLineBox(
          item.inheritanceResolvers,
          onlyForPre: false,
          skipNormally: skipNormally,
        );
        continue;
      }

      if (string.isWhitespace) {
        final count = string.data.codeUnits.where((unit) => unit == 0xA).length;
        for (var i = 0; i < count; i++) {
          _addLineBox(
            item.inheritanceResolvers,
            onlyForPre: true,
            skipNormally: false,
          );
        }
      }
    }
  }

  void _addLimitedLineBoxes(
    List<_PendingString> pending, {
    required bool hasInlineContent,
    required int maxLines,
  }) {
    final placeholder = WidgetPlaceholder(
      builder: (context, _) {
        var remaining = maxLines - (hasInlineContent ? 1 : 0);
        var isFirstLineBreak = true;
        final children = <Widget>[];

        for (final item in pending) {
          final string = item.string;
          final resolved = item.inheritanceResolvers.resolve(context);
          final whitespace = resolved.whitespaceOrNormal;
          var count = 0;
          if (string.isLineBreak) {
            final skipNormally = isFirstLineBreak && hasInlineContent;
            isFirstLineBreak = false;
            if (!skipNormally || whitespace == CssWhitespace.pre) {
              count = 1;
            }
          } else if (string.isWhitespace && whitespace == CssWhitespace.pre) {
            count = string.data.codeUnits.where((unit) => unit == 0xA).length;
          }

          for (var i = 0; i < count && remaining > 0; i++) {
            children.add(
              _LineBox(
                style: resolved.prepareTextStyle(),
                textDirection:
                    resolved.get<TextDirection>() ?? TextDirection.ltr,
              ),
            );
            remaining--;
          }
        }

        if (children.isEmpty) {
          return widget0;
        }
        if (children.length == 1) {
          return children.single;
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: children,
        );
      },
      debugLabel: '${tree.element.localName}--line-break',
    );
    _widgets.add(placeholder);
    _logger.finest('Added ${placeholder.debugLabel} widget');
  }

  void _addLineBox(
    InheritanceResolvers inheritanceResolvers, {
    required bool onlyForPre,
    required bool skipNormally,
  }) {
    final placeholder = WidgetPlaceholder(
      builder: (context, _) {
        final resolved = inheritanceResolvers.resolve(context);
        final whitespace = resolved.whitespaceOrNormal;
        if (onlyForPre && whitespace != CssWhitespace.pre) {
          return widget0;
        }
        if (skipNormally && whitespace != CssWhitespace.pre) {
          return widget0;
        }

        return _LineBox(
          style: resolved.prepareTextStyle(),
          textDirection: resolved.get<TextDirection>() ?? TextDirection.ltr,
        );
      },
      debugLabel: '${tree.element.localName}--line-break',
    );
    _widgets.add(placeholder);
    _logger.finest('Added ${placeholder.debugLabel} widget');
  }

  GestureRecognizer? _getInlineRecognizer(
    BuildContext context,
    InheritedProperties resolved,
  ) {
    final resolvedRecognizer = resolved.gestureRecognizer;
    if (resolvedRecognizer == null) {
      return null;
    }

    final rootProperties = tree.inheritanceResolvers.resolve(context);
    final rootRecognizer = rootProperties.gestureRecognizer;
    if (identical(resolvedRecognizer, rootRecognizer)) {
      return null;
    }

    return resolvedRecognizer;
  }
}

extension on BuildBit {
  InheritanceResolvers? get effectiveInheritanceResolvers {
    // the below code will find the best resolvers for this whitespace bit
    // easy case: whitespace at the beginning of a tag, use the previous style
    final parent = this.parent;
    if (this is! WhitespaceBit) {
      return parent.inheritanceResolvers;
    }
    if (this == parent.first) {
      return null;
    }

    // complicated: whitespace at the end of a tag, try to merge with the next
    // unless it has unrelated styling (e.g. next bit is a sibling)
    if (this == parent.last) {
      final next = nextNonWhitespace;
      if (next != null) {
        var tree = parent;
        while (tree.parent.last == this) {
          tree = tree.parent;
        }

        if (tree.parent == next.parent) {
          return next.parent.inheritanceResolvers;
        } else {
          return null;
        }
      }
    }

    // fallback to parent's
    return parent.inheritanceResolvers;
  }

  BuildBit? get nextNonWhitespace {
    var next = this.next;
    while (next != null && next is WhitespaceBit) {
      next = next.next;
    }

    return next;
  }
}

extension on InheritedProperties {
  CssWhitespace get whitespaceOrNormal => get() ?? CssWhitespace.normal;
}

class _LineBox extends StatelessWidget {
  final TextStyle style;
  final TextDirection textDirection;

  const _LineBox({
    required this.style,
    required this.textDirection,
  });

  @override
  Widget build(BuildContext context) => RichText(
        text: TextSpan(
          style: style,
          text: '\u200B',
          semanticsLabel: '',
        ),
        textDirection: textDirection,
      );
}

@immutable
class _String {
  final String data;
  final bool isLineBreak;
  final bool isWhitespace;
  final bool shouldBeSwallowed;

  const _String(
    this.data, {
    this.isLineBreak = false,
    this.isWhitespace = false,
    this.shouldBeSwallowed = false,
  });
}

@immutable
class _PendingString {
  final InheritanceResolvers inheritanceResolvers;
  final _String string;

  const _PendingString(this.inheritanceResolvers, this.string);
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

      if (str.isWhitespace) {
        switch (whitespace) {
          case CssWhitespace.normal:
            if (!str.shouldBeSwallowed) {
              buffer.write(' ');
            }
          case CssWhitespace.nowrap:
            buffer.write('\u00A0');
          case CssWhitespace.pre:
            buffer.write(str.data);
        }
      } else {
        switch (whitespace) {
          case CssWhitespace.normal:
            buffer.write(str.data);
          case CssWhitespace.nowrap:
            buffer.write(str.data.replaceAll(' ', '\u00A0'));
          case CssWhitespace.pre:
            buffer.write(str.data);
        }
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
