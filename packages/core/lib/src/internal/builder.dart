import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:html/dom.dart' as dom;

import '../core_data.dart';
import '../core_data.dart' as core_data show BuildMetadata, BuildTree;
import '../core_helpers.dart';
import '../core_widget_factory.dart';
import 'core_ops.dart';
import 'flattener.dart';

final _regExpSpaceLeading = RegExp(r'^[^\S\u{00A0}]+', unicode: true);
final _regExpSpaceTrailing = RegExp(r'[^\S\u{00A0}]+$', unicode: true);
final _regExpSpaces = RegExp(r'[^\S\u{00A0}]+', unicode: true);

class BuildMetadata extends core_data.BuildMetadata {
  final Iterable<BuildOp> _parentOps;

  Set<BuildOp> _buildOps;
  var _buildOpsIsLocked = false;
  List<InlineStyle> _styles;
  var _stylesIsLocked = false;
  bool _willBuildSubtree;

  BuildMetadata(dom.Element element, TextStyleBuilder tsb, [this._parentOps])
      : super(element, tsb);

  @override
  Iterable<BuildOp> get buildOps => _buildOps;

  @override
  Iterable<BuildOp> get parentOps => _parentOps;

  @override
  List<InlineStyle> get styles {
    assert(_stylesIsLocked);
    return _styles ?? const [];
  }

  @override
  bool get willBuildSubtree => _willBuildSubtree;

  @override
  operator []=(String key, String value) {
    if (key == null || value == null) return;

    assert(!_stylesIsLocked, 'Metadata can no longer be changed.');
    _styles ??= [];
    _styles.add(InlineStyle(key, value));
  }

  @override
  void register(BuildOp op) {
    if (op == null) return;

    assert(!_buildOpsIsLocked, 'Metadata can no longer be changed.');
    _buildOps ??= SplayTreeSet(_compareBuildOps);
    _buildOps.add(op);
  }
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
        op.onTree?.call(parentMeta, this);
      }
    }
  }

  @override
  Iterable<WidgetPlaceholder> build() {
    if (_built.isNotEmpty) return _built;

    var widgets = _flatten();

    if (parentMeta?.buildOps != null) {
      for (final op in parentMeta.buildOps) {
        widgets = op.onWidgets
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
  BuildTree sub({
    core_data.BuildTree parent,
    BuildMetadata parentMeta,
    Iterable<BuildOp> parentOps,
    TextStyleBuilder tsb,
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
    final customWidget = customWidgetBuilder?.call(element);
    if (customWidget != null) {
      add(WidgetBit.block(this, customWidget));
      // skip further processing if a custom widget found
      return;
    }

    final meta = BuildMetadata(element, parentMeta.tsb().sub(), parentOps);
    _collectMetadata(meta);

    final subTree = sub(
      parentMeta: meta,
      parentOps: _prepareParentOps(parentOps, meta),
      tsb: meta.tsb(),
    );
    add(subTree);

    subTree.addBitsFromNodes(element.nodes);

    if (meta.willBuildSubtree) {
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
        final map = op.defaultStyles?.call(meta.element);
        if (map == null) continue;

        meta._styles ??= [];
        for (final pair in map.entries) {
          if (pair.key == null || pair.value == null) continue;
          meta._styles.insert(0, InlineStyle(pair.key, pair.value));
        }
      }
    }

    _customStylesBuilder(meta);

    // stylings, step 2: get styles from `style` attribute
    for (final pair in meta.element.styles) {
      meta[pair.key] = pair.value;
    }

    meta._stylesIsLocked = true;
    for (final style in meta.styles) {
      wf.parseStyle(meta, style.key, style.value);
    }

    wf.parseStyleDisplay(meta, meta[kCssDisplay]);

    meta._willBuildSubtree = meta[kCssDisplay] == kCssDisplayBlock ||
        meta._buildOps?.where(_opRequiresBuildingSubtree)?.isNotEmpty == true;
    meta._buildOpsIsLocked = true;
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

    for (final flattened in flatten(this)) {
      if (flattened.widget != null) {
        widgets.add(WidgetPlaceholder.lazy(flattened.widget));
        continue;
      }

      if (flattened.widgetBuilder != null) {
        widgets.add(WidgetPlaceholder<BuildTree>(this)
            .wrapWith((context, _) => flattened.widgetBuilder(context)));
        continue;
      }

      if (flattened.spanBuilder == null) continue;
      widgets.add(WidgetPlaceholder<BuildTree>(this).wrapWith((context, _) {
        final span = flattened.spanBuilder(context);
        if (span == null || span is! InlineSpan) return widget0;

        final tsh = tsb?.build(context);
        final textAlign = tsh?.textAlign ?? TextAlign.start;

        if (span is WidgetSpan &&
            span.alignment == PlaceholderAlignment.baseline &&
            textAlign == TextAlign.start) {
          return span.child;
        }

        return wf.buildText(parentMeta, tsh, span);
      }));
    }

    return widgets;
  }
}

int _compareBuildOps(BuildOp a, BuildOp b) {
  if (identical(a, b)) return 0;

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

bool _opRequiresBuildingSubtree(BuildOp op) =>
    op.onWidgets != null && !op.onWidgetsIsOptional;

Iterable<BuildOp> _prepareParentOps(Iterable<BuildOp> ops, BuildMetadata meta) {
  // try to reuse existing list if possible
  final withOnChild =
      meta.buildOps?.where((op) => op.onChild != null)?.toList();
  return withOnChild?.isNotEmpty != true
      ? ops
      : List.unmodifiable([if (ops != null) ...ops, ...withOnChild]);
}
