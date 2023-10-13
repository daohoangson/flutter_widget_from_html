import 'package:flutter/widgets.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:test/test.dart';

void main() {
  group('InheritedProperties', () {
    group('get', () {
      final dep1 = _Dep1();
      final resolved = InheritedProperties.root(
        [
          const TextScaleFactor(1.0),
          TextDirection.ltr,
          const TextStyle(inherit: false),
          dep1,
        ],
        null,
      );

      test('returns value', () {
        final dep = resolved.get<_Dep1>();
        expect(dep, equals(dep1));
      });

      test('returns null', () {
        expect(resolved.get<_Dep2>(), isNull);
      });
    });
  });
}

class _Dep1 {}

class _Dep2 {}
