import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:test/test.dart';

void main() {
  group('TextBit', () {
    group('prev+next', () {
      final text = _text();
      final bit1 = text.addText('1');
      final text2 = text.sub();
      final bit21 = text2.addText('(2.1)');
      final bit22 = text2.addText('(2.2)');
      final bit3 = text.addText('3');

      test('test data', () => expect(_data(text), equals('1(2.1)(2.2)3')));

      group('prev', () {
        test('returns sibling', () => expect(bit22.prev, equals(bit21)));

        test('returns last of previous sub',
            () => expect(bit21.prev, equals(bit1)));

        test('returns from parent', () => expect(bit3.prev, equals(bit22)));

        test('returns null', () => expect(bit1.prev, isNull));
      });

      group('next', () {
        test('returns sibling', () => expect(bit21.next, equals(bit22)));

        test('returns first of next sub',
            () => expect(bit1.next, equals(bit21)));

        test('returns from parent', () => expect(bit22.next, equals(bit3)));

        test('returns null', () => expect(bit3.next, isNull));
      });
    });

    test('detaches', () {
      final text = _text();
      final bit = text.addText('data');
      expect(text.isEmpty, isFalse);

      bit.detach();
      expect(text.isEmpty, isTrue);
    });

    test('inserts after', () {
      final text = _text();
      final bit1 = text.addText('1');
      text.addText('3');
      expect(_data(text), equals('13'));

      TextData(text, '2', text.tsb).insertAfter(bit1);
      expect(_data(text), equals('123'));
    });

    test('inserts before', () {
      final text = _text();
      text.addText('1');
      final bit3 = text.addText('3');
      expect(_data(text), equals('13'));

      TextData(text, '2', text.tsb).insertBefore(bit3);
      expect(_data(text), equals('123'));
    });

    test('replaces', () {
      final text = _text();
      text.addText('1');
      final bitX = text.addText('x');
      text.addText('3');
      expect(_data(text), equals('1x3'));

      bitX.replaceWith(TextData(text, '2', text.tsb));
      expect(_data(text), equals('123'));
    });
  });

  group('TextBits', () {
    group('first', () {
      test('returns child', () {
        final text = _text();
        final bit1 = text.addText('1');
        text.addText('2');
        expect(_data(text), equals('12'));

        expect(text.first, equals(bit1));
      });

      test('returns from sub', () {
        final text = _text();
        final text1 = text.sub();
        final bit11 = text1.addText('(1.1)');
        text1.addText('(1.2)');
        expect(_data(text), equals('(1.1)(1.2)'));

        expect(text.first, equals(bit11));
      });
    });

    group('hasTrailingWhitespace', () {
      test('returns true by default', () {
        final text = _text();
        expect(text.hasTrailingWhitespace, isTrue);
      });

      test('returns true for trailing whitespace', () {
        final text = _text();
        text.addWhitespace();

        expect(text.hasTrailingWhitespace, isTrue);
      });

      test('returns false for text', () {
        final text = _text();
        text.addText('data');

        expect(text.hasTrailingWhitespace, isFalse);
      });

      test('returns false for widget', () {
        final text = _text();
        final widget = WidgetPlaceholder(generator: text);
        text.add(TextWidget(text, widget));

        expect(text.hasTrailingWhitespace, isFalse);
      });
    });

    test('isEmpty', () {
      final text = _text();
      expect(text.isEmpty, isTrue);
    });

    test('isNotEmpty', () {
      final text = _text();
      text.addText('data');

      expect(text.isEmpty, isFalse);
    });

    group('last', () {
      test('returns child', () {
        final text = _text();
        text.addText('1');
        final bit2 = text.addText('2');
        expect(_data(text), equals('12'));

        expect(text.last, equals(bit2));
      });

      test('returns from sub', () {
        final text = _text();
        final text1 = text.sub();
        text1.addText('(1.1)');
        final bit12 = text1.addText('(1.2)');
        expect(_data(text), equals('(1.1)(1.2)'));

        expect(text.last, equals(bit12));
      });
    });

    group('addNewLine', () {
      test('adds new bit', () {
        final text = _text();
        text.addText('data');
        expect(text.bits.length, equals(1));

        final newLine = text.addNewLine();
        expect(newLine, isNotNull);
        expect(text.bits.length, equals(2));
      });

      test('skips adding to existing new line', () {
        final text = _text();
        text.addText('data');
        final newLine1 = text.addNewLine();
        final newLine2 = text.addNewLine();

        expect(newLine2, equals(newLine1));
        expect(newLine2.data.length, equals(2));
      });
    });

    group('addWhitespace', () {
      test('adds new bit', () {
        final text = _text();
        text.addText('data');
        expect(text.bits.length, equals(1));

        final space = text.addWhitespace();
        expect(space, isNotNull);
        expect(text.bits.length, equals(2));
      });

      test('skips adding to empty text', () {
        final text = _text();
        final space = text.addWhitespace();

        expect(space, isNull);
      });

      test('skips adding to trailing space', () {
        final text = _text();
        text.addText('data');
        final space1 = text.addWhitespace();
        final space2 = text.addWhitespace();

        expect(space2, equals(space1));
      });
    });

    group('trimRight', () {
      test('trims trailing space', () {
        final text = _text();
        text.addText('data');
        text.addWhitespace();
        expect(text.bits.length, equals(2));

        text.trimRight();
        expect(text.bits.length, equals(1));
      });

      test('skips trimming text', () {
        final text = _text();
        text.addText('data');
        expect(text.bits.length, equals(1));

        text.trimRight();
        expect(text.bits.length, equals(1));
      });

      test('trims bit from sub', () {
        final text = _text();
        final text1 = text.sub();
        text1.addText('data');
        text1.addWhitespace();
        expect(text1.bits.length, equals(2));

        text.trimRight();
        expect(text1.bits.length, equals(1));
      });
    });
  });

  test('toString', () {
    final text = _text();
    text.addText('1');
    text.addWhitespace();
    final text2 = text.sub();
    text2.addText('(2.1)');
    final text22 = text2.sub();
    text22.addText('(2.2.1)');
    text22.addText('(2.2.2)');
    text2.addText('(2.3)');
    final widget = WidgetPlaceholder(generator: text);
    text.add(TextWidget(text, widget));

    final str = text.toString().replaceAll(RegExp(r':\d+\]'), ']');

    expect(str, equals('''

[TextBits]
  [TextData] data=1
  [_TextWhitespace] data= 
  [TextBits]
    [TextData] data=(2.1)
    [TextBits]
      [TextData] data=(2.2.1)
      [TextData] data=(2.2.2)
    [TextData] data=(2.3)
  [TextWidget<TextBits>] widget=WidgetPlaceholder<TextBits>
----'''));
  });
}

String _data(TextBits text) => text.bits.map((bit) => bit.data ?? '').join('');

TextBits _text() => TextBits(TextStyleBuilder());
