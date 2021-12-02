part of '../core_data.dart';

/// An HTML styling set.
@immutable
class HtmlStyle {
  final Iterable<dynamic> _deps;

  /// The parent style.
  final HtmlStyle? parent;

  /// The input [TextStyle].
  /// TODO: rename
  final TextStyle style;

  /// The text alignment.
  final TextAlign? textAlign;

  /// The text direction.
  final TextDirection textDirection;

  /// The whitespace behavior.
  final CssWhitespace whitespace;

  const HtmlStyle._({
    required Iterable<dynamic> deps,
    this.parent,
    required this.style,
    this.textAlign,
    required this.textDirection,
    required this.whitespace,
  }) : _deps = deps;

  /// Creates the root HTML styling set.
  factory HtmlStyle.root(Iterable<dynamic> deps, TextStyle? widgetTextStyle) {
    var textStyle = _getDependency<TextStyle>(deps);
    textStyle = FwfhTextStyle.from(textStyle);
    if (widgetTextStyle != null) {
      textStyle = widgetTextStyle.inherit
          ? textStyle.merge(widgetTextStyle)
          : widgetTextStyle;
    }

    final mqd = _getDependency<MediaQueryData>(deps);
    final tsf = mqd.textScaleFactor;
    final fontSize = textStyle.fontSize;
    if (tsf != 1 && fontSize != null) {
      textStyle = textStyle.copyWith(fontSize: fontSize * tsf);
    }

    return HtmlStyle._(
      deps: deps,
      style: textStyle,
      textDirection: _getDependency<TextDirection>(deps),
      whitespace: CssWhitespace.normal,
    );
  }

  /// Creates a copy with the given fields replaced with the new values.
  HtmlStyle copyWith({
    HtmlStyle? parent,
    TextStyle? style,
    TextAlign? textAlign,
    TextDirection? textDirection,
    CssWhitespace? whitespace,
  }) {
    assert(
      style is FwfhTextStyle?,
      'The text style should be modified by calling methods of the existing instance: '
      'apply(), copyWith() or merge().',
    );

    return HtmlStyle._(
      deps: _deps,
      parent: parent ?? this.parent,
      style: style ?? this.style,
      textAlign: textAlign ?? this.textAlign,
      textDirection: textDirection ?? this.textDirection,
      whitespace: whitespace ?? this.whitespace,
    );
  }

  /// Gets dependency value by type.
  ///
  /// See [WidgetFactory.getDependencies].
  T getDependency<T>() => _getDependency<T>(_deps);

  static T _getDependency<T>(Iterable<dynamic> deps) {
    for (final value in deps.whereType<T>()) {
      return value;
    }

    throw StateError('The $T dependency could not be found');
  }
}

/// A HTML styling builder.
@immutable
class HtmlStyleBuilder {
  static final _caches = Expando<_HtmlStyleCache>();
  static final _queues = Expando<List<_HtmlStyleCallback>>();

  final HtmlStyleBuilder? parent;

  const HtmlStyleBuilder({this.parent});

  /// Enqueues an HTML styling callback.
  void enqueue<T>(
    HtmlStyle Function(HtmlStyle style, T input) callback,
    T input,
  ) {
    assert(_caches[this] == null, 'Cannot enqueue builder after being built');

    final item = _HtmlStyleCallback(callback, input);
    final queue = _queues[this];
    if (queue != null) {
      queue.add(item);
    } else {
      _queues[this] = [item];
    }
  }

  /// Builds an [HtmlStyle] by calling builders on top of parent styling.
  HtmlStyle build(BuildContext context) {
    final parentBuilt = parent!.build(context);
    final queue = _queues[this];
    if (queue == null) {
      return parentBuilt;
    }

    final cache = _caches[this];
    if (cache != null && identical(parentBuilt, cache.parentBuilt)) {
      return cache.built;
    }

    var built = parentBuilt.copyWith(parent: parentBuilt);
    final l = queue.length;
    for (var i = 0; i < l; i++) {
      built = queue[i](built);
      assert(
        identical(built.parent, parentBuilt),
        'The HTML styling set should be modified by calling copyWith() '
        'to preserve parent reference.',
      );
    }

    _caches[this] = _HtmlStyleCache(parentBuilt, built);

    return built;
  }

  /// Returns `true` if this shares same styling with [other].
  bool hasSameStyleWith(HtmlStyleBuilder other) {
    var thisWithQueue = this;
    while (_queues[thisWithQueue] == null) {
      final thisParent = thisWithQueue.parent;
      if (thisParent == null) {
        break;
      } else {
        thisWithQueue = thisParent;
      }
    }

    var otherWithQueue = other;
    while (_queues[otherWithQueue] == null) {
      final otherParent = otherWithQueue.parent;
      if (otherParent == null) {
        break;
      } else {
        otherWithQueue = otherParent;
      }
    }

    return identical(thisWithQueue, otherWithQueue);
  }

  /// Creates a sub-builder.
  HtmlStyleBuilder sub() => HtmlStyleBuilder(parent: this);

  @override
  String toString() =>
      'tsb#$hashCode${parent != null ? '(parent=#${parent.hashCode})' : ''}';
}

@immutable
class _HtmlStyleCache {
  final HtmlStyle parentBuilt;
  final HtmlStyle built;

  const _HtmlStyleCache(this.parentBuilt, this.built);
}

@immutable
class _HtmlStyleCallback<T> {
  final HtmlStyle Function(HtmlStyle style, T input) callback;
  final T input;

  const _HtmlStyleCallback(this.callback, this.input);

  HtmlStyle call(HtmlStyle style) => callback(style, input);
}
