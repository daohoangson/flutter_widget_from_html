part of '../core_data.dart';

/// A collection of values, that may be locked to prevent modification.
abstract class LockableList<T> extends Iterable<T> {
  /// Returns `true` if this list should not be modified.
  bool get isLocked;

  /// Adds [value] to the end of this list.
  void add(T value);

  /// Appends all objects of [iterable] to the end of this list.
  void addAll(Iterable<T> iterable);
}
