import 'dart:collection';

import 'package:csslib/parser.dart' as css;
import 'package:csslib/visitor.dart' as css;
import 'package:flutter/widgets.dart';
import 'package:html/dom.dart' as dom;
import 'package:logging/logging.dart';

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

final _logger = Logger('fwfh.CoreBuildTree');
final _rootElement = dom.Element.tag('root');

class CoreBuildTree extends BuildTree {
  final CustomStylesBuilder? customStylesBuilder;
  final CustomWidgetBuilder? customWidgetBuilder;
  final WidgetFactory wf;

  final BuildTree? _parent;
  final Iterable<_CoreBuildOp> _parentOps;
  final _styles = _LockableDeclarations();

  SplayTreeSet<_CoreBuildOp>? _buildOps;
  bool? _isInline;

  CoreBuildTree._({
    this.customStylesBuilder,
    this.customWidgetBuilder,
    required super.element,
    required super.inheritanceResolvers,
    BuildTree? parent,
    Iterable<_CoreBuildOp> parentOps = const [],
    required this.wf,
  })  : _parent = parent,
        _parentOps = parentOps;

  factory CoreBuildTree.root({
    CustomStylesBuilder? customStylesBuilder,
    CustomWidgetBuilder? customWidgetBuilder,
    required InheritanceResolvers inheritanceResolvers,
    required WidgetFactory wf,
  }) =>
      CoreBuildTree._(
        customStylesBuilder: customStylesBuilder,
        customWidgetBuilder: customWidgetBuilder,
        element: _rootElement,
        inheritanceResolvers: inheritanceResolvers,
        wf: wf,
      );

  @override
  bool get hasParent => _parent != null;

  @override
  bool? get isInline => _isInline;

  @override
  BuildTree get parent => _parent!;

  @override
  LockableList<css.Declaration> get styles => _styles;

  @override
  void operator []=(String key, String value) {
    final styleSheet = css.parse('*{$key: $value;}');
    _styles.addAll(styleSheet.collectDeclarations());
  }

  void addBitsFromNodes(dom.NodeList domNodes) {
    for (final domNode in domNodes) {
      _addBitsFromNode(domNode);
    }
  }

  @override
  WidgetPlaceholder? build() {
    final children = Flattener(wf, this).widgets;
    final column = wf.buildColumnPlaceholder(this, children);
    if (column == null && _buildOps == null) {
      return null;
    }

    var placeholder = column ?? const _WidgetPlaceholderDefault();
    final Iterable<_CoreBuildOp> ops = _buildOps ?? const [];
    for (final op in ops) {
      placeholder = WidgetPlaceholder.lazy(
        op.onRenderBlock(placeholder),
        debugLabel: '${element.localName}--${op.op.debugLabel ?? 'lazy'}',
      );
    }

    if (placeholder.isEmpty) {
      return null;
    }

    // TODO: avoid special handling of anchors
    Anchor.wrapWidgetAnchors(this, placeholder);

    for (final op in ops) {
      op.onRenderedBlock(placeholder);
    }

    return placeholder;
  }

  @override
  CoreBuildTree copyWith({
    bool copyContents = true,
    dom.Element? element,
    InheritanceResolvers? inheritanceResolvers,
    BuildTree? parent,
  }) {
    final copiedParent = parent ?? this.parent;
    final scopedInheritanceResolvers = inheritanceResolvers ??
        this
            .inheritanceResolvers
            .copyWith(parent: copiedParent.inheritanceResolvers);
    final copied = CoreBuildTree._(
      customStylesBuilder: customStylesBuilder,
      customWidgetBuilder: customWidgetBuilder,
      element: element ?? this.element,
      inheritanceResolvers: scopedInheritanceResolvers,
      parent: copiedParent,
      parentOps: copiedParent is CoreBuildTree
          ? _prepareParentOps(copiedParent._parentOps, copiedParent)
          : const [],
      wf: wf,
    );

    if (copyContents) {
      copied.setNonInheriteds(this);

      for (final bit in children) {
        copied.append(bit.copyWith(parent: copied));
      }

      final scopedBuildOps = _buildOps;
      if (scopedBuildOps != null) {
        for (final op in scopedBuildOps) {
          copied.register(op.op);
        }
      }

      copied._styles.addAll(_styles);
    }

    return copied;
  }

  @override
  void flatten(Flattened _) {
    final scopedBuildOps = _buildOps;
    if (scopedBuildOps != null) {
      for (final op in scopedBuildOps) {
        op.onRenderInline();
      }
    }
  }

  @override
  css.Declaration? getStyle(String property) {
    final values = _styles._values;
    if (values == null) {
      return null;
    }

    for (final style in values.reversed) {
      if (style.property == property) {
        // TODO: add support for `!important`
        // https://github.com/daohoangson/flutter_widget_from_html/issues/773
        return style;
      }
    }

    return null;
  }

  @override
  void register(BuildOp op) {
    final scopedBuildOps = _buildOps ??= _CoreBuildOp._newSet();
    scopedBuildOps.add(_CoreBuildOp(this, op));
    _logger.finest(
      'Registered ${op.debugLabel ?? 'a build op'} '
      'for ${element.localName?.toUpperCase()} tag',
    );
  }

  @override
  CoreBuildTree sub({dom.Element? element}) => copyWith(
        copyContents: false,
        element: element,
        inheritanceResolvers: inheritanceResolvers.sub(),
        parent: this,
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
      _logger.fine('Custom widget for ${element.localName?.toUpperCase()} tag');
      return;
    }

    final subBuilder = sub(element: element)
      .._parseEverything()
      ..addBitsFromNodes(element.nodes);

