import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart' show WidgetTester, testWidgets;
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:flutter_widget_from_html_core/src/internal/builder.dart'
    as builder;
import 'package:test/test.dart';

import '../../_.dart' as helper;

void main() {
  group('BuildBit', () {
    group('buildBit', () {
      final explain =
          (WidgetTester tester, String html) => helper.explain(tester, null,
              hw: HtmlWidget(
                html,
                factoryBuilder: () => _BuildBitWidgetFactory(),
                key: helper.hwKey,
              ));

      testWidgets('accepts BuildContext', (WidgetTester tester) async {
        final html = '1 <span class="input--BuildContext">2</span> 3';
        final explained = await explain(tester, html);
        expect(
            explained,
            equals('[Column:children='
                '[RichText:(:1 2)],'
                '[Text:Foo],'
                '[RichText:(:3)]'
                ']'));
      });

      group('accepts GestureRecognizer', () {
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

      testWidgets('accepts Null', (WidgetTester tester) async {
        final html = '1 <span class="input--Null">2</span> 3';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(:1 2(null) 3)]'));
      });

      testWidgets('accepts TextStyleHtml', (WidgetTester tester) async {
        final html = '1 <span class="input--TextStyleHtml">2</span> 3';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(:1 2(:TextStyleHtml)(: 3))]'));
      });

      testWidgets('returns BuildTree', (WidgetTester tester) async {
        final html = '1 <span class="output--BuildTree">2</span> 3';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(:1 2 foo bar 3)]'));
      });

      group('returns GestureRecognizer', () {
        final clazz = 'output--GestureRecognizer';

        testWidgets('SPAN tag with BuildBit', (WidgetTester tester) async {
          final html = '1 <span class="$clazz">2</span> 3';
          final e = await explain(tester, html);
          expect(e, equals('[RichText:(+MultiTapGestureRecognizer:1 2 3)]'));
        });

        testWidgets('SPAN tag with styling + BuildBit', (tester) async {
          final html = '1 <span class="custom $clazz">2</span> 3';
          final explained = await explain(tester, html);
          expect(explained,
              equals('[RichText:(:1 (+MultiTapGestureRecognizer:2)(: 3))]'));
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
          expect(
              explained,
              equals(
                  '[RichText:(:1 (#FF0000FF+u+MultiTapGestureRecognizer:2)(: 3))]'));
        });
      });

      testWidgets('returns InlineSpan', (WidgetTester tester) async {
        final html = '1 <span class="output--InlineSpan">2</span> 3';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(:1 2[Text:foo]@bottom(: 3))]'));
      });

      testWidgets('returns String', (WidgetTester tester) async {
        final html = '1 <span class="output--String">2</span> 3';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(:1 2foo 3)]'));
      });

      testWidgets('returns Widget', (WidgetTester tester) async {
        final html = '1 <span class="output--Widget">2</span> 3';
        final explained = await explain(tester, html);
        expect(
            explained,
            equals('[Column:children='
                '[RichText:(:1 2)],'
                '[Text:foo],'
                '[RichText:(:3)]'
                ']'));
      });
    });

    group('prev+next', () {
      final text = _text();
      final bit1 = text.addText('1');
      final text2 = text.sub();
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
        final text1 = text.sub();
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
        final text1 = text.sub();
        text.add(text1);
        text1.addText('(1.1)');
        final bit12 = text1.addText('(1.2)');
        expect(_data(text), equals('(1.1)(1.2)'));

        expect(text.last, equals(bit12));
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
      final root = _text();

      final text = root.sub();
      text.addText('1');
      final text1 = text.sub();
      text.add(text1);
      text1.addText('2');
      text.addText('3');
      expect(
          helper.simplifyHashCode(text.toString()),
          equals('BuildTree#0 tsb#1(parent=#2):\n'
              '  "1"\n'
              '  BuildTree#3 tsb#4(parent=#1):\n'
              '    "2"\n'
              '  "3"'));

      final copied = text.copyWith();
      expect(
          helper.simplifyHashCode('$text\n\n$copied'),
          equals('BuildTree#0 tsb#1(parent=#2):\n'
              '  "1"\n'
              '  BuildTree#3 tsb#4(parent=#1):\n'
              '    "2"\n'
              '  "3"\n'
              '\n'
              'BuildTree#5 tsb#1(parent=#2):\n'
              '  "1"\n'
              '  BuildTree#6 tsb#4(parent=#1):\n'
              '    "2"\n'
              '  "3"'));
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
    final text2 = text.sub();
    text.add(text2);
    text2.addText('(2.1)');
    final text22 = text2.sub();
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
            '  BuildTree#3 tsb#4(parent=#1):\n'
            '    "(2.1)"\n'
            '    BuildTree#5 tsb#6(parent=#4):\n'
            '      "(2.2.1)"\n'
            '      "(2.2.2)"\n'
            '      _TextNewLine#7 tsb#6(parent=#4)\n'
            '    "(2.3)"\n'
            '  WidgetBit.inline#8 WidgetPlaceholder(Text("Hi"))'));
  });
}

