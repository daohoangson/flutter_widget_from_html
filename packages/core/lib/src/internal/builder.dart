import 'dart:collection';

import 'package:csslib/parser.dart' as css;
import 'package:csslib/visitor.dart' as css;
import 'package:flutter/widgets.dart';

import 'package:html/dom.dart' as dom;

import '../core_data.dart';
import '../core_helpers.dart';
import '../core_widget_factory.dart';
import 'core_ops.dart';
import 'flattener.dart';

// https://infra.spec.whatwg.org/#ascii-whitespace
const _asciiWhitespace = r'[\u{0009}\u{000A}\u{000C}\u{000D}\u{0020}]';
final _regExpSpaceLeading = RegExp('^$_asciiWhitespace+', unicode: true);
final _regExpSpaceTrailing = RegExp('$_asciiWhitespace+\$', unicode: true);
final _regExpSpaces = RegExp('$_asciiWhitespace+', unicode: true);

class Builder extends BuildTree {
  final CustomStylesBuilder? customStylesBuilder;
  final CustomWidgetBuilder? customWidgetBuilder;
  final Iterable<BuilderOp> parentOps;
  final WidgetFactory wf;

  final _buildOps = SplayTreeSet<BuilderOp>(BuilderOp._compare);
  final _styles = <css.Declaration>[];

  Builder({
    required this.customStylesBuilder,
    required this.customWidgetBuilder,
    required dom.Element element,
    BuildTree? parent,
    this.parentOps = const [],
    required HtmlStyleBuilder styleBuilder,
    required this.wf,
  }) : super(
          element: element,
          parent: parent,
          styleBuilder: styleBuilder,
        );

  @override
  Iterable<css.Declaration> get styles => _styles;

  @override
  void operator []=(String key, String value) {
    final styleSheet = css.parse('*{$key: $value;}');
    final customStyles = styleSheet.collectDeclarations();
    _styles.addAll(customStyles);
  }

  @override
  css.Declaration? operator [](String key) {
    for (final style in _styles.reversed) {
      if (style.property == key) {
        return style;
      }
    }

    return null;
  }

  void addBitsFromNodes(dom.NodeList domNodes) {
    for (final domNode in domNodes) {
      _addBitsFromNode(domNode);
    }

    for (final op in _buildOps) {
      op.onTree();
    }
  }

  @override
  WidgetPlaceholder? build() {
    final children = Flattener(wf, this).widgets;
    final column = wf.buildColumnPlaceholder(this, children);
    if (column == null && _buildOps.isEmpty) {
      return null;
    }

    var placeholder = column ??
        WidgetPlaceholder(debugLabel: '${element.localName}--default');
    for (final op in _buildOps) {
      placeholder = WidgetPlaceholder.lazy(
        op.onBuilt(placeholder) ?? placeholder,
        debugLabel: '${element.localName}--${op.op.debugLabel ?? 'lazy'}',
      );
    }

    if (placeholder.isEmpty) {
      return null;
    }

    return placeholder..setAnchorsIfUnset(anchors);
  }

  @override
  Builder copyWith({
    bool copyContents = true,
    dom.Element? element,
    BuildTree? parent,
    HtmlStyleBuilder? styleBuilder,
  }) {
    final p = parent ?? this.parent;
    final sb =
        styleBuilder ?? this.styleBuilder.copyWith(parent: p?.styleBuilder);
    final copied = Builder(
      customStylesBuilder: customStylesBuilder,
      customWidgetBuilder: customWidgetBuilder,
      element: element ?? this.element,
      parent: p,
      parentOps: p is Builder ? _prepareParentOps(p.parentOps, p) : const [],
      styleBuilder: sb,
      wf: wf,
    );

    if (copyContents) {
      copyTo(copied);

      for (final bit in children) {
        copied.append(bit.copyWith(parent: copied));
      }

      for (final op in _buildOps) {
        copied.register(op.op);
      }

      copied._styles.addAll(_styles);
    }

    return copied;
  }

  @override
  void flatten(Flattened _) {
    for (final op in _buildOps) {
      op.onFlattening();
    }
  }

  @override
  void register(BuildOp op) => _buildOps.add(BuilderOp._(this, op));

  @override
  Builder sub({dom.Element? element}) => copyWith(
        copyContents: false,
        element: element,
        parent: this,
        styleBuilder: styleBuilder.sub(),
      );

