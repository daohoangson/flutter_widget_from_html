import 'package:flutter/widgets.dart';
import 'package:html/dom.dart' as dom;

import '../core_data.dart';
import '../core_data.dart' as core_data show BuildMetadata, BuildTree;
import '../core_helpers.dart';
import '../core_widget_factory.dart';
import 'core_parser.dart';
import 'flattener.dart';

final _regExpSpaceLeading = RegExp(r'^[^\S\u{00A0}]+', unicode: true);
final _regExpSpaceTrailing = RegExp(r'[^\S\u{00A0}]+$', unicode: true);
final _regExpSpaces = RegExp(r'[^\S\u{00A0}]+', unicode: true);

class BuildMetadata extends core_data.BuildMetadata {
  final Iterable<BuildOp> _parentOps;

  List<BuildOp> _buildOps;
  var _buildOpsIsLocked = false;
  bool _isBlockElement;
  List<String> _styles;
  var _stylesIsLocked = false;

  BuildMetadata(dom.Element element, TextStyleBuilder tsb, [this._parentOps])
      : super(element, tsb);

  @override
  Iterable<BuildOp> get buildOps => _buildOps;

  @override
  bool get isBlockElement => _isBlockElement ?? _isBlockElementFrom(_buildOps);

  @override
  Iterable<BuildOp> get parentOps => _parentOps;

  @override
  Iterable<MapEntry<String, String>> get styles sync* {
    assert(_stylesIsLocked);

    final iterator = _styles?.iterator;
    while (iterator?.moveNext() == true) {
      final key = iterator.current;
      if (!iterator.moveNext()) return;
      yield MapEntry(key, iterator.current);
    }
  }

  @override
  set isBlockElement(bool value) {
    assert(!_buildOpsIsLocked, 'Metadata can no longer be changed.');
    _isBlockElement = value;
  }

  @override
  operator []=(String key, String value) {
    if (key == null || value == null) return;

    assert(!_stylesIsLocked, 'Metadata can no longer be changed.');
    _styles ??= [];
    _styles..add(key)..add(value);
  }

  @override
  void register(BuildOp op) {
    if (op == null) return;

    assert(!_buildOpsIsLocked, 'Metadata can no longer be changed.');
    _buildOps ??= [];
    if (!buildOps.contains(op)) _buildOps.add(op);
  }

  void _sortBuildOps() {
    assert(!_buildOpsIsLocked);

    if (_buildOps != null) {
      _buildOps.sort((a, b) => a.priority.compareTo(b.priority));

      // pre-calculate `isBlockElement` for faster access later
      _isBlockElement ??= _isBlockElementFrom(_buildOps);
    } else {
      _isBlockElement ??= false;
    }

    _buildOpsIsLocked = true;
  }

  static bool _isBlockElementFrom(Iterable<BuildOp> ops) =>
      ops?.where((op) => op.isBlockElement)?.length?.compareTo(0) == 1;
}

class BuildTree extends core_data.BuildTree {
  final CustomStylesBuilder customStylesBuilder;
  final CustomWidgetBuilder customWidgetBuilder;
  final BuildMetadata parentMeta;
  final Iterable<BuildOp> parentOps;
  final WidgetFactory wf;

  final _built = <WidgetPlaceholder>[];

  BuildTree({
    this.customStylesBuilder,
    this.customWidgetBuilder,
    BuildTree parent,
    this.parentMeta,
    this.parentOps,
    TextStyleBuilder tsb,
    this.wf,
  }) : super(parent, tsb);

  @override
  BuildBit add(BuildBit bit) {
    assert(_built.isEmpty, "Built tree shouldn't be altered.");
    return super.add(bit);
  }

  void addBitsFromNodes(dom.NodeList domNodes) {
    for (final domNode in domNodes) {
      _addBitsFromNode(domNode);
    }

    if (parentMeta?.buildOps != null) {
      for (final op in parentMeta.buildOps) {
        op.onProcessed?.call(parentMeta, this);
      }
    }
  }

  @override
  Iterable<WidgetPlaceholder> build() {
    if (_built.isNotEmpty) return _built;

    var widgets = _flatten();

    if (parentMeta?.buildOps != null) {
      for (final op in parentMeta.buildOps) {
        widgets = op.onBuilt
                ?.call(parentMeta, widgets)
                ?.map(WidgetPlaceholder.lazy)
                ?.toList(growable: false) ??
            widgets;
      }
    }

    _built.addAll(widgets);
    return _built;
  }

  @override
  BuildBit copyWith({core_data.BuildTree parent, TextStyleBuilder tsb}) {
    final copied = sub(tsb, parent: parent);
    for (final bit in bits) {
      copied.add(bit.copyWith(parent: copied));
    }
    return copied;
  }

