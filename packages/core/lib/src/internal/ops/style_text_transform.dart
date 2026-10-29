part of '../core_ops.dart';

const kCssTextTransform = 'text-transform';
const kCssTextTransformCapitalize = 'capitalize';
const kCssTextTransformLowercase = 'lowercase';
const kCssTextTransformNone = 'none';
const kCssTextTransformUppercase = 'uppercase';

/// How [kCssTextTransform] changes text as it is collected.
///
/// Applied while text nodes are read, before whitespace splitting and before
/// ops such as ruby or text-emphasis rebuild the tree. `none` is the initial
/// value and blocks an inherited transform.
enum CssTextTransform {
  /// The first lowercase letter of each word is uppercased.
  capitalize,

  /// Every character is mapped to lowercase.
  lowercase,

  /// Inherited transforms do not apply.
  none,

  /// Every character is mapped to uppercase.
  uppercase,
}

final _reLetter = RegExp(r'\p{L}', unicode: true);
final _reLowercaseLetter = RegExp(r'\p{Ll}', unicode: true);
final _reMark = RegExp(r'\p{M}', unicode: true);

/// Returns the transform named by [value], or null when it is not supported.
///
/// Keywords are matched case-insensitively. `full-width` and `full-size-kana`
/// are not supported, including when combined with another keyword.
CssTextTransform? cssTextTransformTryParse(String value) {
  switch (value.toLowerCase()) {
    case kCssTextTransformCapitalize:
      return CssTextTransform.capitalize;
    case kCssTextTransformLowercase:
      return CssTextTransform.lowercase;
    case kCssTextTransformNone:
      return CssTextTransform.none;
    case kCssTextTransformUppercase:
      return CssTextTransform.uppercase;
  }

  return null;
}

/// Applies the nearest specified [kCssTextTransform] on [tree] or its parents.
///
/// An invalid declaration is ignored so the parent value can still inherit.
/// [CssTextTransform.none] resets that inheritance.
String transformInheritedText(BuildTree tree, String data) {
  final transform = _specifiedTextTransform(tree);
  if (transform == null || transform == CssTextTransform.none) {
    return data;
  }

  return _applyTextTransform(
    data,
    transform,
    previousRune:
        transform == CssTextTransform.capitalize ? _previousRune(tree) : null,
  );
}

CssTextTransform? _specifiedTextTransform(BuildTree tree) {
  BuildTree? current = tree;
  while (current != null) {
    final term = current.getStyle(kCssTextTransform)?.term;
    if (term != null) {
      final parsed = cssTextTransformTryParse(term);
      if (parsed != null) {
        return parsed;
      }
    }

    if (!current.hasParent) {
      break;
    }
    current = current.parent;
  }

  return null;
}

String _applyTextTransform(
  String data,
  CssTextTransform transform, {
  int? previousRune,
}) {
  switch (transform) {
    case CssTextTransform.none:
      return data;
    case CssTextTransform.uppercase:
      return data.toUpperCase();
    case CssTextTransform.lowercase:
      return data.toLowerCase();
    case CssTextTransform.capitalize:
      return _capitalize(data, previousRune);
  }
}

/// Capitalizes the first lowercase letter of each word.
///
/// A word continues across letters, combining marks, and apostrophes
/// (`don't` stays `Don't`). Other characters, including hyphens, start a new
/// word. [previousRune] is the last rendered code point before [data], so a
/// word split across elements is not recapitalized. This is not the full
/// UAX #29 word-break algorithm.
String _capitalize(String data, int? previousRune) {
  var insideWord = previousRune != null && _continuesWord(previousRune);
  final buffer = StringBuffer();

  for (final rune in data.runes) {
    if (!insideWord && _isLowercaseLetter(rune)) {
      buffer.write(String.fromCharCodes([rune]).toUpperCase());
    } else {
      buffer.writeCharCode(rune);
    }

    if (!_isMark(rune) && !_isIntraWordPunctuation(rune)) {
      insideWord = _isLetter(rune);
    }
  }

  return buffer.toString();
}

/// The code point that precedes new text in [tree].
///
/// Null means the new text starts a word: the start of a block, or a widget
/// or line break. Searching does not cross block boundaries.
int? _previousRune(BuildTree tree) {
  final scanned = _scanPreviousRune(tree.children);
  if (!scanned.miss) {
    return scanned.rune;
  }
  if (_isBlockBoundary(tree) || !tree.hasParent) {
    return null;
  }

  return _previousRune(tree.parent);
}

bool _isBlockBoundary(BuildTree tree) {
  if (tree.isInline == false) {
    return true;
  }

  final display = tree.getStyle(kCssDisplay)?.term;
  return display != null &&
      display != kCssDisplayInline &&
      display != kCssDisplayNone;
}

_PreviousRune _scanPreviousRune(Iterable<BuildBit> bits) {
  final reversed = bits is List<BuildBit>
      ? bits.reversed
      : bits.toList(growable: false).reversed;

  for (final bit in reversed) {
    final text = _bitText(bit);
    if (text != null) {
      final runes = text.runes;
      if (runes.isEmpty) {
        continue;
      }
      return _PreviousRune.rune(runes.last);
    }

    if (bit is BuildTree) {
      if (_isBlockBoundary(bit)) {
        return const _PreviousRune.boundary();
      }

      final inner = _scanPreviousRune(bit.children);
      if (!inner.miss) {
        return inner;
      }
      continue;
    }

    // Images, line breaks, and other inline widgets break the word.
    return const _PreviousRune.boundary();
  }

  return const _PreviousRune.miss();
}

String? _bitText(BuildBit bit) {
  if (bit is TextBit) {
    return bit.data;
  }
  if (bit is WhitespaceBit) {
    return bit.data;
  }
  return null;
}

bool _isLetter(int rune) {
  if (rune < 0x80) {
    return (rune >= 0x41 && rune <= 0x5A) || (rune >= 0x61 && rune <= 0x7A);
  }
  return _reLetter.hasMatch(String.fromCharCodes([rune]));
}

bool _isLowercaseLetter(int rune) {
  if (rune < 0x80) {
    return rune >= 0x61 && rune <= 0x7A;
  }
  return _reLowercaseLetter.hasMatch(String.fromCharCodes([rune]));
}

bool _isMark(int rune) {
  if (rune < 0x80) {
    return false;
  }
  return _reMark.hasMatch(String.fromCharCodes([rune]));
}

bool _continuesWord(int rune) =>
    _isLetter(rune) || _isMark(rune) || _isIntraWordPunctuation(rune);

bool _isIntraWordPunctuation(int rune) {
  switch (rune) {
    case 0x27: // '
    case 0x2019: // ’
      return true;
  }
  return false;
}

class _PreviousRune {
  final bool miss;
  final int? rune;

  const _PreviousRune.boundary()
      : miss = false,
        rune = null;

  const _PreviousRune.miss()
      : miss = true,
        rune = null;

  const _PreviousRune.rune(int this.rune) : miss = false;
}
