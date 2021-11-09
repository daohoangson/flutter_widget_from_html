import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:test/test.dart';

void main() {
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
