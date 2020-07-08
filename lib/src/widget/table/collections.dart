part of '../table_layout.dart';

bool Function(T) removeDuplicates<T>() => <T>{}.add;

T sum<T extends num>(Iterable<T> numbers) =>
    numbers.fold(zeroForType<T>(), (acc, number) => (acc + number) as T);

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

T zeroForType<T extends num>() => (T == int ? 0 : 0.0) as T;
