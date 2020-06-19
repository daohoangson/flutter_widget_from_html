import 'package:flutter_test/flutter_test.dart';

import '_.dart';

void main() {
  group('height', () {
    testWidgets('renders em', (WidgetTester tester) async {
      final html = '<div style="height: 2em">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[ConstrainedBox:'
              'constraints=(0.0<=w<=Infinity, h=20.0),'
              'child=[RichText:(:Foo)]]'));
    });

    testWidgets('renders px', (WidgetTester tester) async {
      final html = '<div style="height: 100px">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[ConstrainedBox:'
              'constraints=(0.0<=w<=Infinity, h=100.0),'
              'child=[RichText:(:Foo)]]'));
    });

    testWidgets('renders invalid', (WidgetTester tester) async {
      final html = '<div style="height: xxx">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });
  });

  group('max-height', () {
    testWidgets('renders em', (WidgetTester tester) async {
      final html = '<div style="max-height: 2em">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[ConstrainedBox:'
              'constraints=(0.0<=w<=Infinity, 0.0<=h<=20.0),'
              'child=[RichText:(:Foo)]]'));
    });

    testWidgets('renders px', (WidgetTester tester) async {
      final html = '<div style="max-height: 100px">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[ConstrainedBox:'
              'constraints=(0.0<=w<=Infinity, 0.0<=h<=100.0),'
              'child=[RichText:(:Foo)]]'));
    });

    testWidgets('renders invalid', (WidgetTester tester) async {
      final html = '<div style="max-height: xxx">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });
  });

  group('max-width', () {
    testWidgets('renders em', (WidgetTester tester) async {
      final html = '<div style="max-width: 2em">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[ConstrainedBox:'
              'constraints=(0.0<=w<=20.0, 0.0<=h<=Infinity),'
              'child=[RichText:(:Foo)]]'));
    });

    testWidgets('renders px', (WidgetTester tester) async {
      final html = '<div style="max-width: 100px">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[ConstrainedBox:'
              'constraints=(0.0<=w<=100.0, 0.0<=h<=Infinity),'
              'child=[RichText:(:Foo)]]'));
    });

    testWidgets('renders invalid', (WidgetTester tester) async {
      final html = '<div style="max-width: xxx">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });
  });

  group('min-height', () {
    testWidgets('renders em', (WidgetTester tester) async {
      final html = '<div style="min-height: 2em">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[ConstrainedBox:'
              'constraints=(0.0<=w<=Infinity, 20.0<=h<=Infinity),'
              'child=[RichText:(:Foo)]]'));
    });

    testWidgets('renders px', (WidgetTester tester) async {
      final html = '<div style="min-height: 100px">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[ConstrainedBox:'
              'constraints=(0.0<=w<=Infinity, 100.0<=h<=Infinity),'
              'child=[RichText:(:Foo)]]'));
    });

    testWidgets('renders invalid', (WidgetTester tester) async {
      final html = '<div style="min-height: xxx">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });
  });

  group('min-width', () {
    testWidgets('renders em', (WidgetTester tester) async {
      final html = '<div style="min-width: 2em">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[ConstrainedBox:'
              'constraints=(20.0<=w<=Infinity, 0.0<=h<=Infinity),'
              'child=[RichText:(:Foo)]]'));
    });

    testWidgets('renders px', (WidgetTester tester) async {
      final html = '<div style="min-width: 100px">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[ConstrainedBox:'
              'constraints=(100.0<=w<=Infinity, 0.0<=h<=Infinity),'
              'child=[RichText:(:Foo)]]'));
    });

    testWidgets('renders invalid', (WidgetTester tester) async {
      final html = '<div style="min-width: xxx">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });
  });

  group('width', () {
    testWidgets('renders em', (WidgetTester tester) async {
      final html = '<div style="width: 2em">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[ConstrainedBox:'
              'constraints=(w=20.0, 0.0<=h<=Infinity),'
              'child=[RichText:(:Foo)]]'));
    });

    testWidgets('renders px', (WidgetTester tester) async {
      final html = '<div style="width: 100px">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[ConstrainedBox:'
              'constraints=(w=100.0, 0.0<=h<=Infinity),'
              'child=[RichText:(:Foo)]]'));
    });

    testWidgets('renders invalid', (WidgetTester tester) async {
      final html = '<div style="width: xxx">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });
  });
}
