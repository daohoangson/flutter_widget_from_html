part of '../core_data.dart';

/// An HTML styling set.
@immutable
class HtmlStyle {
  /// The parent style.
  final HtmlStyle? parent;

  /// The input [TextStyle].
  final TextStyle textStyle;

  final Iterable<dynamic> _values;

  const HtmlStyle._(
    this._values, {
    this.parent,
    required this.textStyle,
  });

  /// Creates the root HTML styling set.
  factory HtmlStyle.root(Iterable<dynamic> deps, TextStyle? widgetTextStyle) {
    var textStyle = _getValue<TextStyle>(deps)!;
    textStyle = textStyle.merge(widgetTextStyle);
    textStyle = FwfhTextStyle.from(textStyle);

    final tsf = _getValue<TextScaleFactor>(deps)!;
    final fontSize = textStyle.fontSize;
    if (tsf.value != 1.0 && fontSize != null) {
      textStyle = textStyle.copyWith(
        debugLabel: 'fwfh: fontSize *= textScaleFactor',
        fontSize: fontSize * tsf.value,
      );
    }

    return HtmlStyle._(deps, textStyle: textStyle);
  }

  /// The input [TextStyle].
  @Deprecated('Use .textStyle instead.')
  TextStyle get style => textStyle;

  /// The text direction.
  TextDirection get textDirection => value()!;

  /// The number of font pixels for each logical pixel.
  double get textScaleFactor => value<TextScaleFactor>()!.value;

  /// The whitespace behavior.
  CssWhitespace get whitespace => value()!;

  /// Creates a copy with the given fields replaced with the new values.
  ///
  /// These values are passed down to children's styles.
  HtmlStyle copyWith<T>({
    HtmlStyle? parent,
    @Deprecated('Use .textStyle instead.') TextStyle? style,
    TextStyle? textStyle,
    T? value,
  }) {
    return HtmlStyle._(
      value != null ? _values.copyWith<T>(value) : _values,
      parent: parent ?? this.parent,
      textStyle: textStyle ?? style ?? this.textStyle,
    );
  }

  /// Gets dependency by type [T].
  @Deprecated('Use .value instead.')
  T? getDependency<T>() => value<T>();

  /// Gets value of type [T].
  ///
  /// The initial set of values are populated by [WidgetFactory.getDependencies].
  /// Parser and builder may use [BuildTree.apply] to add more.
  T? value<T>() => _getValue(_values);

  static T? _getValue<T>(Iterable<dynamic> values) {
    for (final value in values.whereType<T>()) {
      return value;
    }
    return null;
  }
}

/// A HTML styling builder.
class HtmlStyleBuilder {
  final HtmlStyleBuilder? parent;

  HtmlStyle? _cachedParent;
  HtmlStyle? _cachedBuilt;
  List<_HtmlStyleCallback>? _queue;

  HtmlStyleBuilder([this.parent, this._queue]);

  /// {@template flutter_widget_from_html.enqueue}
  /// Enqueues an HTML styling callback.
  ///
  /// The callback will receive the current [HtmlStyle] being built.
  /// As a special case, declare `T=BuildContext?` to receive the [BuildContext].
  /// {@endtemplate}
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
      built = queue[i](context, built);
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
  String toString() => 'styleBuilder#$hashCode'
      '${parent != null ? '(parent=#${parent.hashCode})' : ''}';
}

extension on Iterable<dynamic> {
  Iterable<dynamic> copyWith<T>(T value) => [...where((e) => e is! T), value];
}

@immutable
class _HtmlStyleCallback<T> {
  final HtmlStyle Function(HtmlStyle style, T input) callback;
  final T input;

  const _HtmlStyleCallback(this.callback, this.input);

  HtmlStyle call(BuildContext context, HtmlStyle style) {
    if (input == null && isType<BuildContext?>()) {
      return callback(style, context as T);
    }

    return callback(style, input);
  }

  bool isType<Other>() => T == Other;
}
