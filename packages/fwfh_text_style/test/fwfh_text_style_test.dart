import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fwfh_text_style/fwfh_text_style.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../../core/test/_constants.dart';

Future<void> main() async {
  await loadAppFonts();

  const value = 1.0;
  const value2 = 2.0;
  const delta = .666;
  const factor = 3.0;

  const style0 = TextStyle(inherit: false);
  const styleValue = TextStyle(height: value, inherit: false);
  const styleValue2 = TextStyle(height: value2, inherit: false);

  group('height=null', () {
    final obj = FwfhTextStyle.from(style0);

    group('apply()', () {
      test('ignores height delta', () {
        final applied = obj.apply(heightDelta: delta);
        expect(applied.height, isNull);
        expect(applied, equals(obj));
      });

      test('ignores height factor', () {
        final applied = obj.apply(heightFactor: factor);
        expect(applied.height, isNull);
        expect(applied, equals(obj));
      });
    });

    group('copyWith()', () {
      test('keeps null', () {
        final copied = obj.copyWith();
        expect(copied.height, isNull);
        expect(copied, equals(obj));
      });

      test('updates null with value', () {
        final copied = obj.copyWith(height: value);
        expect(copied.height, equals(value));
        expect(copied, isNot(equals(obj)));
      });
    });

    group('merge()', () {
      test('keeps null', () {
        final merged = obj.merge(const TextStyle());
        expect(merged.height, isNull);
        expect(merged, equals(obj));
      });

      test('merges null', () {
        final merged = obj.merge(null);
        expect(merged.height, isNull);
        expect(merged, equals(obj));
      });

      test('merges value', () {
        final merged = obj.merge(const TextStyle(height: value));
        expect(merged.height, equals(value));
        expect(merged, isNot(equals(obj)));
      });

      test('merges another -> null', () {
        final merged = obj.merge(FwfhTextStyle.from(style0));
        expect(merged.height, isNull);
        expect(merged, equals(obj));
      });

      test('merges another -> value', () {
        final merged = obj.merge(FwfhTextStyle.from(styleValue));
        expect(merged.height, equals(value));
        expect(merged, isNot(equals(obj)));
      });
    });
  });

  group('height=value', () {
    final obj = FwfhTextStyle.from(styleValue);

    group('apply()', () {
      test('applies height delta', () {
        final applied = obj.apply(heightDelta: delta);
        expect(applied.height, equals(value + delta));
        expect(applied, isNot(equals(obj)));
      });

      test('applies height factor', () {
        final applied = obj.apply(heightFactor: factor);
        expect(applied.height, equals(value * factor));
        expect(applied, isNot(equals(obj)));
      });

      test('applies both', () {
        final applied = obj.apply(heightDelta: delta, heightFactor: factor);
        expect(applied.height, equals(value * factor + delta));
        expect(applied, isNot(equals(obj)));
      });
    });

    group('copyWith()', () {
      test('keeps value', () {
        final copied = obj.copyWith();
        expect(copied.height, equals(value));
        expect(copied, equals(obj));
      });

      test('updates with another value', () {
        final copied = obj.copyWith(height: value2);
        expect(copied.height, equals(value2));
        expect(copied, isNot(equals(obj)));
      });

      test('resets to null', () {
        // ignore: avoid_redundant_argument_values
        final copied = obj.copyWith(height: null);
        expect(copied.height, isNull);
        expect(copied, isNot(equals(obj)));
      });
    });

    group('merge()', () {
      test('keeps value', () {
        final merged = obj.merge(const TextStyle());
        expect(merged.height, equals(value));
        expect(merged, equals(obj));
      });

      test('merges null', () {
        final merged = obj.merge(null);
        expect(merged.height, equals(value));
        expect(merged, equals(obj));
      });

      test('merges another value', () {
        final merged = obj.merge(const TextStyle(height: value2));
        expect(merged.height, equals(value2));
        expect(merged, isNot(equals(obj)));
      });

      test('merges another -> resets value', () {
        final merged = obj.merge(FwfhTextStyle.from(style0));
        expect(merged.height, isNull);
        expect(merged, isNot(equals(obj)));
      });

      test('merges another -> new value', () {
        final merged = obj.merge(styleValue2);
        expect(merged.height, equals(value2));
        expect(merged, isNot(equals(obj)));
      });
    });
  });

  test('copyWith() updates existing debugLabel', () {
    const debugLabel = 'foo';
    final obj = FwfhTextStyle.from(
      const TextStyle(
        debugLabel: debugLabel,
        inherit: false,
      ),
    );
    expect(obj.debugLabel, equals(debugLabel));

    final copied = obj.copyWith();
    expect(copied.debugLabel, isNot(equals(debugLabel)));
    expect(copied.debugLabel, contains(debugLabel));

    // `TextStyle.operator==` ignores `debugLabel`
    expect(copied, equals(obj));
    expect(copied.hashCode, equals(obj.hashCode));
    expect(identical(copied, obj), isFalse);
  });

  test('copyWith() replaces debugLabel', () {
    const debugLabel1 = 'foo';
    final obj = FwfhTextStyle.from(
      const TextStyle(
        debugLabel: debugLabel1,
        inherit: false,
      ),
    );
    expect(obj.debugLabel, equals(debugLabel1));

    const debugLabel2 = 'bar';
    final copied = obj.copyWith(debugLabel: debugLabel2);
    expect(copied.debugLabel, equals(debugLabel2));

    // `TextStyle.operator==` ignores `debugLabel`
    expect(copied, equals(obj));
    expect(copied.hashCode, equals(obj.hashCode));
    expect(identical(copied, obj), isFalse);
  });

  test('merge() nested obj', () {
    final obj = FwfhTextStyle.from(FwfhTextStyle.from(styleValue));
    final another = FwfhTextStyle.from(FwfhTextStyle.from(styleValue2));
    final merged = obj.merge(another);
    expect(merged.height, equals(value2));
    expect(merged, isNot(equals(obj)));
  });

  final goldenSkip = Platform.isLinux ? null : 'Linux only';
  GoldenToolkit.runWithConfiguration(
    () {
      group(
        'FwfhTextStyle.of',
        () {
          testGoldens('renders Text', (WidgetTester tester) async {
            await tester.pumpWidgetBuilder(
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Builder(
                  builder: (context) => Text(
                    'Foo 20',
                    style: FwfhTextStyle.of(context).copyWith(fontSize: 20),
                  ),
                ),
              ),
            );

            await screenMatchesGolden(tester, 'Text');
          });

          testGoldens('renders Text.rich', (WidgetTester tester) async {
            await tester.pumpWidgetBuilder(
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Builder(
                  builder: (context) => Text.rich(
                    const TextSpan(text: 'Foo red'),
                    style:
                        FwfhTextStyle.of(context).copyWith(color: Colors.red),
                  ),
                ),
              ),
            );

            await screenMatchesGolden(tester, 'Text.rich');
          });

          testGoldens('renders TextSpan', (WidgetTester tester) async {
            await tester.pumpWidgetBuilder(
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Builder(
                  builder: (context) => Text.rich(
                    TextSpan(
                      text: 'Foo bold',
                      style: FwfhTextStyle.of(context)
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            );

            await screenMatchesGolden(tester, 'TextSpan');
          });
        },
        skip: goldenSkip,
      );
    },
    config: GoldenToolkitConfiguration(
      fileNameFactory: (name) => '$kGoldenFilePrefix/fwfh_text_style/$name.png',
    ),
  );
}