    final subBuildOps = subBuilder._buildOps;
    final isBlock = subBuildOps?.where(_renderBlock).isNotEmpty == true;
    subBuilder._isInline = !isBlock;

    BuildTree subTree = subBuilder;
    if (subBuildOps != null) {
      for (final op in subBuildOps) {
        subTree = op.onParsed(subTree);
      }
    }

    if (isBlock) {
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
    final start = leading?.end ?? 0;
    final end = trailing?.start ?? data.length;

    if (end <= start) {
      // the string contains all spaces
      addWhitespace(data);
      return;
    }

    if (leading != null) {
      addWhitespace(leading.group(0)!);
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

    if (trailing != null) {
      addWhitespace(trailing.group(0)!);
    }
  }

  void _customStylesBuilder() {
    final map = customStylesBuilder?.call(element);
    if (map == null) {
      return;
    }

    _logger.fine('Custom styles for ${element.localName?.toUpperCase()}: $map');
    final str = map.entries.map((e) => '${e.key}: ${e.value}').join(';');
    final styleSheet = css.parse('*{$str}');

    final customStyles = styleSheet.collectDeclarations();
    _styles.addAll(customStyles);
  }

  void _parseEverything() {
    wf.parse(this);

    for (final op in _parentOps) {
      op.onVisitChild(this);
    }

    final scopedBuildOps = _buildOps;
    if (scopedBuildOps != null) {
      for (final op in scopedBuildOps) {
        final defaultStyles = op.defaultStyles;
        if (defaultStyles != null) {
          _styles.insertAll(0, defaultStyles);
        }
      }
    }

    _customStylesBuilder();

    final elementStyles = element.styles;
    if (elementStyles.isNotEmpty) {
      _styles.addAll(elementStyles);
    }

    _styles._isLocked = true;
    final values = _styles._values;
    if (values != null) {
      for (final style in values.toList(growable: false)) {
        wf.parseStyle(this, style);
      }
    }

    wf.parseStyleDisplay(this, getStyle(kCssDisplay)?.term);
  }
}

Iterable<_CoreBuildOp> _prepareParentOps(
  Iterable<_CoreBuildOp> ops,
  CoreBuildTree builder,
) {
  // try to reuse existing list if possible
  final newOps = builder._buildOps
      ?.where((op) => op.op.onVisitChild != null)
      .toList(growable: false);
  return newOps != null && newOps.isNotEmpty == true
      ? List.unmodifiable([...ops, ...newOps])
      : ops;
}

bool _renderBlock(_CoreBuildOp op) =>
    op.op.alwaysRenderBlock ?? op.op.onRenderBlock != null;

@immutable
class _CoreBuildOp {
  final BuildOp op;
  final CoreBuildTree tree;

  const _CoreBuildOp(this.tree, this.op);

  List<css.Declaration>? get defaultStyles {
    final map = op.defaultStyles?.call(tree.element);
    if (map == null) {
      return null;
    }

    final str = map.entries.map((e) => '${e.key}: ${e.value}').join(';');
    final styleSheet = css.parse('*{$str}');
    return styleSheet.collectDeclarations();
  }

  BuildTree onParsed(BuildTree input) => op.onParsed?.call(input) ?? input;

  Widget onRenderBlock(WidgetPlaceholder placeholder) =>
      op.onRenderBlock?.call(tree, placeholder) ?? placeholder;

  void onRenderInline() => op.onRenderInline?.call(tree);

  void onRenderedBlock(WidgetPlaceholder placeholder) =>
      op.onRenderedBlock?.call(tree, placeholder);

  void onVisitChild(BuildTree subTree) => op.onVisitChild?.call(tree, subTree);

  static SplayTreeSet<_CoreBuildOp> _newSet() => SplayTreeSet(_compare);

  static int _compare(_CoreBuildOp a0, _CoreBuildOp b0) {
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

class _LockableDeclarations extends LockableList<css.Declaration> {
  var _isLocked = false;
  List<css.Declaration>? _values;

  @override
  bool get isLocked => _isLocked;

  @override
  Iterator<css.Declaration> get iterator =>
      _values?.iterator ?? const <css.Declaration>[].iterator;

  @override
  void add(css.Declaration value) {
    assert(!_isLocked, 'Adding after being locked is undeterministic.');
    _values ??= [];
    _values?.add(value);
  }

  @override
  void addAll(Iterable<css.Declaration> iterable) {
    assert(!_isLocked, 'Adding after being locked is undeterministic.');
    _values ??= [];
    _values?.addAll(iterable);
  }

  @override
  void insert(int index, css.Declaration element) {
    assert(!_isLocked, 'Inserting after being locked is undeterministic.');
    _values ??= [];
    _values?.insert(index, element);
  }

  @override
  void insertAll(int index, Iterable<css.Declaration> iterable) {
    assert(!_isLocked, 'Inserting after being locked is undeterministic.');
    _values ??= [];
    _values?.insertAll(index, iterable);
  }
}

class _WidgetPlaceholderDefault extends StatelessWidget
    implements
        // ignore: avoid_implementing_value_types
        WidgetPlaceholder {
  const _WidgetPlaceholderDefault();

  @override
  Widget build(BuildContext context) => widget0;

  @override
  Widget callBuilders(BuildContext context, Widget? child) => child ?? widget0;

  @override
  String? get debugLabel => null;

  @override
  bool get isEmpty => true;

  @override
  WidgetPlaceholder wrapWith(WidgetPlaceholderBuilder builder) {
    // We don't want to waste time creating unneccessary placeholder,
    // this const default placeholder is used instead.
    // Create a real one when the first builder is provided.
    return WidgetPlaceholder(builder: builder);
  }
}