  @override
  BuildTree sub(
    TextStyleBuilder tsb, {
    BuildTree parent,
    BuildMetadata parentMeta,
    Iterable<BuildOp> parentOps,
  }) =>
      BuildTree(
        customStylesBuilder: customStylesBuilder,
        customWidgetBuilder: customWidgetBuilder,
        parent: parent ?? this,
        parentMeta: parentMeta ?? this.parentMeta,
        parentOps: parentOps,
        tsb: tsb ?? this.tsb.sub(),
        wf: wf,
      );

  void _addBitsFromNode(dom.Node domNode) {
    if (domNode.nodeType == dom.Node.TEXT_NODE) return _addText(domNode.text);
    if (domNode.nodeType != dom.Node.ELEMENT_NODE) return;

    final element = domNode as dom.Element;
    final meta = BuildMetadata(element, parentMeta.tsb().sub(), parentOps);
    final customWidget = customWidgetBuilder?.call(element);
    if (customWidget != null) meta.isBlockElement = true;

    _collectMetadata(meta);

    final subTree = sub(
      meta.tsb(),
      parentMeta: meta,
      parentOps: _prepareParentOps(parentOps, meta),
    );
    add(subTree);

    if (customWidget != null) {
      // skip sub tree processing if a custom widget found
      subTree.add(WidgetBit.block(subTree, customWidget));
    } else {
      subTree.addBitsFromNodes(element.nodes);
    }

    if (meta.isBlockElement) {
      for (final widget in subTree.build()) {
        add(WidgetBit.block(this, widget));
      }
      subTree.detach();
    }
  }

  void _addText(String data) {
    final leading = _regExpSpaceLeading.firstMatch(data);
    final trailing = _regExpSpaceTrailing.firstMatch(data);
    final start = leading == null ? 0 : leading.end;
    final end = trailing == null ? data.length : trailing.start;

    if (end <= start) {
      addWhitespace();
      return;
    }

    if (start > 0) addWhitespace();

    final substring = data.substring(start, end);
    final dedup = substring.replaceAll(_regExpSpaces, ' ');
    addText(dedup);

    if (end < data.length) addWhitespace();
  }

  void _collectMetadata(BuildMetadata meta) {
    wf.parse(meta);

    if (meta.parentOps != null) {
      for (final op in meta.parentOps) {
        op.onChild?.call(meta);
      }
    }

    // stylings, step 1: get default styles from tag-based build ops
    if (meta.buildOps != null) {
      for (final op in meta.buildOps) {
        final map = op.defaultStyles?.call(meta);
        if (map == null) continue;

        meta._styles ??= [];
        for (final pair in map.entries) {
          if (pair.key == null || pair.value == null) continue;
          meta._styles.insertAll(0, [pair.key, pair.value]);
        }
      }
    }

    // integration point: apply custom builders
    _customStylesBuilder(meta);

    // stylings, step 2: get styles from `style` attribute
    final attrs = meta.element.attributes;
    if (attrs.containsKey('style')) {
      for (final pair in splitAttributeStyle(attrs['style'])) {
        meta[pair.key] = pair.value;
      }
    }

    meta._stylesIsLocked = true;
    for (final style in meta.styles) {
      wf.parseStyle(meta, style.key, style.value);
    }

    if (meta.isBlockElement) {
      meta.register(wf.styleDisplayBlock());
    }

    meta._sortBuildOps();
  }

  void _customStylesBuilder(BuildMetadata meta) {
    final map = customStylesBuilder?.call(meta.element);
    if (map == null) return;

    for (final pair in map.entries) {
      meta[pair.key] = pair.value;
    }
  }

  Iterable<WidgetPlaceholder> _flatten() {
    final widgets = <WidgetPlaceholder>[];

    for (final flattened in Flattener(this).flatten()) {
      if (flattened.widget != null) {
        widgets.add(flattened.widget);
        continue;
      }

      if (flattened.builder == null) continue;
      widgets.add(
        WidgetPlaceholder<BuildTree>(this).wrapWith((context, _) {
          final span = flattened.builder(context);
          if (span == null || span is! InlineSpan) return widget0;

          final tsh = tsb?.build(context);
          final textAlign = tsh?.textAlign ?? TextAlign.start;

          if (span is WidgetSpan &&
              span.alignment == PlaceholderAlignment.baseline &&
              textAlign == TextAlign.start) {
            return span.child;
          }

          return wf.buildText(parentMeta, tsh, span);
        }),
      );
    }

    return widgets;
  }
}

Iterable<BuildOp> _prepareParentOps(Iterable<BuildOp> ops, BuildMetadata meta) {
  // try to reuse existing list if possible
  final withOnChild =
      meta.buildOps?.where((op) => op.onChild != null)?.toList();
  return withOnChild?.isNotEmpty != true
      ? ops
      : List.unmodifiable([if (ops != null) ...ops, ...withOnChild]);
}
