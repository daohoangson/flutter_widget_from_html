import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:test/test.dart';

void main() {
  group('NonInheritedPropertiesOwner', () {
    group('addAllNonInherited', () {
      test('add value to empty list', () {
        final owner1 = _Owner();
        final value1 = _Value1();
        owner1.setNonInherited(value1);

        final owner2 = _Owner();
        owner2._addAllNonInherited(owner1);
        expect(owner2.nonInheritedValues, equals([value1]));
      });

      test('add values to empty list', () {
        final owner1 = _Owner();
        final value1 = _Value1();
        final value2 = _Value2();
        owner1.setNonInherited(value1);
        owner1.setNonInherited(value2);

        final owner2 = _Owner();
        owner2._addAllNonInherited(owner1);
        expect(owner2.nonInheritedValues, equals([value1, value2]));
      });

      test('add value to non-empty list', () {
        final owner1 = _Owner();
        final value1 = _Value1();
        owner1.setNonInherited(value1);

        final owner2 = _Owner();
        final value2 = _Value2();
        owner2.setNonInherited(value2);
        owner2._addAllNonInherited(owner1);
        expect(owner2.nonInheritedValues, equals([value2, value1]));
      });
    });

    group('getNonInherited', () {
      test('return value', () {
        final owner1 = _Owner();
        final value1 = _Value1();
        owner1.setNonInherited(value1);

        final actual = owner1.getNonInherited<_Value1>();
        expect(actual, equals(value1));
      });

      test('no value returning null', () {
        final owner1 = _Owner();

        final actual = owner1.getNonInherited<_Value1>();
        expect(actual, isNull);
      });

      test('some value returning null', () {
        final owner1 = _Owner();
        final value1 = _Value1();
        owner1.setNonInherited(value1);

        final actual = owner1.getNonInherited<_Value2>();
        expect(actual, isNull);
      });
    });

    group('setNonInherited', () {
      test('add value', () {
        final owner1 = _Owner();
        final value1 = _Value1();
        owner1.setNonInherited(value1);

        expect(owner1.nonInheritedValues, equals([value1]));
      });

      test('replace value', () {
        final owner1 = _Owner();
        final value1a = _Value1();
        owner1.setNonInherited(value1a);
        expect(owner1.nonInheritedValues, equals([value1a]));

        final value1b = _Value1();
        owner1.setNonInherited(value1b);
        expect(owner1.nonInheritedValues, isNot(equals([value1a])));
        expect(owner1.nonInheritedValues, equals([value1b]));
      });
    });
  });
}

class _Owner with NonInheritedPropertiesOwner {
  void _addAllNonInherited(NonInheritedPropertiesOwner other) {
    addAllNonInherited(other);
  }
}

class _Value1 {}

class _Value2 {}
