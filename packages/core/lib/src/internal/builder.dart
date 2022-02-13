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

class Builder extends BuildTree implements BuildMetadata {
  static final _buildOps = Expando<Set<_BuilderOp>>();
  static final _declarations = Expando<List<css.Declaration>>();
  static final _maxLines = Expando<int>();
  static final _overflows = Expando<TextOverflow>();

  final CustomStylesBuilder? customStylesBuilder;
  final CustomWidgetBuilder? customWidgetBuilder;

  @override
  final dom.Element element;

  @override
  final Iterable<BuildOp> parentOps;

  final WidgetFactory wf;

  final HtmlStyleBuilder _styleBuilder;

  Builder({
    this.customStylesBuilder,
    this.customWidgetBuilder,
    required this.element,
    BuildTree? parent,
    this.parentOps = const [],
    required HtmlStyleBuilder styleBuilder,
    required this.wf,
  })  : _styleBuilder = styleBuilder,
        super(parent);

  @override
  Iterable<BuildOp> get buildOps =>
      _buildOpSet?.map(_BuilderOp._unwrap) ?? const [];

  Set<_BuilderOp>? get _buildOpSet => _buildOps[this];

  @override
  int get maxLines => _maxLines[this] ?? -1;

  @override
  set maxLines(int value) => _maxLines[this] = value;

  @override
  TextOverflow get overflow => _overflows[this] ?? TextOverflow.clip;

  @override
  set overflow(TextOverflow value) => _overflows[this] = value;

  @override
  Iterable<css.Declaration> get styles => _declarationList ?? const [];

  List<css.Declaration>? get _declarationList => _declarations[this];

  @override
  BuildTree get tree => this;

  @override
  HtmlStyleBuilder get tsb => _styleBuilder;

  @override
  void operator []=(String key, String value) {
    final styleSheet = css.parse('*{$key: $value;}');
    final customStyles = styleSheet.collectDeclarations();

    final declarations = _declarationList;
    if (declarations != null) {
      declarations.addAll(customStyles);
    } else {
      _declarations[this] = [...customStyles];
    }
  }

  @override
  css.Declaration? operator [](String key) {
    final declarations = _declarationList;
    if (declarations != null) {
      for (final style in declarations.reversed) {
        if (style.property == key) {
          return style;
        }
      }
    }

    return null;
  }

  void addBitsFromNodes(dom.NodeList domNodes) {
    for (final domNode in domNodes) {
      _addBitsFromNode(domNode);
    }

    final ops = _buildOpSet;
    if (ops != null) {
      for (final op in ops) {
        op.onTree();
      }
    }
  }

  @override
  Iterable<WidgetPlaceholder> build() {
    var widgets = Flattener(wf, this, this).widgets;
    final ops = _buildOpSet;
    if (ops != null) {
      for (final op in ops) {
        widgets = op.onWidgets(widgets) ?? widgets;
      }
    }

    final thisAnchors = anchors;
    if (thisAnchors != null) {
      var needsColumn = false;
      for (final widget in widgets) {
        if (widget.anchors == null) {
          // the current tree has some anchors
          // but at least one of its widgets doesn't self-announce
          // we need a column to wrap things and announce up the chain
          needsColumn = true;
          break;
        }
      }

      if (needsColumn) {
        widgets = listOrNull(
              wf.buildColumnPlaceholder(this, widgets)
                ?..setAnchorsIfUnset(thisAnchors),
            ) ??
            const [];
      }
    }

    return widgets;
  }

  @override
  Builder copyWith({
    bool copyContents = true,
    dom.Element? element,
    BuildTree? parent,
    HtmlStyleBuilder? styleBuilder,
  }) {
    final p = parent ?? this.parent;
    final sb = styleBuilder ?? _styleBuilder.copyWith(parent: p?.tsb);
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
      final ops = _buildOpSet;
      if (ops != null) {
        final copiedOps = _BuilderOp._newSet();
        for (final op in ops) {
          copiedOps.add(_BuilderOp(copied, op.op));
        }
        _buildOps[copied] = copiedOps;
      }

      _declarations[copied] = _declarations[this];
      _maxLines[copied] = _maxLines[this];
      _overflows[copied] = _overflows[this];

      for (final bit in children) {
        copied.append(bit.copyWith(parent: copied));
      }
    }

