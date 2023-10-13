part of '../core_data.dart';

/// A set of inherited properties.
///
/// https://developer.mozilla.org/en-US/docs/Web/CSS/Inheritance#inherited_properties
@immutable
class InheritedProperties {
  /// The parent set.
  final InheritedProperties? parent;

  /// The [TextStyle].
  final TextStyle style;

  final Iterable<dynamic> _values;

  const InheritedProperties._(
    this._values, {
    this.parent,
    required this.style,
  });

  /// Creates the root HTML styling set.
  factory InheritedProperties.root(
    Iterable<dynamic> deps,
    TextStyle? widgetStyle,
  ) {
    var style = _get<TextStyle>(deps) ?? const TextStyle();
    style = style.merge(widgetStyle);

    final tsf = _get<TextScaleFactor>(deps);
    final fontSize = style.fontSize;
    if (tsf != null && tsf.value != 1.0 && fontSize != null) {
      style = style.copyWith(
        debugLabel: 'fwfh: fontSize *= textScaleFactor',
        fontSize: fontSize * tsf.value,
      );
    }

    return InheritedProperties._(
      [
        ...deps,
        NormalLineHeight(style.height),
      ],
      style: style,
    );
  }

  /// Creates a copy with the given fields replaced with the new values.
  InheritedProperties copyWith<T>({
    InheritedProperties? parent,
    TextStyle? style,
    T? value,
  }) {
    return InheritedProperties._(
      value != null ? _values.copyWith<T>(value) : _values,
      parent: parent ?? this.parent,
      style: style ?? this.style,
    );
  }

  /// Gets inherited property of type [T].
  ///
  /// The initial set of values are populated by [WidgetFactory.getDependencies].
  /// Parser and builder may use [BuildTree.inherit] to enqueue more.
  T? get<T>() => _get(_values);

  static T? _get<T>(Iterable<dynamic> values) {
    for (final value in values.whereType<T>()) {
      return value;
    }
    return null;
  }
}

typedef InheritanceResolverCallback<T> = InheritedProperties Function(
  InheritedProperties resolving,
  T input,
);

/// A set of resolvers for [InheritedProperties].
///
/// https://developer.mozilla.org/en-US/docs/Web/CSS/Inheritance#inherited_properties
class InheritanceResolvers {
  final InheritanceResolvers? parent;

  InheritedProperties? _cachedParent;
  InheritedProperties? _cachedResolved;
  List<_InheritanceResolverCallbackWithInput>? _queue;

  InheritanceResolvers([this.parent, this._queue]);

  /// {@template flutter_widget_from_html.inherit}
  /// Enqueues an inherited property resolver callback.
  ///
  /// The callback will receive the [InheritedProperties] being built.
  /// As a special case, declare `T=BuildContext?` to receive the [BuildContext].
  /// {@endtemplate}
  void enqueue<T>(
    InheritanceResolverCallback<T> callback, [
    T? input,
  ]) {
    final item = _InheritanceResolverCallbackWithInput(callback, input as T);
    final queue = _queue ??= [];
    queue.add(item);
  }

  /// Creates a copy with the given fields replaced with the new values.
  InheritanceResolvers copyWith({InheritanceResolvers? parent}) =>
      InheritanceResolvers(parent ?? this.parent, _queue?.toList());

  /// Returns `true` if this shares same callbacks with [other].
  bool isIdenticalWith(InheritanceResolvers other) {
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

  /// Resolve an [InheritedProperties] by calling callbacks on top of parent properties.
  InheritedProperties resolve(BuildContext context) {
    final parentResolved = parent!.resolve(context);
    final queue = _queue;
    if (queue == null) {
      return parentResolved;
    }

    final cache = _cachedResolved;
    if (cache != null && identical(parentResolved, _cachedParent)) {
      return cache;
    }

    var resolving = parentResolved.copyWith(parent: parentResolved);
    final l = queue.length;
    for (var i = 0; i < l; i++) {
      resolving = queue[i](context, resolving);
      assert(
        identical(resolving.parent, parentResolved),
        'The inherited properties set should be modified by calling copyWith() '
        'to preserve parent reference.',
      );
    }

    _cachedParent = parentResolved;
    return _cachedResolved = resolving;
  }

  /// Creates a sub set.
  InheritanceResolvers sub() => InheritanceResolvers(this);

  @override
  String toString() => 'inheritanceResolvers#$hashCode'
      '${parent != null ? '(parent=#${parent.hashCode})' : ''}';
}

extension on Iterable<dynamic> {
  Iterable<dynamic> copyWith<T>(T value) => [...where((e) => e is! T), value];
}

@immutable
class _InheritanceResolverCallbackWithInput<T> {
  final InheritanceResolverCallback<T> callback;
  final T input;

  const _InheritanceResolverCallbackWithInput(this.callback, this.input);

  InheritedProperties call(
    BuildContext context,
    InheritedProperties resolving,
  ) {
    if (input == null && isType<BuildContext?>()) {
      return callback(resolving, context as T);
    }

    return callback(resolving, input);
  }

  bool isType<Other>() => T == Other;
}
