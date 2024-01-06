part of '../core_data.dart';

/// A set of inherited properties.
///
/// https://developer.mozilla.org/en-US/docs/Web/CSS/Inheritance#inherited_properties
@immutable
class InheritedProperties {
  /// The parent set.
  final InheritedProperties? parent;

  final Iterable<dynamic> values;

  final TextStyle _style;

  const InheritedProperties(this.values)
      : parent = null,
        _style = const TextStyle();

  const InheritedProperties._(this.parent, this.values, this._style);

  /// The [TextStyle].
  @Deprecated('Use `prepareTextStyle` to build one. '
      'For usage in resolving.copyWith, check the migration guide.')
  TextStyle get style => prepareTextStyle();

  /// Creates the root properties set.
  factory InheritedProperties.root([
    Iterable<dynamic> deps = const [],
    TextStyle? widgetStyle,
  ]) {
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
      null,
      [
        ...deps,
        NormalLineHeight(style.height),
      ],
      style,
    );
  }

  /// Creates a copy with the given fields replaced with the new values.
  InheritedProperties copyWith<T>({
    InheritedProperties? parent,
    TextStyle? style,
    T? value,
  }) {
    var newStyle = _style;
    if (style != null) {
      if (style.inherit) {
        newStyle = newStyle.merge(style);
      } else {
        newStyle = style;
      }
    }

    return InheritedProperties._(
      parent ?? this.parent,
      value != null ? [...values.where((e) => e is! T), value] : values,
      newStyle,
    );
  }

  /// Gets inherited property of type [T].
  ///
  /// The initial set of values are populated by [WidgetFactory.getDependencies].
  /// Parser and builder may use [BuildTree.inherit] to enqueue more.
  T? get<T>() {
    if (T == TextStyle) {
      // by default, `get` will return the TextStyle from the original deps list
      // let's intercept here and return the active object instead
      // this also acts as an escape hatch to get the TextStyle directly without preparing
      return _style as T;
    }

    return _get(values);
  }

  /// Prepares [TextStyle] with correct line-height.
  TextStyle prepareTextStyle() {
    final height = get<CssLineHeight>();
    if (height == null) {
      return _style;
    }

    final length = height.value;
    if (length == null) {
      final normal = get<NormalLineHeight>();
      if (normal == null) {
        return _style;
      } else {
        return _style.copyWith(
          debugLabel: 'fwfh: line-height normal',
          height: normal.value,
        );
      }
    }

    final fontSize = _style.fontSize;
    if (fontSize == null || fontSize == .0) {
      return _style;
    }

    final lengthValue = length.getValue(
      this,
      baseValue: fontSize,
      scaleFactor: get<TextScaleFactor>()?.value,
    );
    if (lengthValue == null) {
      return _style;
    }

    return _style.copyWith(
      debugLabel: 'fwfh: line-height',
      height: lengthValue / fontSize,
    );
  }

  static T? _get<T>(Iterable<dynamic> values) {
    for (final value in values.whereType<T>()) {
      return value;
    }
    return null;
  }
}

/// A callback to resolve an [InheritedProperties].
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
  List<_InheritanceResolverCallbackWithInput>? _callbacks;

  /// Creates a set of resolvers for [InheritedProperties].
  InheritanceResolvers([this.parent, this._callbacks]);

  /// {@template flutter_widget_from_html.inherit}
  /// Enqueues an inherited property resolver callback.
  ///
  /// The callback will receive the [InheritedProperties] being resolved.
  /// As a special case, declare `T=BuildContext?` to receive the [BuildContext].
  /// {@endtemplate}
  void enqueue<T>(
    InheritanceResolverCallback<T> callback, [
    T? input,
  ]) {
    final item = _InheritanceResolverCallbackWithInput(callback, input as T);
    final list = _callbacks ??= [];
    list.add(item);
  }

  /// Creates a copy with the given fields replaced with the new values.
  InheritanceResolvers copyWith({InheritanceResolvers? parent}) =>
      InheritanceResolvers(parent ?? this.parent, _callbacks?.toList());

  /// Returns `true` if this shares same callbacks with [other].
  bool isIdenticalWith(InheritanceResolvers other) {
    var thiz = this;
    while (thiz._callbacks == null) {
      final thisParent = thiz.parent;
      if (thisParent == null) {
        break;
      } else {
        thiz = thisParent;
      }
    }

    var othez = other;
    while (othez._callbacks == null) {
      final otherParent = othez.parent;
      if (otherParent == null) {
        break;
      } else {
        othez = otherParent;
      }
    }

    return identical(thiz, othez);
  }

  /// Resolves an [InheritedProperties] by calling callbacks on top of parent's values.
  ///
  /// If the parent's values are unchanged, the cached resolved set will be used.
  InheritedProperties resolve(BuildContext context) {
    final parentResolved =
        parent?.resolve(context) ?? const InheritedProperties([]);
    final scopedCallbacks = _callbacks;
    if (scopedCallbacks == null) {
      return parentResolved;
    }

    final cache = _cachedResolved;
    if (cache != null && identical(parentResolved, _cachedParent)) {
      return cache;
    }

    var resolving = parentResolved.copyWith(parent: parentResolved);
    for (final callback in scopedCallbacks) {
      resolving = callback(context, resolving);
      assert(
        identical(resolving.parent, parentResolved),
        'The inherited properties set should be modified by calling copyWith() '
        'to preserve parent reference.',
      );
    }

    // performance critical
    // keep track of both the parent's and the resolved set -> skip resolving if possible
    // under normal circumstances, the root properties shouldn't be invalidated a lot
    _cachedParent = parentResolved;
    _cachedResolved = resolving;

    return resolving;
  }

  /// Creates a sub set.
  InheritanceResolvers sub() => InheritanceResolvers(this);

  @override
  String toString() => 'inheritanceResolvers#$hashCode'
      '${parent != null ? '(parent=#${parent.hashCode})' : ''}';
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
