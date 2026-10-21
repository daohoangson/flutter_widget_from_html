import 'package:csslib/parser.dart' as css;
import 'package:csslib/visitor.dart' as css;

import '../external/csslib.dart';

const _maxEntries = 512;
final _cache = <String, List<css.Declaration>>{};

/// Parses inline CSS declarations (the body of a `style` attribute).
///
/// Results are memoized in a bounded LRU cache keyed by [declarations],
/// the returned list is unmodifiable and may be shared between elements.
List<css.Declaration> parseDeclarations(String declarations) {
  final existing = _cache.remove(declarations);
  if (existing != null) {
    _cache[declarations] = existing;
    return existing;
  }

  final styleSheet = css.parse('*{$declarations}');
  final parsed = List<css.Declaration>.unmodifiable(
    styleSheet.collectDeclarations(),
  );

  if (_cache.length >= _maxEntries) {
    _cache.remove(_cache.keys.first);
  }
  return _cache[declarations] = parsed;
}
