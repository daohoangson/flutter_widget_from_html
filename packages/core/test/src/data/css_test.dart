import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:test/test.dart';

void main() {
  group('CssLengthBox', () {
    group('toString', () {
      test('returns all() with left+right', () {
        const clb = CssLengthBox(
          left: CssLength(1),
          top: CssLength(1),
          right: CssLength(1),
          bottom: CssLength(1),
        );
        final str = clb.toString();
        expect(str, equals('CssLengthBox.all(1.0px)'));
      });

      test('returns all() with inlines', () {
        const clb = CssLengthBox(
          inlineStart: CssLength(1),
          top: CssLength(1),
          inlineEnd: CssLength(1),
          bottom: CssLength(1),
        );
        final str = clb.toString();
        expect(str, equals('CssLengthBox.all(1.0px)'));
      });

      test('returns all(null)', () {
        const clb = CssLengthBox();
        final str = clb.toString();
        expect(str, equals('CssLengthBox.all(null)'));
      });

      test('returns left=', () {
        const clb = CssLengthBox(left: CssLength(1));
        final str = clb.toString();
        expect(str, equals('CssLengthBox(left=1.0px)'));
      });

      test('returns inline-start=', () {
        const clb = CssLengthBox(inlineStart: CssLength(1));
        final str = clb.toString();
        expect(str, equals('CssLengthBox(inline-start=1.0px)'));
      });

      test('returns top=', () {
        const clb = CssLengthBox(top: CssLength(1));
        final str = clb.toString();
        expect(str, equals('CssLengthBox(top=1.0px)'));
      });

      test('returns right=', () {
        const clb = CssLengthBox(right: CssLength(1));
        final str = clb.toString();
        expect(str, equals('CssLengthBox(right=1.0px)'));
      });

      test('returns inline-end=', () {
        const clb = CssLengthBox(inlineEnd: CssLength(1));
        final str = clb.toString();
        expect(str, equals('CssLengthBox(inline-end=1.0px)'));
      });

      test('returns bottom=', () {
        const clb = CssLengthBox(bottom: CssLength(1));
        final str = clb.toString();
        expect(str, equals('CssLengthBox(bottom=1.0px)'));
      });

      test('returns four values', () {
        const clb = CssLengthBox(
          inlineStart: CssLength(1),
          top: CssLength(2),
          inlineEnd: CssLength(3),
          bottom: CssLength(4),
        );
        final str = clb.toString();
        expect(str, equals('CssLengthBox(1.0px, 2.0px, 3.0px, 4.0px)'));
      });
    });
  });
}
