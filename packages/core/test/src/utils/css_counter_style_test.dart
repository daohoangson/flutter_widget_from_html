import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/src/utils/css_counter_style.dart';

void main() {
  group('CssCounterStyle', () {
    group('decimal', () {
      final style = CssCounterStyle.lookup('decimal')!;
      test('format(1)', () => expect(style.format(1), '1.'));
      test('format(10)', () => expect(style.format(10), '10.'));
      test('format(0)', () => expect(style.format(0), '0.'));
      test('format(-1)', () => expect(style.format(-1), '-1.'));
      test('format(-10)', () => expect(style.format(-10), '-10.'));
    });

    group('decimal-leading-zero', () {
      final style = CssCounterStyle.lookup('decimal-leading-zero')!;
      test('format(1)', () => expect(style.format(1), '01.'));
      test('format(9)', () => expect(style.format(9), '09.'));
      test('format(10)', () => expect(style.format(10), '10.'));
      test('format(100)', () => expect(style.format(100), '100.'));
      test('format(-1)', () => expect(style.format(-1), '-1.'));
    });

    group('lower-alpha (alphabetic)', () {
      final style = CssCounterStyle.lookup('lower-alpha')!;
      test('format(1)', () => expect(style.format(1), 'a.'));
      test('format(26)', () => expect(style.format(26), 'z.'));
      test('format(27) - bijective base-N', () {
        // Observed behavior in Chrome: 27 -> aa
        expect(style.format(27), 'aa.');
      });
      test('format(52)', () => expect(style.format(52), 'az.'));
      test('format(53)', () => expect(style.format(53), 'ba.'));
      test('format(702)', () => expect(style.format(702), 'zz.'));
      test('format(703)', () => expect(style.format(703), 'aaa.'));
      test('format(0) - out of range', () => expect(style.format(0), null));
      test('format(-1) - out of range', () => expect(style.format(-1), null));
    });

    group('upper-alpha', () {
      final style = CssCounterStyle.lookup('upper-alpha')!;
      test('format(1)', () => expect(style.format(1), 'A.'));
      test('format(26)', () => expect(style.format(26), 'Z.'));
      test('format(27)', () => expect(style.format(27), 'AA.'));
    });

    group('lower-roman (additive)', () {
      final style = CssCounterStyle.lookup('lower-roman')!;
      test('format(1)', () => expect(style.format(1), 'i.'));
      test('format(4)', () => expect(style.format(4), 'iv.'));
      test('format(5)', () => expect(style.format(5), 'v.'));
      test('format(7)', () => expect(style.format(7), 'vii.'));
      test('format(9)', () => expect(style.format(9), 'ix.'));
      test('format(10)', () => expect(style.format(10), 'x.'));
      test('format(90)', () => expect(style.format(90), 'xc.'));
      test('format(1416)', () => expect(style.format(1416), 'mcdxvi.'));
      test('format(3847)', () => expect(style.format(3847), 'mmmdcccxlvii.'));
      test('format(3999)', () => expect(style.format(3999), 'mmmcmxcix.'));
      test('format(0) - out of range', () => expect(style.format(0), null));
      test('format(4000) - out of range',
          () => expect(style.format(4000), null));
      test('format(-55) - out of range', () => expect(style.format(-55), null));
    });

    group('upper-roman (ported from roman_numerals_converter_test.dart)', () {
      final style = CssCounterStyle.lookup('upper-roman')!;
      test('GIVEN 0 THEN returns null', () => expect(style.format(0), null));
      test('GIVEN negative THEN returns null',
          () => expect(style.format(-55), null));
      test('GIVEN 7 THEN returns VII.', () => expect(style.format(7), 'VII.'));
      test('GIVEN 90 THEN returns XC.', () => expect(style.format(90), 'XC.'));
      test('GIVEN 3999 THEN returns MMMCMXCIX.',
          () => expect(style.format(3999), 'MMMCMXCIX.'));
      test('GIVEN 4001 THEN returns null',
          () => expect(style.format(4001), null));
      test('GIVEN 1416 THEN returns MCDXVI.',
          () => expect(style.format(1416), 'MCDXVI.'));
      test('GIVEN 3847 THEN returns MMMDCCCXLVII.',
          () => expect(style.format(3847), 'MMMDCCCXLVII.'));
      test('GIVEN all numbers in range (1-3999) THEN returns not null', () {
        for (var n = 1; n < 4000; n += 1) {
          expect(style.format(n), isNotNull, reason: 'Failed at $n');
        }
      });
    });

    group('lower-greek', () {
      final style = CssCounterStyle.lookup('lower-greek')!;
      test('format(1)', () => expect(style.format(1), 'α.'));
      test('format(24)', () => expect(style.format(24), 'ω.'));
      test('format(25)', () => expect(style.format(25), 'αα.'));
    });

    group('hebrew', () {
      final style = CssCounterStyle.lookup('hebrew')!;
      test('format(1)', () => expect(style.format(1), 'א.'));
      test('format(10)', () => expect(style.format(10), 'י.'));
      test('format(15)', () => expect(style.format(15), 'יה.'));
      test('format(1099)', () => expect(style.format(1099), 'תתרצט.'));
      test('format(1100) - out of range',
          () => expect(style.format(1100), null));
    });

    group('armenian', () {
      final style = CssCounterStyle.lookup('armenian')!;
      test('format(1)', () => expect(style.format(1), 'ա.'));
      test('format(9999)', () => expect(style.format(9999), 'քջղթ.'));
    });

    group('georgian', () {
      final style = CssCounterStyle.lookup('georgian')!;
      test('format(1)', () => expect(style.format(1), 'ա.'));
      test('format(19999)', () => expect(style.format(19999), 'ჵჰყჳთ.'));
    });

    group('arabic-indic', () {
      final style = CssCounterStyle.lookup('arabic-indic')!;
      test('format(1)', () => expect(style.format(1), '١.'));
      test('format(10)', () => expect(style.format(10), '١٠.'));
    });

    group('thai', () {
      final style = CssCounterStyle.lookup('thai')!;
      test('format(1)', () => expect(style.format(1), '๑.'));
      test('format(10)', () => expect(style.format(10), '๑๐.'));
    });

    group('octal', () {
      final style = CssCounterStyle.lookup('octal')!;
      test('format(1)', () => expect(style.format(1), '1.'));
      test('format(8)', () => expect(style.format(8), '10.'));
      test('format(10)', () => expect(style.format(10), '12.'));
    });

    group('upper-hexadecimal', () {
      final style = CssCounterStyle.lookup('upper-hexadecimal')!;
      test('format(1)', () => expect(style.format(1), '1.'));
      test('format(10)', () => expect(style.format(10), 'A.'));
      test('format(16)', () => expect(style.format(16), '10.'));
      test('format(255)', () => expect(style.format(255), 'FF.'));
    });

    group('bengali', () {
      final style = CssCounterStyle.lookup('bengali')!;
      test('format(1)', () => expect(style.format(1), '১.'));
      test('format(10)', () => expect(style.format(10), '১০.'));
    });

    group('cambodian', () {
      final style = CssCounterStyle.lookup('cambodian')!;
      test('format(1)', () => expect(style.format(1), '១.'));
      test('format(10)', () => expect(style.format(10), '១០.'));
    });

    group('khmer (alias of cambodian)', () {
      test('lookup resolves', () {
        expect(CssCounterStyle.lookup('khmer'), isNotNull);
      });
      test('format(1)', () {
        expect(CssCounterStyle.lookup('khmer')!.format(1), '១.');
      });
    });

    group('cjk-decimal', () {
      final style = CssCounterStyle.lookup('cjk-decimal')!;
      test('format(0)', () => expect(style.format(0), '〇、'));
      test('format(1)', () => expect(style.format(1), '一、'));
      test('format(10)', () => expect(style.format(10), '一〇、'));
    });

    group('devanagari', () {
      final style = CssCounterStyle.lookup('devanagari')!;
      test('format(1)', () => expect(style.format(1), '१.'));
      test('format(10)', () => expect(style.format(10), '१०.'));
    });

    group('gujarati', () {
      final style = CssCounterStyle.lookup('gujarati')!;
      test('format(1)', () => expect(style.format(1), '૧.'));
      test('format(10)', () => expect(style.format(10), '૧૦.'));
    });

    group('gurmukhi', () {
      final style = CssCounterStyle.lookup('gurmukhi')!;
      test('format(1)', () => expect(style.format(1), '੧.'));
      test('format(10)', () => expect(style.format(10), '੧੦.'));
    });

    group('kannada', () {
      final style = CssCounterStyle.lookup('kannada')!;
      test('format(1)', () => expect(style.format(1), '೧.'));
      test('format(10)', () => expect(style.format(10), '೧೦.'));
    });

    group('lao', () {
      final style = CssCounterStyle.lookup('lao')!;
      test('format(1)', () => expect(style.format(1), '໑.'));
      test('format(10)', () => expect(style.format(10), '໑໐.'));
    });

    group('malayalam', () {
      final style = CssCounterStyle.lookup('malayalam')!;
      test('format(1)', () => expect(style.format(1), '൧.'));
      test('format(10)', () => expect(style.format(10), '൧൦.'));
    });

    group('mongolian', () {
      final style = CssCounterStyle.lookup('mongolian')!;
      test('format(1)', () => expect(style.format(1), '᠑.'));
      test('format(10)', () => expect(style.format(10), '᠑᠐.'));
    });

    group('myanmar', () {
      final style = CssCounterStyle.lookup('myanmar')!;
      test('format(1)', () => expect(style.format(1), '၁.'));
      test('format(10)', () => expect(style.format(10), '၁၀.'));
    });

    group('oriya', () {
      final style = CssCounterStyle.lookup('oriya')!;
      test('format(1)', () => expect(style.format(1), '୧.'));
      test('format(10)', () => expect(style.format(10), '୧୦.'));
    });

    group('persian', () {
      final style = CssCounterStyle.lookup('persian')!;
      test('format(1)', () => expect(style.format(1), '۱.'));
      test('format(10)', () => expect(style.format(10), '۱۰.'));
    });

    group('tamil', () {
      final style = CssCounterStyle.lookup('tamil')!;
      test('format(1)', () => expect(style.format(1), '௧.'));
      test('format(10)', () => expect(style.format(10), '௧௦.'));
    });

    group('telugu', () {
      final style = CssCounterStyle.lookup('telugu')!;
      test('format(1)', () => expect(style.format(1), '౧.'));
      test('format(10)', () => expect(style.format(10), '౧౦.'));
    });

    group('tibetan', () {
      final style = CssCounterStyle.lookup('tibetan')!;
      test('format(1)', () => expect(style.format(1), '၁.'));
      test('format(10)', () => expect(style.format(10), '၁༠.'));
    });

    group('urdu', () {
      final style = CssCounterStyle.lookup('urdu')!;
      test('format(1)', () => expect(style.format(1), '۱.'));
      test('format(10)', () => expect(style.format(10), '۱۰.'));
    });

    group('cjk-earthly-branch', () {
      final style = CssCounterStyle.lookup('cjk-earthly-branch')!;
      test('format(1)', () => expect(style.format(1), '子、'));
      test('format(12)', () => expect(style.format(12), '亥、'));
      test('format(13)', () => expect(style.format(13), '子子、'));
      test('format(0) - out of range', () => expect(style.format(0), null));
    });

    group('cjk-heavenly-stem', () {
      final style = CssCounterStyle.lookup('cjk-heavenly-stem')!;
      test('format(1)', () => expect(style.format(1), '甲、'));
      test('format(10)', () => expect(style.format(10), '癸、'));
      test('format(11)', () => expect(style.format(11), '甲甲、'));
      test('format(0) - out of range', () => expect(style.format(0), null));
    });

    group('hangul', () {
      final style = CssCounterStyle.lookup('hangul')!;
      test('format(1)', () => expect(style.format(1), '가.'));
      test('format(14)', () => expect(style.format(14), '하.'));
      test('format(15)', () => expect(style.format(15), '가가.'));
      test('format(0) - out of range', () => expect(style.format(0), null));
    });

    group('hangul-consonant', () {
      final style = CssCounterStyle.lookup('hangul-consonant')!;
      test('format(1)', () => expect(style.format(1), 'ㄱ.'));
      test('format(14)', () => expect(style.format(14), 'ㅎ.'));
      test('format(15)', () => expect(style.format(15), 'ㄱㄱ.'));
      test('format(0) - out of range', () => expect(style.format(0), null));
    });

    group('hiragana', () {
      final style = CssCounterStyle.lookup('hiragana')!;
      test('format(1)', () => expect(style.format(1), 'あ、'));
      test('format(48)', () => expect(style.format(48), 'ん、'));
      test('format(49)', () => expect(style.format(49), 'ああ、'));
      test('format(0) - out of range', () => expect(style.format(0), null));
    });

    group('hiragana-iroha', () {
      final style = CssCounterStyle.lookup('hiragana-iroha')!;
      test('format(1)', () => expect(style.format(1), 'い、'));
      test('format(47)', () => expect(style.format(47), 'す、'));
      test('format(48)', () => expect(style.format(48), 'いい、'));
      test('format(0) - out of range', () => expect(style.format(0), null));
    });

    group('katakana', () {
      final style = CssCounterStyle.lookup('katakana')!;
      test('format(1)', () => expect(style.format(1), 'ア、'));
      test('format(48)', () => expect(style.format(48), 'ン、'));
      test('format(49)', () => expect(style.format(49), 'アア、'));
      test('format(0) - out of range', () => expect(style.format(0), null));
    });

    group('katakana-iroha', () {
      final style = CssCounterStyle.lookup('katakana-iroha')!;
      test('format(1)', () => expect(style.format(1), 'イ、'));
      test('format(47)', () => expect(style.format(47), 'ス、'));
      test('format(48)', () => expect(style.format(48), 'イイ、'));
      test('format(0) - out of range', () => expect(style.format(0), null));
    });

    group('japanese-formal', () {
      final style = CssCounterStyle.lookup('japanese-formal')!;
      test('format(0)', () => expect(style.format(0), '零、'));
      test('format(1)', () => expect(style.format(1), '壱、'));
      test('format(10)', () => expect(style.format(10), '壱拾、'));
      test('format(100)', () => expect(style.format(100), '壱百、'));
      test('format(1000)', () => expect(style.format(1000), '壱阡、'));
      test('format(10000) - out of range',
          () => expect(style.format(10000), null));
    });

    group('simp-chinese-formal', () {
      final style = CssCounterStyle.lookup('simp-chinese-formal')!;
      test('format(0)', () => expect(style.format(0), '零、'));
      test('format(1)', () => expect(style.format(1), '壹、'));
      test('format(10)', () => expect(style.format(10), '壹拾、'));
      test('format(100)', () => expect(style.format(100), '壹佰、'));
      test('format(1000)', () => expect(style.format(1000), '壹仟、'));
    });

    group('trad-chinese-formal', () {
      final style = CssCounterStyle.lookup('trad-chinese-formal')!;
      test('format(0)', () => expect(style.format(0), '零、'));
      test('format(1)', () => expect(style.format(1), '壹、'));
      test('format(10)', () => expect(style.format(10), '壹拾、'));
      test('format(100)', () => expect(style.format(100), '壹佰、'));
      test('format(1000)', () => expect(style.format(1000), '壹仟、'));
    });

    group('korean-hangul-formal', () {
      final style = CssCounterStyle.lookup('korean-hangul-formal')!;
      test('format(0)', () => expect(style.format(0), '영, '));
      test('format(1)', () => expect(style.format(1), '일, '));
      test('format(10)', () => expect(style.format(10), '일십, '));
      test('format(100)', () => expect(style.format(100), '일백, '));
      test('format(1000)', () => expect(style.format(1000), '일천, '));
    });

    group('korean-hanja-formal', () {
      final style = CssCounterStyle.lookup('korean-hanja-formal')!;
      test('format(0)', () => expect(style.format(0), '零, '));
      test('format(1)', () => expect(style.format(1), '壹, '));
      test('format(10)', () => expect(style.format(10), '壹拾, '));
      test('format(100)', () => expect(style.format(100), '壹百, '));
      test('format(1000)', () => expect(style.format(1000), '壹仟, '));
    });

    group('korean-hanja-informal', () {
      final style = CssCounterStyle.lookup('korean-hanja-informal')!;
      test('format(0)', () => expect(style.format(0), '零, '));
      test('format(1)', () => expect(style.format(1), '一, '));
      test('format(10)', () => expect(style.format(10), '一十, '));
      test('format(100)', () => expect(style.format(100), '一百, '));
      test('format(1000)', () => expect(style.format(1000), '一千, '));
    });

    group('aliases', () {
      test('lower-latin resolves same as lower-alpha', () {
        expect(CssCounterStyle.lookup('lower-latin')!.format(1), 'a.');
      });
      test('upper-latin resolves same as upper-alpha', () {
        expect(CssCounterStyle.lookup('upper-latin')!.format(1), 'A.');
      });
      test('lower-armenian resolves same as armenian', () {
        expect(CssCounterStyle.lookup('lower-armenian')!.format(1), 'ա.');
      });
      test('upper-armenian resolves same as armenian', () {
        expect(CssCounterStyle.lookup('upper-armenian')!.format(1), 'ա.');
      });
      test('japanese-informal resolves same as cjk-ideographic', () {
        expect(CssCounterStyle.lookup('japanese-informal')!.format(1), '一、');
      });
      test('simp-chinese-informal resolves same as cjk-ideographic', () {
        expect(
            CssCounterStyle.lookup('simp-chinese-informal')!.format(1), '一、');
      });
      test('trad-chinese-informal resolves same as cjk-ideographic', () {
        expect(
            CssCounterStyle.lookup('trad-chinese-informal')!.format(1), '一、');
      });
    });

    group('dynamic string literals (cyclic)', () {
      // Test double quotes
      final styleDouble = CssCounterStyle.lookup('"★"')!;
      test('format(1) double quotes', () => expect(styleDouble.format(1), '★'));
      test('format(5) double quotes', () => expect(styleDouble.format(5), '★'));

      // Test single quotes
      final styleSingle = CssCounterStyle.lookup("'👉'")!;
      test(
          'format(1) single quotes', () => expect(styleSingle.format(1), '👉'));
    });

    group('base-N numeric (binary, hex)', () {
      final binary = CssCounterStyle.lookup('binary')!;
      test('binary format(2)', () => expect(binary.format(2), '10.'));
      test('binary format(5)', () => expect(binary.format(5), '101.'));

      final hex = CssCounterStyle.lookup('lower-hexadecimal')!;
      test('hex format(10)', () => expect(hex.format(10), 'a.'));
      test('hex format(15)', () => expect(hex.format(15), 'f.'));
      test('hex format(16)', () => expect(hex.format(16), '10.'));
      test('hex format(255)', () => expect(hex.format(255), 'ff.'));
    });

    group('cjk-ideographic', () {
      final style = CssCounterStyle.lookup('cjk-ideographic')!;

      test('format(1)', () => expect(style.format(1), '一、'));
      test('format(10)', () => expect(style.format(10), '一十、'));
      test('format(11)', () => expect(style.format(11), '一十一、'));

      test('format(101) - additive fallback',
          () => expect(style.format(101), '一百一、'));

      test('format(9999)', () => expect(style.format(9999), '九千九百九十九、'));
      test('format(0)', () => expect(style.format(0), '零、'));
    });

    test('lookup(invalid)', () => expect(CssCounterStyle.lookup('foo'), null));
  });
}
