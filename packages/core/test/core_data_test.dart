import 'package:flutter/widgets.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:test/test.dart';

import '_.dart';

void main() {
  group('BuiltPiece', () {
    test('toString (text)', () {
      final text = TextBits(null)..addText('Foo');
      final piece = BuiltPiece.text(text);
      expect(simplifyHashCode(piece.toString()),
          equals('BuiltPiece.text(TextBits#0 null:\n  "Foo")'));
    });

    test('toString (widgets)', () {
      final piece = BuiltPiece.widgets([Text('Foo')]);
      expect(
          simplifyHashCode(piece.toString()),
          equals('BuiltPiece.widgets('
              '(WidgetPlaceholder<Widget>(Text("Foo")))'
              ')'));
    });
  });
}
