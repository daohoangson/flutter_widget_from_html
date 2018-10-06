import 'package:flutter_test/flutter_test.dart';

import 'package:tinhte_html_widget/config.dart';
import 'package:tinhte_html_widget/src/parsed_node.dart';

List<ParsedNode> _test(String html) {
  final domNodes = parseDomNodes(html);
  return ParsedNodeProcessor(config: const Config()).parse(domNodes);
}

void main() {
  group('ParsedNodeProcessor', () {
    test('handles bare string', () {
      final html = 'Hello world';
      final list = _test(html);
      expect(list.length, equals(1));

      final parsed = list.first;
      expect((parsed as ParsedNodeText).text, equals(html));
    });

    test('handles A tag', () {
      final html = 'This is a <a>hyperlink</a>.';
      final list = _test(html);
      expect(list.length, equals(4));

      expect((list[0] as ParsedNodeText).text, equals('This is a '));
      expect(list[1], isInstanceOf<ParsedNodeStyle>());
      expect((list[2] as ParsedNodeText).text, equals('hyperlink'));
      expect((list[3] as ParsedNodeText).text, equals('.'));
    });

    test('handles heading tags', () {
      final html = """<h1>This is heading 1</h1>
<h2>This is heading 2</h2>
<h3>This is heading 3</h3>
<h4>This is heading 4</h4>
<h5>This is heading 5</h5>
<h6>This is heading 6</h6>""";
      final list = _test(html);
      expect(list.length, equals(17));

      for (final styleNodeIndex in [0, 3, 6, 9, 12, 15]) {
        expect(list[styleNodeIndex], isInstanceOf<ParsedNodeStyle>());
      }

      for (final lineBreakIndex in [2, 5, 8, 11, 14]) {
        expect((list[lineBreakIndex] as ParsedNodeText).text, equals('\n'));
      }

      expect((list[1] as ParsedNodeText).text, equals('This is heading 1'));
      expect((list[4] as ParsedNodeText).text, equals('This is heading 2'));
      expect((list[7] as ParsedNodeText).text, equals('This is heading 3'));
      expect((list[10] as ParsedNodeText).text, equals('This is heading 4'));
      expect((list[13] as ParsedNodeText).text, equals('This is heading 5'));
      expect((list[16] as ParsedNodeText).text, equals('This is heading 6'));
    });

    test('handles IMG tag between texts', () {
      final html = 'Before text. <img src="image.png" /> After text.';
      final list = _test(html);
      expect(list.length, equals(3));

      expect((list[0] as ParsedNodeText).text, equals('Before text. '));
      expect((list[1] as ParsedNodeImage).src, equals('image.png'));
      expect((list[2] as ParsedNodeText).text, equals(' After text.'));
    });
  });
}
