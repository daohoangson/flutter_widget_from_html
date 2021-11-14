import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fwfh_text_style/fwfh_text_style.dart';

void main() {
  const value = 1.0;
  const value2 = 2.0;

  group('copyWith', () {
    group('height=null', () {
      const obj = FwfhTextStyle.from(TextStyle());

      test('keeps null', () {
        final copied = obj.copyWith();
        expect(copied.height, isNull);
      });

      test('updates null with value', () {
        final copied = obj.copyWith(height: value);
        expect(copied.height, equals(value));
      });
    });

    group('height=1.0', () {
      const obj = FwfhTextStyle.from(TextStyle(height: value));

      test('keeps value', () {
        final copied = obj.copyWith();
        expect(copied.height, equals(value));
      });

      test('updates with another value', () {
        final copied = obj.copyWith(height: value2);
        expect(copied.height, equals(value2));
      });

      test('resets to null', () {
        final copied = obj.copyWith(height: null);
        expect(copied.height, isNull);
      });
    });
  });
}