class _BuildBitWidgetFactory extends WidgetFactory {
  @override
  void parse(BuildMetadata meta) {
    final classes = meta.element.classes;

    if (classes.contains('input--BuildContext')) {
      meta.register(BuildOp(
          onTree: (_, tree) =>
              tree.add(_InputBuildContextBit(tree, tree.tsb))));
    }

    if (classes.contains('input--GestureRecognizer')) {
      meta.register(BuildOp(
          onTree: (_, tree) =>
              tree.add(_InputGestureRecognizerBit(tree, tree.tsb))));
    }

    if (classes.contains('input--Null')) {
      meta.register(BuildOp(
          onTree: (_, tree) => tree.add(_InputNullBit(tree, tree.tsb))));
    }

    if (classes.contains('input--TextStyleHtml')) {
      meta.register(BuildOp(
          onTree: (_, tree) =>
              tree.add(_InputTextStyleHtmlBit(tree, tree.tsb))));
    }

    if (classes.contains('output--BuildTree')) {
      meta.register(BuildOp(
          onTree: (_, tree) => tree.add(_OutputBuildTreeBit(tree, tree.tsb))));
    }

    if (classes.contains('output--GestureRecognizer')) {
      meta.register(BuildOp(
          onTree: (_, tree) =>
              tree.add(_OutputGestureRecognizerBit(tree, tree.tsb)),
          priority: 9999));
    }

    if (classes.contains('output--InlineSpan')) {
      meta.register(BuildOp(
          onTree: (_, tree) => tree.add(_OutputInlineSpanBit(tree, tree.tsb))));
    }

    if (classes.contains('output--String')) {
      meta.register(BuildOp(
          onTree: (_, tree) => tree.add(_OutputStringBit(tree, tree.tsb))));
    }

    if (classes.contains('output--Widget')) {
      meta.register(BuildOp(
          onTree: (_, tree) => tree.add(_OutputWidgetBit(tree, tree.tsb))));
    }

    if (classes.contains('custom')) {
      meta.tsb((tsh, _) => tsh.copyWith());
    }

    super.parse(meta);
  }
}

class _InputBuildContextBit extends BuildBit<BuildContext, Widget> {
  _InputBuildContextBit(BuildTree parent, TextStyleBuilder tsb)
      : super(parent, tsb);

  @override
  Widget buildBit(BuildContext _) => Text('Foo');

  @override
  BuildBit copyWith({BuildTree parent, TextStyleBuilder tsb}) =>
      _InputBuildContextBit(parent ?? this.parent, tsb ?? this.tsb);
}

class _InputGestureRecognizerBit extends BuildBit<GestureRecognizer, dynamic> {
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

class _InputNullBit extends BuildBit<Null, dynamic> {
  _InputNullBit(BuildTree parent, TextStyleBuilder tsb) : super(parent, tsb);

  @override
  dynamic buildBit(Null _) => '(null)';

  @override
  BuildBit copyWith({BuildTree parent, TextStyleBuilder tsb}) =>
      _InputNullBit(parent ?? this.parent, tsb ?? this.tsb);
}

class _InputTextStyleHtmlBit extends BuildBit<TextStyleHtml, InlineSpan> {
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

class _OutputBuildTreeBit extends BuildBit<Null, BuildTree> {
  final BuildTree tree;

  _OutputBuildTreeBit(BuildTree parent, TextStyleBuilder tsb)
      : tree = parent.sub(tsb: tsb)
          ..addWhitespace()
          ..addText('foo')
          ..addWhitespace()
          ..addText('bar'),
        super(parent, tsb);

  @override
  BuildTree buildBit(Null _) => tree;

  @override
  BuildBit copyWith({BuildTree parent, TextStyleBuilder tsb}) =>
      _OutputBuildTreeBit(parent ?? this.parent, tsb ?? this.tsb);
}

class _OutputGestureRecognizerBit extends BuildBit<Null, GestureRecognizer> {
  _OutputGestureRecognizerBit(BuildTree parent, TextStyleBuilder tsb)
      : super(parent, tsb);

  @override
  GestureRecognizer buildBit(Null _) => MultiTapGestureRecognizer();

  @override
  BuildBit copyWith({BuildTree parent, TextStyleBuilder tsb}) =>
      _OutputGestureRecognizerBit(parent ?? this.parent, tsb ?? this.tsb);
}

class _OutputInlineSpanBit extends BuildBit<Null, InlineSpan> {
  _OutputInlineSpanBit(BuildTree parent, TextStyleBuilder tsb)
      : super(parent, tsb);

  @override
  InlineSpan buildBit(Null _) => WidgetSpan(child: Text('foo'));

  @override
  BuildBit copyWith({BuildTree parent, TextStyleBuilder tsb}) =>
      _OutputInlineSpanBit(parent ?? this.parent, tsb ?? this.tsb);
}

class _OutputStringBit extends BuildBit<Null, String> {
  _OutputStringBit(BuildTree parent, TextStyleBuilder tsb) : super(parent, tsb);

  @override
  String buildBit(Null _) => 'foo';

  @override
  BuildBit copyWith({BuildTree parent, TextStyleBuilder tsb}) =>
      _OutputStringBit(parent ?? this.parent, tsb ?? this.tsb);
}

class _OutputWidgetBit extends BuildBit<Null, Widget> {
  _OutputWidgetBit(BuildTree parent, TextStyleBuilder tsb) : super(parent, tsb);

  @override
  Widget buildBit(Null _) => Text('foo');

  @override
  BuildBit copyWith({BuildTree parent, TextStyleBuilder tsb}) =>
      _OutputWidgetBit(parent ?? this.parent, tsb ?? this.tsb);
}

String _data(BuildTree text) => text.bits
    .map((bit) => (bit is BuildBit<Null, String>)
        ? bit.buildBit(null)
        : '[$bit]'.replaceAll(RegExp(r'#\w+'), ''))
    .join('');

BuildTree _text() => builder.BuildTree(tsb: TextStyleBuilder());
