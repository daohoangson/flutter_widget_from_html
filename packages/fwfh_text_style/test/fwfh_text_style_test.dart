import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fwfh_text_style/fwfh_text_style.dart';

void main() {
  const value = 1.0;
  const value2 = 2.0;
  const delta = .666;
  const factor = 3.0;

  group('height=null', () {
    const obj = FwfhTextStyle.from(TextStyle());

    group('apply()', () {
      test('ignores height delta', () {
        final applied = obj.apply(heightDelta: delta);
        expect(applied.height, isNull);
      });

      test('ignores height factor', () {
        final applied = obj.apply(heightFactor: factor);
        expect(applied.height, isNull);
      });
    });

    group('copyWith()', () {
      test('keeps null', () {
        final copied = obj.copyWith();
        expect(copied.height, isNull);
      });

      test('updates null with value', () {
        final copied = obj.copyWith(height: value);
        expect(copied.height, equals(value));
      });
    });

    group('merge()', () {
      test('keeps null', () {
        final merged = obj.merge(const TextStyle());
        expect(merged.height, isNull);
      });

      test('merges null', () {
        final merged = obj.merge(null);
        expect(merged.height, isNull);
      });

      test('merges value', () {
        final merged = obj.merge(const TextStyle(height: value));
        expect(merged.height, equals(value));
      });

      test('merges another -> null', () {
        final merged = obj.merge(const FwfhTextStyle.from(TextStyle()));
        expect(merged.height, isNull);
      });

      test('merges another -> value', () {
        final merged = obj.merge(
          const FwfhTextStyle.from(TextStyle(height: value)),
        );
        expect(merged.height, equals(value));
      });
    });
  });

  group('height=value', () {
    const obj = FwfhTextStyle.from(TextStyle(height: value));

    group('apply()', () {
      test('applies height delta', () {
        final applied = obj.apply(heightDelta: delta);
        expect(applied.height, equals(value + delta));
      });

      test('applies height factor', () {
        final applied = obj.apply(heightFactor: factor);
        expect(applied.height, equals(value * factor));
      });

      test('applies both', () {
        final applied = obj.apply(heightDelta: delta, heightFactor: factor);
        expect(applied.height, equals(value * factor + delta));
      });
    });

    group('copyWith()', () {
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

    group('merge()', () {
      test('keeps value', () {
        final merged = obj.merge(const TextStyle());
        expect(merged.height, equals(value));
      });

      test('merges null', () {
        final merged = obj.merge(null);
        expect(merged.height, equals(value));
      });

      test('merges another value', () {
        final merged = obj.merge(const TextStyle(height: value2));
        expect(merged.height, equals(value2));
      });

      test('merges another -> keep value', () {
        final merged = obj.merge(const FwfhTextStyle.from(TextStyle()));
        expect(merged.height, equals(value));
      });

      test('merges another -> new value', () {
        final merged = obj.merge(
          const FwfhTextStyle.from(TextStyle(height: value2)),
        );
        expect(merged.height, equals(value2));
      });
    });
  });

  test('copyWith() updates existing debugLabel', () {
    const debugLabel = 'foo';
    const obj = FwfhTextStyle.from(TextStyle(debugLabel: debugLabel));
    expect(obj.debugLabel, equals(debugLabel));

    final copied = obj.copyWith();
    expect(copied.debugLabel, isNot(equals(debugLabel)));
    expect(copied.debugLabel, contains(debugLabel));
  });

  test('copyWith() replaces debugLabel', () {
    const debugLabel1 = 'foo';
    const obj = FwfhTextStyle.from(TextStyle(debugLabel: debugLabel1));
    expect(obj.debugLabel, equals(debugLabel1));

    const debugLabel2 = 'bar';
    final copied = obj.copyWith(debugLabel: debugLabel2);
    expect(copied.debugLabel, equals(debugLabel2));
  });
}
