part of '../../table_layout.dart';

/// Removes duplicate elements from a collection. The type `T` should implement
/// [Object.hashCode] and [Object.==], if value-based comparison is desired.
///
/// Can be provided as a predicate to [List.removeWhere], [Set.removeWhere],
/// and others.
bool Function(T) removeDuplicates<T>() {
  final seen = <T>{};
  return seen.add;
}

/// Sums the elements of [numbers], and returns the result.
T sum<T extends num>(Iterable<T> numbers) {
  return numbers.fold(zeroForType<T>(), (acc, number) => (acc + number) as T);
}

/// Returns an iterable of [number]'s cumulative sums.
///
/// ```
/// cumulativeSum([1, 2, 3]) // 0, 1, 3, 6
/// cumulativeSum([2.0, 4.0, 6.0]) // 0.0, 2.0, 6.0, 12.0
/// ```
Iterable<T> cumulativeSum<T extends num>(
  Iterable<T> numbers, {
  bool includeLast,
}) sync* {
  includeLast ??= true;
  var current = zeroForType<T>();
  for (final i in numbers) {
    yield current;
    current += i;
  }
  if (includeLast) yield current;
}

/// Returns the representation of `0` for a [num] type `T`.
T zeroForType<T extends num>() => (T == int ? 0 : 0.0) as T;
