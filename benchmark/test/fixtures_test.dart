import 'package:flutter_test/flutter_test.dart';
import '../lib/fixtures.dart';
import '../lib/main.dart';

void main() {
  test('fixtures are deterministic and network independent', () {
    expect(fixtures(), fixtures());
    expect(fixtures().length, 4);
    for (final html in fixtures().values) {
      expect(html, isNot(contains('https:')));
      expect(html, isNot(contains('http:')));
    }
    expect(RegExp('<img ').allMatches(fixtures()['images']!).length, 240);
    expect(RegExp('<tr>').allMatches(fixtures()['table']!).length, 300);
  });
  test('nearest-rank summaries retain missing samples', () {
    expect(distribution([])['p50_us'], isNull);
    expect(distribution([9, 1, 5])['p50_us'], 5);
    expect(distribution([9, 1, 5])['p99_us'], 9);
  });
}
