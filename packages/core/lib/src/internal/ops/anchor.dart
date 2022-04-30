part of '../core_ops.dart';

class AnchorRegistry {
  final _anchors = <GlobalKey>[];
  final _anchorById = <String, GlobalKey>{};
  final _bodyItemIndeces = <int>[];
  final _bodyItemKeys = <GlobalKey>[];
  final _indexByAnchor = <Key, _AnchorBodyItemIndex>{};
  final BuildContext _rootContext;

  AnchorRegistry(this._rootContext);

  Widget buildBodyItem(BuildContext context, int index, Widget widget) {
    final header = index * 2;
    final footer = index * 2 + 1;
    if (footer >= _bodyItemKeys.length) {
      return widget;
    }

    return _BodyItemWidget(
      index: index,
      registry: this,
      child: Stack(
        children: [
          widget,
          SizedBox.shrink(key: _bodyItemKeys[header]),
          Positioned(
            bottom: 0,
            child: SizedBox.shrink(key: _bodyItemKeys[footer]),
          ),
        ],
      ),
    );
  }

  Future<bool> ensureVisible(
    String id, {
    Curve curve = Curves.easeIn,
    Duration duration = const Duration(milliseconds: 100),
    Curve jumpCurve = Curves.linear,
    Duration jumpDuration = Duration.zero,
  }) {
    final completer = Completer<bool>();
    _ensureVisible(
      id,
      completer: completer,
      curve: curve,
      duration: duration,
      jumpCurve: jumpCurve,
      jumpDuration: jumpDuration,
      prevMax: null,
      prevMin: null,
    );
    return completer.future;
  }

  Future<void> _ensureVisible(
    String id, {
    required Completer<bool> completer,
    required Curve curve,
    required Duration duration,
    required Curve jumpCurve,
    required Duration jumpDuration,
    required int? prevMax,
    required int? prevMin,
  }) async {
    final anchor = _anchorById[id];
    if (anchor == null) {
      return completer.complete(false);
    }

    final anchorContext = anchor.currentContext;
    if (anchorContext != null) {
      return completer.complete(
        _ensureVisibleContext(
          anchorContext,
          curve: curve,
          duration: duration,
        ),
      );
    }

    if (_bodyItemIndeces.isEmpty) {
      return completer.complete(false);
    }
    final current = _bodyItemIndeces.toList(growable: false);
    final currentMin = current.reduce(min);
    final currentMax = current.reduce(max);
    final effectiveMin = min(prevMin ?? currentMin, currentMin);
    final effectiveMax = max(prevMax ?? currentMax, currentMax);

    final abii = _indexByAnchor[anchor];
    final anchorMin = abii?.min ?? effectiveMin;
    final anchorMax = abii?.max ?? effectiveMax;

    var movedOk = false;
    if (anchorMin < effectiveMin) {
      // target is above: scroll the header to the bottom of viewport
      final header = _bodyItemKeys[currentMin * 2];
      movedOk = await _ensureVisibleContext(
        header.currentContext,
        alignment: 1.0,
        curve: jumpCurve,
        duration: jumpDuration,
      );
    } else if (anchorMax > effectiveMax) {
      // target is below: scroll the footer to the top of viewport
      final footer = _bodyItemKeys[currentMax * 2 + 1];
      movedOk = await _ensureVisibleContext(
        footer.currentContext,
        curve: jumpCurve,
        duration: jumpDuration,
      );
    }

    if (!movedOk) {
      return completer.complete(false);
    }

    _widgetsBindingInstance?.addPostFrameCallback(
      (_) => _ensureVisible(
        id,
        completer: completer,
        curve: curve,
        duration: duration,
        jumpCurve: jumpCurve,
        jumpDuration: jumpDuration,
        prevMax: effectiveMax,
        prevMin: effectiveMin,
      ),
    );
  }

  Future<bool> _ensureVisibleContext(
    BuildContext? context, {
    double alignment = 0.0,
    required Curve curve,
    required Duration duration,
  }) async {
    final renderObject = context?.findRenderObject();
    if (renderObject == null) {
      return false;
    }

    ScrollableState? scrollState;
    if (_bodyItemIndeces.isNotEmpty) {
      final currentIndex = _bodyItemIndeces.first;
      final currentKey = _bodyItemKeys[currentIndex * 2];
      final currentContext = currentKey.currentContext;
      if (currentContext != null) {
        // we have body key, find the nearest scrollable accestor
        // should work for ListView render mode
        scrollState = Scrollable.of(currentContext);
      }
    }
    // plan B: look for scrollable from the root build context
    // should work for Column, SliverList render mode
    scrollState ??= Scrollable.of(_rootContext);

    final position = scrollState?.position;
    if (position == null) {
      return false;
    }

    await position.ensureVisible(
      renderObject,
      alignment: alignment,
      duration: duration,
      curve: curve,
    );
    return true;
  }

  void prepareIndexByAnchor(List<Widget> widgets) {
    if (_anchors.isEmpty) {
      return;
    }

    for (var i = 0; i < widgets.length; i++) {
      _bodyItemKeys.add(GlobalKey(debugLabel: 'anchor-$i--header'));
      _bodyItemKeys.add(GlobalKey(debugLabel: 'anchor-$i--footer'));

      final childAnchors = widgets[i].anchors;
      if (childAnchors != null) {
        for (final anchor in childAnchors) {
          _indexByAnchor[anchor] = _AnchorBodyItemIndex.exact(i);
        }
      }
    }

    for (var j = 0; j < _anchors.length; j++) {
      final anchor = _anchors[j];
      if (_indexByAnchor[anchor] != null) {
        continue;
      }

      int? prevMax;
      for (var prevIndex = j - 1; prevIndex >= 0; prevIndex--) {
        final prevAnchor = _anchors[prevIndex];
        final prevAbii = _indexByAnchor[prevAnchor];
        prevMax = prevAbii?.isExact == true ? prevAbii?.max : null;
        if (prevMax != null) {
          break;
        }
      }

      int? nextMin;
      for (var nextIndex = j + 1; nextIndex < _anchors.length; nextIndex++) {
        final nextAnchor = _anchors[nextIndex];
        final nextAbii = _indexByAnchor[nextAnchor];
        nextMin = nextAbii?.isExact == true ? nextAbii?.min : null;
        if (nextMin != null) {
          break;
        }
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

// TODO: remove workaround when our minimum Flutter version >2.12
WidgetsBinding? get _widgetsBindingInstance => WidgetsBinding.instance;

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
