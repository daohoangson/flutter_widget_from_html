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

  group('bytesFromDataUri', () {
    test('returns base64', () {
      final output = bytesFromDataUri('data:image/png;base64,Zm9v');
      expect(output, equals('foo'.codeUnits));
    });

    test('returns utf8', () {
      final output = bytesFromDataUri('data:image/png;utf8,foo');
      expect(output, equals('foo'.codeUnits));
    });

    group('error handling', () {
      test('rejects unrecognized prefix', () {
        final output = bytesFromDataUri('foo');
        expect(output, isNull);
      });

      test('rejects unrecognized encoding', () {
        final output = bytesFromDataUri('data:image/png;foo,bar');
        expect(output, isNull);
      });
    });
  });
}
