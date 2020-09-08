import 'package:test/test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

void main() {
  group('RebuildTriggers', () {
    group('hashCode', () {
      test('empty', () {
        final t1 = RebuildTriggers([]);
        expect(t1.hashCode, equals(0));
      });

      test('not empty', () {
        final t1 = RebuildTriggers([1, 2, 3]);
        expect(t1.hashCode, isNot(equals(0)));
      });
    });

    group('equality', () {
      test('self', () {
        final t1 = RebuildTriggers([]);
        expect(t1, equals(t1));
      });

      test('different length', () {
        final t1 = RebuildTriggers([]);
        final t2 = RebuildTriggers([1]);
        expect(t1, isNot(equals(t2)));
      });

      test('different values', () {
        final t1 = RebuildTriggers([1]);
        final t2 = RebuildTriggers([2]);
        expect(t1, isNot(equals(t2)));
      });

      test('same values', () {
        final t1 = RebuildTriggers([1]);
        final t2 = RebuildTriggers([1]);
        expect(t1, equals(t2));
      });

      test('empty', () {
        final t1 = RebuildTriggers([]);
        final t2 = RebuildTriggers([]);
        expect(t1, equals(t2));
      });

      test('wrong type', () {
        final t1 = RebuildTriggers([]);
        final t2 = '';
        expect(t1, isNot(equals(t2)));
      });
    });
  });
}
