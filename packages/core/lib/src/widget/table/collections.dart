part of '../table_layout.dart';

T _max<T extends num>(Iterable<T> numbers) => numbers.fold(
    null, (max, number) => (max == null || number > max) ? number : max);

bool Function(T) _removeDuplicates<T>() => <T>{}.add;

T _sum<T extends num>(Iterable<T> numbers) =>
    numbers.fold(_zeroForType<T>(), (acc, number) => (acc + number) as T);

Iterable<T> _cumulativeSum<T extends num>(
  Iterable<T> numbers, {
  bool includeLast,
}) sync* {
  includeLast ??= true;
  var current = _zeroForType<T>();
  for (final i in numbers) {
    yield current;
    current += i;
  }
  if (includeLast) yield current;
}

T _zeroForType<T extends num>() => (T == int ? 0 : 0.0) as T;
