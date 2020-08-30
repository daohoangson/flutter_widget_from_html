import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart' show WidgetTester, testWidgets;
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:flutter_widget_from_html_core/src/internal/builder.dart'
    as builder;
import 'package:test/test.dart';

import '_.dart' as helper;

void main() {
  group('BuildBit', () {
    group('T', () {
      final explain =
          (WidgetTester tester, String html) => helper.explain(tester, null,
              hw: HtmlWidget(
                html,
                factoryBuilder: () => _InputWidgetFactory(),
                key: helper.hwKey,
              ));

      group('GestureRecognizer', () {
        final clazz = 'input--GestureRecognizer';

        testWidgets('SPAN tag with BuildBit', (WidgetTester tester) async {
          final html = '1 <span class="$clazz">2</span> 3';
          final explained = await explain(tester, html);
          expect(explained, equals('[RichText:(:1 2(no recognizer) 3)]'));
        });

        testWidgets('SPAN tag with styling + BuildBit', (tester) async {
          final html = '1 <span class="custom $clazz">2</span> 3';
          final explained = await explain(tester, html);
          expect(explained, equals('[RichText:(:1 (:2(no recognizer))(: 3))]'));
        });

        testWidgets('A tag without BuildBit', (WidgetTester tester) async {
          final html = '1 <a href="href">2</a> 3';
          final explained = await explain(tester, html);
          expect(
              explained, equals('[RichText:(:1 (#FF0000FF+u+onTap:2)(: 3))]'));
        });

        testWidgets('A tag with BuildBit', (WidgetTester tester) async {
          final html = '1 <a href="href" class="$clazz">2</a> 3';
          final explained = await explain(tester, html);
          expect(explained,
              equals('[RichText:(:1 (#FF0000FF+u+onTap+onTapCancel:2)(: 3))]'));
        });
      });

      group('Null', () {
        final clazz = 'input--Null';

        testWidgets('SPAN tag with BuildBit', (WidgetTester tester) async {
          final html = '1 <span class="$clazz">2</span> 3';
          final explained = await explain(tester, html);
          expect(explained, equals('[RichText:(:1 2(null) 3)]'));
        });
      });

      group('TextStyleHtml', () {
        final clazz = 'input--TextStyleHtml';

        testWidgets('SPAN tag with BuildBit', (WidgetTester tester) async {
          final html = '1 <span class="$clazz">2</span> 3';
          final explained = await explain(tester, html);
          expect(explained, equals('[RichText:(:1 2(:TextStyleHtml)(: 3))]'));
        });
      });

      group('TextStyleBuilder', () {
        final clazz = 'input--TextStyleBuilder';

        testWidgets('SPAN tag with BuildBit', (WidgetTester tester) async {
          final html = '1 <span class="$clazz">2</span> 3';
          final explained = await explain(tester, html);
          expect(
              explained,
              equals('[Column:children='
                  '[RichText:(:1 2)],'
                  '[Text:textDirection=TextDirection.ltr],'
                  '[RichText:(: 3)]'
                  ']'));
        });
      });
    });

    group('prev+next', () {
      final text = _text();
      final bit1 = text.addText('1');
      final text2 = text.sub(text.tsb);
      text.add(text2);
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

      TextBit(text, '2').insertAfter(bit1);
      expect(_data(text), equals('123'));
    });

    test('inserts before', () {
      final text = _text();
      text.addText('1');
      final bit3 = text.addText('3');
      expect(_data(text), equals('13'));

      TextBit(text, '2').insertBefore(bit3);
      expect(_data(text), equals('123'));
    });
  });

  group('BuildTree', () {
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
        final text1 = text.sub(text.tsb);
        text.add(text1);
        final bit11 = text1.addText('(1.1)');
        text1.addText('(1.2)');
        expect(_data(text), equals('(1.1)(1.2)'));

        expect(text.first, equals(bit11));
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
        final text1 = text.sub(text.tsb);
        text.add(text1);
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

        text.addNewLine();
        expect(text.bits.length, equals(3));
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

    group('build', () {
      test('builds RichText', () {
        final text = _text();
        text.addText('1');

        final widgets = text.build();
        expect(widgets.length, equals(1));
      });

      test('builds via buildBit(null)', () {
        final text = _text();
        text.addText('1');

        final widgets = text.buildBit(null);
        expect(widgets.length, equals(1));
      });
    });

    test('replaces', () {
      final text = _text();
      text.addText('1');
      text.addText('3');
      expect(_data(text), equals('13'));

      text.replaceWith(TextBit(text, '2'));
      expect(_data(text), equals('2'));
    });
  });

  group('copyWith', () {
    test('TextBit returns', () {
      final text = _text();
      final bit = text.addText('1');

      final text2 = _text();
      final copied = bit.copyWith(parent: text2);
      text2.add(copied);
      expect(_data(text2), equals('1'));
    });

    test('WidgetBit returns', () {
      final text = _text();
      final child = WidgetPlaceholder(null);
      final bit = WidgetBit.inline(text, child);

      final text2 = _text();
      final copied = bit.copyWith(parent: text2);
      text2.add(copied);
      expect((copied.buildBit(null) as WidgetSpan).child, equals(child));
    });

    test('BuildTree returns', () {
      final text = _text();
      text.addText('1');

      final copied = text.copyWith();
      expect(_data(copied), equals('1'));
    });

    test('NewLine returns', () {
      final text = _text();
      text.addText('1');
      final newLine = text.addNewLine();

      final text2 = _text();
      text2.addText('1');
      final copied = newLine.copyWith(parent: text2);
      text2.add(copied);
      text2.addText('2');
      expect(_data(text2), equals('1\n2'));
    });

    test('Whitespace returns', () {
      final text = _text();
      text.addText('1');
      final whitespace = text.addWhitespace();

      final text2 = _text();
      text2.addText('1');
      final copied = whitespace.copyWith(parent: text2);
      text2.add(copied);
      text2.addText('2');
      expect(_data(text2), equals('1 2'));
    });
  });

  test('toString', () {
    final text = _text();
    text.addText('1');
    text.addWhitespace();
    final text2 = text.sub(text.tsb);
    text.add(text2);
    text2.addText('(2.1)');
    final text22 = text2.sub(text.tsb.sub());
    text2.add(text22);
    text22.addText('(2.2.1)');
    text22.addText('(2.2.2)');
    text22.addNewLine();
    text2.addText('(2.3)');
    text.add(WidgetBit.inline(text, Text('Hi')));

    expect(
        helper.simplifyHashCode(text.toString()),
        equals('BuildTree#0 tsb#1:\n'
            '  "1"\n'
            '  Whitespace#2\n'
            '  BuildTree#3 tsb#1:\n'
            '    "(2.1)"\n'
            '    BuildTree#4 tsb#5(parent=#1):\n'
            '      "(2.2.1)"\n'
            '      "(2.2.2)"\n'
            '      _TextNewLine#6 tsb#5(parent=#1)\n'
            '    "(2.3)"\n'
            '  WidgetBit.inline#7 WidgetPlaceholder(Text("Hi"))'));
  });
}

