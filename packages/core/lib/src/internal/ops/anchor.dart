part of '../core_ops.dart';

class AnchorRegistry {
  final _anchors = <GlobalKey>[];
  final _anchorById = <String, GlobalKey>{};
  final _bodyItemIndeces = <int>[];
  final _bodyItemKeys = <GlobalKey>[];
  final _indexByAnchor = <Key, _AnchorBodyItemIndex>{};

  Widget buildBodyItem(BuildContext context, int index, Widget widget) {
    if (index >= _bodyItemKeys.length) return widget;

    return _BodyItemWidget(
      index: index,
      key: _bodyItemKeys[index],
      registry: this,
      child: widget,
    );
  }

  Future<bool> ensureVisible(
    String id, {
    List<int>? bodyItemIndecesFromPreviousRun,
  }) async {
    final anchor = _anchorById[id];
    if (anchor == null) return false;

    final anchorContext = anchor.currentContext;
    if (anchorContext != null) {
      return _ensureVisibleContext(anchorContext);
    }

    final abii = _indexByAnchor[anchor];
    if (abii == null) return false;

    if (_bodyItemIndeces.isEmpty) return false;
    final current = _bodyItemIndeces.toList(growable: false);
    if (bodyItemIndecesFromPreviousRun != null &&
        listEquals(current, bodyItemIndecesFromPreviousRun)) {
      debugPrint('Stopped looking for #$id (possible infinite loop)');
      return false;
    }
    final currentMin = current.reduce(min);
    final currentMax = current.reduce(max);

    if (abii.min < currentMin) {
      debugPrint('Going up to index=$currentMin looking for #$id');
      final wentUp = await _ensureVisibleContext(
        _bodyItemKeys[currentMin].currentContext,
        alignment: 0.0,
        curve: Curves.linear,
      );
      if (!wentUp) return false;
    } else if (abii.max > currentMax) {
      debugPrint('Going down to index=$currentMax looking for #$id');
      final wentDown = await _ensureVisibleContext(
        _bodyItemKeys[currentMax].currentContext,
        alignment: 1.0,
        curve: Curves.linear,
      );
      if (!wentDown) return false;
    }

    return ensureVisible(
      id,
      bodyItemIndecesFromPreviousRun: current,
    );
  }

  Future<bool> _ensureVisibleContext(
    BuildContext? context, {
    double alignment = 0.0,
    Curve curve = Curves.easeIn,
  }) async {
    final renderObject = context?.findRenderObject();
    if (renderObject == null) return false;

    final position = Scrollable.of(context!)?.position;
    if (position == null) return false;

    await position.ensureVisible(
      renderObject,
      alignment: alignment,
      duration: const Duration(milliseconds: 100),
      curve: curve,
    );
    return true;
  }

  void prepareIndexByAnchor(List<Widget> widgets) {
    if (_anchors.isEmpty) return;

    for (var i = 0; i < widgets.length; i++) {
      _bodyItemKeys.add(GlobalKey(debugLabel: i.toString()));

      final childAnchors = widgets[i].anchors;
      if (childAnchors != null) {
        for (final anchor in childAnchors) {
          _indexByAnchor[anchor] = _AnchorBodyItemIndex.exact(i);
        }
      }
    }

    for (var j = 0; j < _anchors.length; j++) {
      final anchor = _anchors[j];
      if (_indexByAnchor[anchor] != null) continue;

      int? prevMax;
      for (var prevIndex = j - 1; prevIndex > 0; prevIndex--) {
        final prevAnchor = _anchors[prevIndex];
        final prevAbii = _indexByAnchor[prevAnchor];
        prevMax = prevAbii?.isExact == true ? prevAbii?.max : null;
        if (prevMax != null) break;
      }

      int? nextMin;
      for (var nextIndex = j + 1; nextIndex < _anchors.length; nextIndex++) {
        final nextAnchor = _anchors[nextIndex];
        final nextAbii = _indexByAnchor[nextAnchor];
        nextMin = nextAbii?.isExact == true ? nextAbii?.min : null;
        if (nextMin != null) break;
      }

      _indexByAnchor[anchor] = _AnchorBodyItemIndex.guesstimate(
        prevMax ?? -1,
        nextMin ?? widgets.length,
      );
    }
  }

  void register(String id, GlobalKey anchor) {
    _anchors.add(anchor);
    _anchorById[id] = anchor;
  }
}

class _AnchorBodyItemIndex {
  final bool isExact;
  final int min;
  final int max;

  _AnchorBodyItemIndex.exact(int index)
      : isExact = true,
        min = index,
        max = index;

  _AnchorBodyItemIndex.guesstimate(int prevMax, int nextMin)
      : isExact = false,
        min = prevMax + 1,
        max = nextMin - 1;

  @override
  String toString() {
    if (min == max) return min.toString();
    return '[$min, $max]';
  }
}

class _BodyItemWidget extends ProxyWidget {
  final int index;
  final AnchorRegistry registry;

  const _BodyItemWidget({
    required Widget child,
    required this.index,
    required this.registry,
    Key? key,
  }) : super(key: key, child: child);

  @override
  Element createElement() => _BodyItemElement(this);
}

class _BodyItemElement extends ProxyElement {
  _BodyItemElement(_BodyItemWidget widget) : super(widget);

  _BodyItemWidget get bodyItem => widget as _BodyItemWidget;

  @override
  void notifyClients(_BodyItemWidget _) {}

  @override
  void mount(Element? parent, dynamic newSlot) {
    super.mount(parent, newSlot);
    bodyItem.registry._bodyItemIndeces.add(bodyItem.index);
  }

  @override
  void unmount() {
    bodyItem.registry._bodyItemIndeces.remove(bodyItem.index);
    super.unmount();
  }
}
