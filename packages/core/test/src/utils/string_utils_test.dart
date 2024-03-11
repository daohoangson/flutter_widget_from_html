import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/src/utils/string_utils.dart';

void main() {
  group('test toUpperCaseFirstLetter', () {
    test('test toUpperCaseFirstLetter', () {
      const text = 'characteristics';
      final actual = text.toUpperCaseFirstLetter();
      expect(actual, 'Characteristics');
    });

    test('test toUpperCaseFirstLetter keep other chars case', () {
      const text = 'characTERIstics';
      final actual = text.toUpperCaseFirstLetter();
      expect(actual, 'CharacTERIstics');
    });
  });

  group('test toUpperCaseAllWords', () {
    test('test toUpperCaseAllWords basic case', () {
      const text = 'this is a very simple test';
      final actual = text.toUpperCaseAllWords();
      expect(actual, 'This Is A Very Simple Test');
    });

    test('test toUpperCaseAllWords multiple case', () {
      const text = 'ThIs iS a VERy s1mple tESt';
      final actual = text.toUpperCaseAllWords();
      expect(actual, 'ThIs IS A VERy S1mple TESt');
    });

    test('test toUpperCaseAllWords special characters', () {
      const text = 'this is_a Vey\$XVM ~tEKOCM';
      final actual = text.toUpperCaseAllWords();
      expect(actual, 'This Is_a Vey\$XVM ~tEKOCM');
    });
  });
}