    return copied;
  }

  @override
  void flatten(Flattened f) {
    final ops = _buildOpSet;
    if (ops != null) {
      for (final op in ops) {
        op.onTreeFlattening(f);
      }
    }
  }

  @override
  void register(BuildOp op) {
    final existingSet = _buildOpSet;
    final op0 = _BuilderOp(this, op);
    if (existingSet != null) {
      existingSet.add(op0);
    } else {
      _buildOps[this] = _BuilderOp._newSet()..add(op0);
    }
  }

  @override
  Builder sub({dom.Element? element}) => copyWith(
        copyContents: false,
        element: element,
        parent: this,
        styleBuilder: _styleBuilder.sub(),
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
      .._collectMetadata()
      ..addBitsFromNodes(element.nodes);

    if (subTree.buildOps.where(_opRequiresBuildingSubtree).isNotEmpty) {
      for (final widget in subTree.build()) {
        append(WidgetBit.block(this, widget));
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

  void _collectMetadata() {
    wf.parse(this);

    for (final op in parentOps) {
      op.onChild?.call(this);
    }

    // stylings, step 1: get default styles from tag-based build ops
    final ops = _buildOpSet;
    if (ops != null) {
      for (final op in ops) {
        final defaultStyles = op.defaultStyles;
        if (defaultStyles != null) {
          final declarations = _declarationList;
          if (declarations != null) {
            declarations.insertAll(0, defaultStyles);
          } else {
            _declarations[this] = [...defaultStyles];
          }
        }
      }
    }

    _customStylesBuilder();

    // stylings, step 2: get styles from `style` attribute
    final elementStyles = element.styles;
    if (elementStyles.isNotEmpty) {
      final declarations = _declarationList;
      if (declarations != null) {
        declarations.addAll(elementStyles);
      } else {
        _declarations[this] = [...elementStyles];
      }
    }

    final finalDeclarations = _declarationList;
    if (finalDeclarations != null) {
      for (final style in finalDeclarations) {
        wf.parseStyle(this, style);
      }
    }

    wf.parseStyleDisplay(this, this[kCssDisplay]?.term);
  }

  void _customStylesBuilder() {
    final map = customStylesBuilder?.call(element);
    if (map == null) {
      return;
    }

    final str = map.entries.map((e) => '${e.key}: ${e.value}').join(';');
    final styleSheet = css.parse('*{$str}');

    final customStyles = styleSheet.collectDeclarations();
    final declarations = _declarationList;
    if (declarations != null) {
      declarations.addAll(customStyles);
    } else {
      _declarations[this] = [...customStyles];
    }
  }
}

class _BuilderOp {
  final BuildOp op;
  _BuilderType? type;
  final Builder tree;

  _BuilderOp(this.tree, this.op);

  List<css.Declaration>? get defaultStyles {
    final map = op.defaultStyles?.call(tree.element);
    if (map == null) {
      return null;
    }

    final str = map.entries.map((e) => '${e.key}: ${e.value}').join(';');
    final styleSheet = css.parse('*{$str}');
    return styleSheet.collectDeclarations();
  }

  void onTree() => op.onTree?.call(tree, tree);

  bool onTreeFlattening(Flattened f) {
    if (type == _BuilderType.onWidgets) {
      return false;
    }

    final prevType = type;
    type = _BuilderType.onTreeFlattening;

    final result = op.onTreeFlattening?.call(tree, tree, f) ?? false;
    if (!result) {
      type = prevType;
    }

    return result;
  }

  Iterable<WidgetPlaceholder>? onWidgets(Iterable<WidgetPlaceholder> widgets) {
    if (type == _BuilderType.onTreeFlattening) {
      return null;
    }

    final prevType = type;
    type = _BuilderType.onWidgets;

    final result = op.onWidgets
        ?.call(tree, widgets)
        ?.map(WidgetPlaceholder.lazy)
        .toList(growable: false);
    if (result == null) {
      type = prevType;
    }

    return result;
  }

  @override
  String toString() {
    return '_BuilderOp#${op.hashCode}';
  }

  static int _compare(_BuilderOp a0, _BuilderOp b0) {
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

  static Set<_BuilderOp> _newSet() => SplayTreeSet<_BuilderOp>(_compare);

  static BuildOp _unwrap(_BuilderOp _) => _.op;
}

enum _BuilderType {
  onTreeFlattening,
  onWidgets,
}

bool _opRequiresBuildingSubtree(BuildOp op) =>
    op.onWidgets != null && !op.onWidgetsIsOptional;

Iterable<BuildOp> _prepareParentOps(Iterable<BuildOp> ops, BuildMetadata meta) {
  // try to reuse existing list if possible
  final newOps = meta.buildOps.where((op) => op.onChild != null).toList();
  return newOps.isEmpty ? ops : List.unmodifiable([...ops, ...newOps]);
}
