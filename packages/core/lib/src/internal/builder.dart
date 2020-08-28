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

  BuildMetadata(dom.Element domElement, TextStyleBuilder tsb, [this._parentOps])
      : super(domElement, tsb);

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
  set isBlockElement(bool value) => _isBlockElement = value;

  @override
  operator []=(String key, String value) {
    if (key == null || value == null) return;

    assert(!_stylesIsLocked);
    _styles ??= [];
    _styles..add(key)..add(value);
  }

  @override
  void register(BuildOp op) {
    if (op == null) return;

    assert(!_buildOpsIsLocked);
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
    dom.NodeList domNodes,
    BuildTree parent,
    this.parentMeta,
    this.parentOps,
    TextStyleBuilder tsb,
    this.wf,
  }) : super(parent, tsb) {
    if (domNodes != null) {
      parent?.add(this);
      _populateBits(domNodes);
    }
  }

  @override
  BuildBit add(BuildBit bit) {
    assert(_built.isEmpty, "Built tree shouldn't be altered.");
    return super.add(bit);
  }

  @override
  Iterable<Widget> build() {
    if (_built.isNotEmpty) return _built;

    List<WidgetPlaceholder> trailing;
    while (true) {
      final lastBit = last;
      if (lastBit == null) break;
      if (lastBit is! _WidgetBit) break;

      trailing ??= [];
      trailing.insert(0, lastBit.buildBit(null));
      lastBit.detach();
    }

    trimLeft();
    trimRight();

    var widgets = [
      ..._flatten(),
      if (trailing != null) ...trailing,
    ];

    if (parentMeta?.buildOps != null) {
      final _makeSureWidgetIsPlaceholder = (Widget widget) =>
          widget is WidgetPlaceholder
              ? widget
              : WidgetPlaceholder<BuildMetadata>(parentMeta, child: widget);

      for (final op in parentMeta.buildOps) {
        widgets = op.onBuilt
                ?.call(parentMeta, widgets)
                ?.map(_makeSureWidgetIsPlaceholder)
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
    dom.NodeList domNodes,
    BuildTree parent,
    BuildMetadata parentMeta,
    Iterable<BuildOp> parentOps,
  }) =>
      BuildTree(
        customStylesBuilder: customStylesBuilder,
        customWidgetBuilder: customWidgetBuilder,
        domNodes: domNodes,
        parent: parent ?? this,
        parentMeta: parentMeta ?? this.parentMeta,
        parentOps: parentOps,
        tsb: tsb ?? this.tsb.sub(),
        wf: wf,
      );

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

  BuildMetadata _collectMetadata(dom.Element e) {
    final meta = BuildMetadata(e, parentMeta.tsb().sub(), parentOps);
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
    _customStylesBuilder(meta, e);
    _customWidgetBuilder(meta, e);

    // stylings, step 2: get styles from `style` attribute
    if (e.attributes.containsKey('style')) {
      for (final pair in splitAttributeStyle(e.attributes['style'])) {
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

    return meta;
  }

  void _customStylesBuilder(BuildMetadata meta, dom.Element element) {
    final map = customStylesBuilder?.call(element);
    if (map == null) return;

    for (final pair in map.entries) {
      meta[pair.key] = pair.value;
    }
  }

  void _customWidgetBuilder(BuildMetadata meta, dom.Element element) {
    final built = customWidgetBuilder?.call(element);
    if (built == null) return;

    meta.register(BuildOp(onBuilt: (_, __) => [built]));
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

  void _populateBits(dom.NodeList domNodes) {
    for (final domNode in domNodes) {
      if (domNode.nodeType == dom.Node.TEXT_NODE) {
        _addText(domNode.text);
        continue;
      }
      if (domNode.nodeType != dom.Node.ELEMENT_NODE) continue;

      final meta = _collectMetadata(domNode);
      if (meta.isNotRenderable == true) continue;

      final subTree = sub(
        meta.tsb(),
        domNodes: domNode.nodes,
        parentMeta: meta,
        parentOps: _prepareParentOps(parentOps, meta),
      );

      if (meta.isBlockElement) {
        for (final widget in subTree.build()) {
          add(_WidgetBit(this, widget));
        }
        subTree.detach();
      }
    }

    if (parentMeta?.buildOps != null) {
      for (final op in parentMeta.buildOps) {
        op.onProcessed?.call(parentMeta, this);
      }
    }
  }
}

class _WidgetBit extends BuildBit<void> {
  final WidgetPlaceholder child;

  _WidgetBit(BuildTree parent, this.child) : super(parent, null);

  @override
  bool get skipAddingWhitespace => true;

  @override
  WidgetPlaceholder buildBit(void _) => child;

  @override
  BuildBit copyWith({core_data.BuildTree parent, TextStyleBuilder tsb}) =>
      _WidgetBit(parent ?? this.parent, child);

  @override
  String toString() => 'WidgetBit#$hashCode $child';
}

Iterable<BuildOp> _prepareParentOps(Iterable<BuildOp> ops, BuildMetadata meta) {
  // try to reuse existing list if possible
  final withOnChild =
      meta.buildOps?.where((op) => op.onChild != null)?.toList();
  return withOnChild?.isNotEmpty != true
      ? ops
      : List.unmodifiable([if (ops != null) ...ops, ...withOnChild]);
}
