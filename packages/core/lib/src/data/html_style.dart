part of '../core_data.dart';

/// An HTML styling set.
@immutable
class HtmlStyle {
  final Iterable<dynamic> _deps;

  /// The [GestureRecognizer] for inline spans.
  final GestureRecognizer? gestureRecognizer;

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
    this.gestureRecognizer,
    this.parent,
    required this.style,
    this.textAlign,
    required this.textDirection,
    required this.whitespace,
  }) : _deps = deps;

  /// Creates the root HTML styling set.
  factory HtmlStyle.root(Iterable<dynamic> deps, TextStyle? widgetTextStyle) {
    var textStyle = _getDependency<TextStyle>(deps).merge(widgetTextStyle);
    textStyle = FwfhTextStyle.from(textStyle);

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
    GestureRecognizer? gestureRecognizer,
    HtmlStyle? parent,
    TextStyle? style,
    TextAlign? textAlign,
    TextDirection? textDirection,
    CssWhitespace? whitespace,
  }) {
    return HtmlStyle._(
      deps: _deps,
      gestureRecognizer: gestureRecognizer ?? this.gestureRecognizer,
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
class HtmlStyleBuilder {
  final HtmlStyleBuilder? parent;

  HtmlStyle? _cachedParent;
  HtmlStyle? _cachedBuilt;
  List<_HtmlStyleCallback>? _queue;

  HtmlStyleBuilder([this.parent, this._queue]);

  /// Enqueues an HTML styling callback.
  void enqueue<T>(
    HtmlStyle Function(HtmlStyle style, T input) callback,
    T input,
  ) {
    final item = _HtmlStyleCallback(callback, input);
    final queue = _queue ??= [];
    queue.add(item);
  }

  /// Builds an [HtmlStyle] by calling builders on top of parent styling.
  HtmlStyle build(BuildContext context) {
    final parentBuilt = parent!.build(context);
    final queue = _queue;
    if (queue == null) {
      return parentBuilt;
    }

    final cache = _cachedBuilt;
    if (cache != null && identical(parentBuilt, _cachedParent)) {
      return cache;
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

    _cachedParent = parentBuilt;
    return _cachedBuilt = built;
  }

  /// Creates a copy with the given fields replaced with the new values.
  HtmlStyleBuilder copyWith({HtmlStyleBuilder? parent}) =>
      HtmlStyleBuilder(parent ?? this.parent, _queue?.toList());

  /// Returns `true` if this shares same styling with [other].
  bool hasSameStyleWith(HtmlStyleBuilder other) {
    var thiz = this;
    while (thiz._queue == null) {
      final thisParent = thiz.parent;
      if (thisParent == null) {
        break;
      } else {
        thiz = thisParent;
      }
    }

    var othez = other;
    while (othez._queue == null) {
      final otherParent = othez.parent;
      if (otherParent == null) {
        break;
      } else {
        othez = otherParent;
      }
    }

    return identical(thiz, othez);
  }

  /// Creates a sub-builder.
  HtmlStyleBuilder sub() => HtmlStyleBuilder(this);

  @override
  String toString() =>
      'tsb#$hashCode${parent != null ? '(parent=#${parent.hashCode})' : ''}';
}

@immutable
class _HtmlStyleCallback<T> {
  final HtmlStyle Function(HtmlStyle style, T input) callback;
  final T input;

  const _HtmlStyleCallback(this.callback, this.input);

  HtmlStyle call(HtmlStyle style) => callback(style, input);
}