class _InputGestureRecognizerBit extends BuildBit<GestureRecognizer> {
  _InputGestureRecognizerBit(BuildTree parent, TextStyleBuilder tsb)
      : super(parent, tsb);

  @override
  dynamic buildBit(GestureRecognizer recognizer) {
    if (recognizer is TapGestureRecognizer) {
      recognizer.onTapCancel = () {};
      return recognizer;
    }

    return '(no recognizer)';
  }

  @override
  BuildBit copyWith({BuildTree parent, TextStyleBuilder tsb}) =>
      _InputGestureRecognizerBit(parent ?? this.parent, tsb ?? this.tsb);
}

class _InputNullBit extends BuildBit<Null> {
  _InputNullBit(BuildTree parent, TextStyleBuilder tsb) : super(parent, tsb);

  @override
  dynamic buildBit(Null _) => '(null)';

  @override
  BuildBit copyWith({BuildTree parent, TextStyleBuilder tsb}) =>
      _InputNullBit(parent ?? this.parent, tsb ?? this.tsb);
}

class _InputTextStyleHtmlBit extends BuildBit<TextStyleHtml> {
  _InputTextStyleHtmlBit(BuildTree parent, TextStyleBuilder tsb)
      : super(parent, tsb);

  @override
  InlineSpan buildBit(TextStyleHtml tsh) => TextSpan(
        text: tsh.runtimeType.toString(),
        style: tsh.styleWithHeight,
      );

  @override
  BuildBit copyWith({BuildTree parent, TextStyleBuilder tsb}) =>
      _InputTextStyleHtmlBit(parent ?? this.parent, tsb ?? this.tsb);
}

class _InputTextStyleBuilderBit extends BuildBit<TextStyleBuilder> {
  _InputTextStyleBuilderBit(BuildTree parent, TextStyleBuilder tsb)
      : super(parent, tsb);

  @override
  dynamic buildBit(TextStyleBuilder tsb) => WidgetPlaceholder(tsb)
    ..wrapWith((context, _) =>
        Text('textDirection=${tsb.build(context).textDirection}'));

  @override
  BuildBit copyWith({BuildTree parent, TextStyleBuilder tsb}) =>
      _InputTextStyleBuilderBit(parent ?? this.parent, tsb ?? this.tsb);
}

class _InputWidgetFactory extends WidgetFactory {
  @override
  void parse(BuildMetadata meta) {
    final classes = meta.element.classes;

    if (classes.contains('input--GestureRecognizer')) {
      meta.register(BuildOp(
          onProcessed: (_, tree) =>
              tree.add(_InputGestureRecognizerBit(tree, tree.tsb))));
    }

    if (classes.contains('input--Null')) {
      meta.register(BuildOp(
          onProcessed: (_, tree) => tree.add(_InputNullBit(tree, tree.tsb))));
    }

    if (classes.contains('input--TextStyleHtml')) {
      meta.register(BuildOp(
          onProcessed: (_, tree) =>
              tree.add(_InputTextStyleHtmlBit(tree, tree.tsb))));
    }

    if (classes.contains('input--TextStyleBuilder')) {
      meta.register(BuildOp(
          onProcessed: (_, tree) =>
              tree.add(_InputTextStyleBuilderBit(tree, tree.tsb))));
    }

    if (classes.contains('custom')) {
      meta.tsb((tsh, _) => tsh.copyWith());
    }

    super.parse(meta);
  }
}

String _data(BuildTree text) => text.bits
    .map((bit) => (bit is BuildBit<void>)
        ? bit.buildBit(null).toString()
        : '[$bit]'.replaceAll(RegExp(r'#\w+'), ''))
    .join('');

BuildTree _text() => builder.BuildTree(tsb: TextStyleBuilder());
