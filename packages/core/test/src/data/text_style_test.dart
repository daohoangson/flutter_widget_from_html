import 'package:flutter/widgets.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:test/test.dart';

void main() {
  group('HtmlStyle', () {
    group('value', () {
      final dep1 = _Dep1();
      final style = HtmlStyle.root(
        [
          const TextScaleFactor(1.0),
          TextDirection.ltr,
          const TextStyle(inherit: false),
          dep1,
        ],
        null,
      );

      test('returns value', () {
        final dep = style.value<_Dep1>();
        expect(dep, equals(dep1));
      });

      test('returns dependency', () {
        // ignore: deprecated_member_use_from_same_package
        final dep = style.getDependency<_Dep1>();
        expect(dep, equals(dep1));
      });

      test('returns null', () {
        expect(style.value<_Dep2>(), isNull);
      });
    });
  });
}

class _Dep1 {}

class _Dep2 {}
