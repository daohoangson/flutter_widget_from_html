import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:flutter_widget_from_html_core/src/internal/core_ops.dart';

void main() {
  group('Priority', () {
    test('Early.first is before default', () {
      expect(Early.first, lessThan(kPriorityDefault));
    });

    test('BoxModel.first is after default', () {
      expect(BoxModel.first, greaterThan(kPriorityDefault));
    });

    test('background and border should be next to each other', () {
      // they both uses `WidgetFactory.buildDecoration`
      expect(BoxModel.background - BoxModel.border, equals(Priority.step));
    });

    test('Late.displayInlineBlock is before inline block default', () {
      expect(Late.displayInlineBlock, lessThan(kPriorityInlineBlockDefault));
    });

    test('Late.displayNone is after inline block default', () {
      expect(Late.displayNone, greaterThan(kPriorityInlineBlockDefault));
    });

    test('default is between 0 and max', () {
      expect(kPriorityDefault, greaterThanOrEqualTo(0));
      expect(kPriorityDefault, lessThanOrEqualTo(Priority.max));
    });

    test('inline block default is between 0 and max', () {
      expect(kPriorityInlineBlockDefault, greaterThanOrEqualTo(0));
      expect(kPriorityInlineBlockDefault, lessThanOrEqualTo(Priority.max));
    });
  });
}