  void _addBitsFromNode(dom.Node domNode) {
    if (domNode.nodeType == dom.Node.TEXT_NODE) {
      final text = domNode as dom.Text;
      return _addText(text.data);
    }
    if (domNode.nodeType != dom.Node.ELEMENT_NODE) {
      return;
    }

    final element = domNode as dom.Element;
    final customWidget = customWidgetBuilder?.call(element);
    if (customWidget != null) {
      append(WidgetBit.block(this, customWidget));
      // skip further processing if a custom widget found
      return;
    }

    final subTree = sub(element: element)
      .._parseEverything()
      ..addBitsFromNodes(element.nodes);

    if (subTree._buildOps.where(_mustBeBlock).isNotEmpty) {
      final builtSubTree = subTree.build();
      if (builtSubTree != null) {
        append(WidgetBit.block(this, builtSubTree));
      }
    } else {
      append(subTree);
    }
  }

  void _addText(String data) {
    final leading = _regExpSpaceLeading.firstMatch(data);
    final trailing = _regExpSpaceTrailing.firstMatch(data);
    final start = leading == null ? 0 : leading.end;
    final end = trailing == null ? data.length : trailing.start;

    if (end <= start) {
      // the string contains all spaces
      addWhitespace(data);
      return;
    }

    if (start > 0) {
      addWhitespace(leading!.group(0)!);
    }

    final contents = data.substring(start, end);
    final spaces = _regExpSpaces.allMatches(contents);
    var offset = 0;
    for (final space in [...spaces, null]) {
      if (space == null) {
        // reaches end of string
        final text = contents.substring(offset);
        if (text.isNotEmpty) {
          addText(text);
        }
        break;
      } else {
        final spaceData = space.group(0)!;
        if (spaceData == ' ') {
          // micro optimization: ignore single space (ASCII 32)
          continue;
        }

        final text = contents.substring(offset, space.start);
        addText(text);

        addWhitespace(spaceData);
        offset = space.end;
      }
    }

    if (end < data.length) {
      addWhitespace(trailing!.group(0)!);
    }
  }

  void _customStylesBuilder() {
    final map = customStylesBuilder?.call(element);
    if (map == null) {
      return;
    }

    final str = map.entries.map((e) => '${e.key}: ${e.value}').join(';');
    final styleSheet = css.parse('*{$str}');

    final customStyles = styleSheet.collectDeclarations();
    _styles.addAll(customStyles);
  }

  void _parseEverything() {
    wf.parse(this);

    for (final op in parentOps) {
      op.onChild(this);
    }

    // stylings, step 1: get default styles from tag-based build ops
    for (final op in _buildOps) {
      final defaultStyles = op.defaultStyles;
      if (defaultStyles != null) {
        _styles.insertAll(0, defaultStyles);
      }
    }

    _customStylesBuilder();

    // stylings, step 2: get styles from `style` attribute
    final elementStyles = element.styles;
    if (elementStyles.isNotEmpty) {
      _styles.addAll(elementStyles);
    }

    // stylings, step 3: parse one by one
    for (final style in _styles) {
      wf.parseStyle(this, style);
    }

    wf.parseStyleDisplay(this, this[kCssDisplay]?.term);
  }
}

class BuilderOp {
  final BuildOp op;
  final Builder tree;

  var _onBuilt = false;

  BuilderOp._(this.tree, this.op);

  List<css.Declaration>? get defaultStyles {
    final map = op.defaultStyles?.call(tree);
    if (map == null) {
      return null;
    }

    final str = map.entries.map((e) => '${e.key}: ${e.value}').join(';');
    final styleSheet = css.parse('*{$str}');
    return styleSheet.collectDeclarations();
  }

  void onChild(BuildTree subTree) => op.onChild?.call(tree, subTree);

  void onTree() => op.onTree?.call(tree);

  void onFlattening() {
    if (_onBuilt) {
      return;
    }

    op.onFlattening?.call(tree);
  }

  Widget? onBuilt(WidgetPlaceholder placeholder) {
    final result = op.onBuilt?.call(tree, placeholder);

    if (result != null) {
      _onBuilt = true;
    }

    return result;
  }

  static int _compare(BuilderOp a0, BuilderOp b0) {
    final a = a0.op;
    final b = b0.op;
    if (identical(a, b)) {
      return 0;
    }

    final cmp = a.priority.compareTo(b.priority);
    if (cmp == 0) {
      // if two ops have the same priority, they should not be considered equal
      // fallback to compare hash codes for stable sorting
      // while still provide pseudo random order across different runs
      return a.hashCode.compareTo(b.hashCode);
    } else {
      return cmp;
    }
  }
}

bool _mustBeBlock(BuilderOp op) => op.op.mustBeBlock ?? op.op.onBuilt != null;

Iterable<BuilderOp> _prepareParentOps(
  Iterable<BuilderOp> ops,
  Builder builder,
) {
  // try to reuse existing list if possible
  final newOps = builder._buildOps
      .where((op) => op.op.onChild != null)
      .toList(growable: false);
  return newOps.isNotEmpty == true
      ? List.unmodifiable([...ops, ...newOps])
      : ops;
}
