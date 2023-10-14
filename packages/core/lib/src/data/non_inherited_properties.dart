part of '../core_data.dart';

/// A mixin that can manage non-inherited properties.
///
/// https://developer.mozilla.org/en-US/docs/Web/CSS/Inheritance#non-inherited_properties
mixin NonInheritedPropertiesOwner {
  @visibleForTesting
  List<dynamic>? nonInheritedValues;

  @protected
  void addAllNonInherited(NonInheritedPropertiesOwner other) {
    final src = other.nonInheritedValues;
    if (src != null) {
      final dest = nonInheritedValues;
      if (dest != null) {
        dest.addAll(src);
      } else {
        nonInheritedValues = [...src];
      }
    }
  }

  /// Gets non-inherited property of type [T].
  T? getNonInherited<T>() {
    final filtered = nonInheritedValues?.whereType<T>();
    if (filtered?.isNotEmpty == true) {
      return filtered?.first;
    }
    return null;
  }

  /// Sets non-inherited property of type [T].
  T setNonInherited<T>(T value) {
    final values = nonInheritedValues ??= [];
    final index = values.indexWhere((p) => p is T);
    if (index == -1) {
      values.add(value);
    } else {
      values[index] = value;
    }
    return value;
  }
}
