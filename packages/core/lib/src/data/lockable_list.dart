part of '../core_data.dart';

abstract class LockableList<T> extends Iterable<T> {
  /// Returns `true` if this list should not be modified.
  bool get isLocked;

  /// Adds [value] to the end of this list.
  void add(T value);

  /// Appends all objects of [iterable] to the end of this list.
  void addAll(Iterable<T> iterable);

  /// Inserts [element] at position [index] in this list.
  void insert(int index, T element);

  /// Inserts all objects of [iterable] at position [index] in this list.
  void insertAll(int index, Iterable<T> iterable);
}
