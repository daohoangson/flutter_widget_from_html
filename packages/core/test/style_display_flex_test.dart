import 'package:flutter_test/flutter_test.dart';

import '_.dart';

void main() {
  group('basic usage', () {
    const html = '<div style="display: flex"></div>';

    testWidgets('renders', (WidgetTester tester) async {
      final explained = await explain(tester, html);
      expect(explained, equals('[Flex:direction=horizontal,mainAxisAlignment=start,crossAxisAlignment=start]'));
    });
  });

  group('horizontal alignment - flex start', () {
    const html = '<div style="display: flex; align-items: flex-start;"></div>';

    testWidgets('renders', (WidgetTester tester) async {
      final explained = await explain(tester, html);
      expect(explained, equals('[Flex:direction=horizontal,mainAxisAlignment=start,crossAxisAlignment=start]'));
    });
  });

  group('horizontal alignment - center', () {
    const html = '<div style="display: flex; align-items: flex-center;"></div>';

    testWidgets('renders', (WidgetTester tester) async {
      final explained = await explain(tester, html);
      expect(explained, equals('[Flex:direction=horizontal,mainAxisAlignment=start,crossAxisAlignment=start]'));
    });
  });

  group('horizontal alignment - flex end', () {
    const html = '<div style="display: flex; align-items: flex-end;"></div>';

    testWidgets('renders', (WidgetTester tester) async {
      final explained = await explain(tester, html);
      expect(explained, equals('[Flex:direction=horizontal,mainAxisAlignment=start,crossAxisAlignment=end]'));
    });
  });

  group('horizontal alignment - stretch', () {
    const html = '<div style="display: flex; align-items: stretch;"></div>';

    testWidgets('renders', (WidgetTester tester) async {
      final explained = await explain(tester, html);
      expect(explained,
          equals('[Flex:direction=horizontal,mainAxisAlignment=start,crossAxisAlignment=stretch]'));
    });
  });

  group('vertical alignment - flex start', () {
    const html = '<div style="display: flex; justify-content: flex-start;"></div>';

    testWidgets('renders', (WidgetTester tester) async {
      final explained = await explain(tester, html);
      expect(explained, equals('[Flex:direction=horizontal,mainAxisAlignment=start,crossAxisAlignment=start]'));
    });
  });

  group('vertical alignment - center', () {
    const html = '<div style="display: flex; justify-content: center;"></div>';

    testWidgets('renders', (WidgetTester tester) async {
      final explained = await explain(tester, html);
      expect(explained, equals('[Flex:direction=horizontal,mainAxisAlignment=center,crossAxisAlignment=start]'));
    });
  });

  group('vertical alignment - flex end', () {
    const html = '<div style="display: flex; justify-content: flex-end;"></div>';

    testWidgets('renders', (WidgetTester tester) async {
      final explained = await explain(tester, html);
      expect(explained, equals('[Flex:direction=horizontal,mainAxisAlignment=end,crossAxisAlignment=start]'));
    });
  });

  group('vertical alignment - space between', () {
    const html = '<div style="display: flex; justify-content: space-between;"></div>';

    testWidgets('renders', (WidgetTester tester) async {
      final explained = await explain(tester, html);
      expect(explained, equals('[Flex:direction=horizontal,mainAxisAlignment=spaceBetween,crossAxisAlignment=start]'));
    });
  });

  group('vertical alignment - space around', () {
    const html = '<div style="display: flex; justify-content: space-around;"></div>';

    testWidgets('renders', (WidgetTester tester) async {
      final explained = await explain(tester, html);
      expect(explained, equals('[Flex:direction=horizontal,mainAxisAlignment=spaceAround,crossAxisAlignment=start]'));
    });
  });

  group('vertical alignment - space evenly', () {
    const html = '<div style="display: flex; justify-content: space-evenly;"></div>';

    testWidgets('renders', (WidgetTester tester) async {
      final explained = await explain(tester, html);
      expect(explained, equals('[Flex:direction=horizontal,mainAxisAlignment=spaceEvenly,crossAxisAlignment=start]'));
    });
  });

  group('flex direction - row', () {
    const html = '<div style="display: flex; flex-direction: row;"></div>';

    testWidgets('renders', (WidgetTester tester) async {
      final explained = await explain(tester, html);
      expect(explained, equals('[Flex:direction=horizontal,mainAxisAlignment=start,crossAxisAlignment=start]'));
    });
  });
}
