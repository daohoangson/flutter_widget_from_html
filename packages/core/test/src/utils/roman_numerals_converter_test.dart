import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/src/utils/roman_numerals_converter.dart';

void main() {
  test('GIVEN 0 WHEN convert to roman numerals THEN returns 0', () {
    const num = 0;
    final romanNumeral = intToRomanNumerals(num);
    expect(romanNumeral, null);
  });

  test('GIVEN negative int WHEN convert to roman numerals THEN returns 0', () {
    const num = -55;
    final romanNumeral = intToRomanNumerals(num);
    expect(romanNumeral, null);
  });

  test('GIVEN 7 WHEN convert to roman numerals THEN returns 0', () {
    const num = 7;
    final romanNumeral = intToRomanNumerals(num);
    expect(romanNumeral, 'VII');
  });

  test('GIVEN 90 WHEN convert to roman numerals THEN returns 0', () {
    const num = 90;
    final romanNumeral = intToRomanNumerals(num);
    expect(romanNumeral, 'XC');
  });

  test('GIVEN max number WHEN convert to roman numerals THEN returns 0', () {
    const num = 3999;
    final romanNumeral = intToRomanNumerals(num);
    expect(romanNumeral, 'MMMCMXCIX');
  });

  test('GIVEN exceed max number WHEN convert to roman numerals THEN returns 0',
      () {
    const num = 4001;
    final romanNumeral = intToRomanNumerals(num);
    expect(romanNumeral, null);
  });

  test('GIVEN number mix/various WHEN convert to roman numerals THEN returns 0',
      () {
    const num = 1416;
    final romanNumeral = intToRomanNumerals(num);
    expect(romanNumeral, 'MCDXVI');
  });

  test('GIVEN thousands WHEN convert to roman numerals THEN returns 0', () {
    const num = 3847;
    final romanNumeral = intToRomanNumerals(num);
    expect(romanNumeral, 'MMMDCCCXLVII');
  });

  test(
      'GIVEN all numbers in range WHEN convert to roman numerals THEN returns not null',
      () {
    for (var n = 1; n < 4000; n += 1) {
      expect(intToRomanNumerals(n) != null, true);
    }
  });
}
