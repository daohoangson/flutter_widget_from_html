import 'package:flutter_test/flutter_test.dart';

import '_.dart';

void main() {
  group('basic usage', () {
    const html = '<div style="display: flex"></div>';

    testWidgets('renders', (WidgetTester tester) async {
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Flex:direction=horizontal,mainAxisAlignment=start,crossAxisAlignment=start,children=[widget0]]',
        ),
      );
    });
  });

  group('horizontal alignment - flex start', () {
    const html = '<div style="display: flex; align-items: flex-start;"></div>';

    testWidgets('renders', (WidgetTester tester) async {
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Flex:direction=horizontal,mainAxisAlignment=start,crossAxisAlignment=start,children=[widget0]]',
        ),
      );
    });
  });

  group('horizontal alignment - center', () {
    const html = '<div style="display: flex; align-items: flex-center;"></div>';

    testWidgets('renders', (WidgetTester tester) async {
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Flex:direction=horizontal,mainAxisAlignment=start,crossAxisAlignment=start,children=[widget0]]',
        ),
      );
    });
  });

  group('horizontal alignment - flex end', () {
    const html = '<div style="display: flex; align-items: flex-end;"></div>';

    testWidgets('renders', (WidgetTester tester) async {
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Flex:direction=horizontal,mainAxisAlignment=start,crossAxisAlignment=end,children=[widget0]]',
        ),
      );
    });
  });

  group('horizontal alignment - stretch', () {
    const html = '<div style="display: flex; align-items: stretch;"></div>';

    testWidgets('renders', (WidgetTester tester) async {
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Flex:direction=horizontal,mainAxisAlignment=start,crossAxisAlignment=stretch,children=[widget0]]',
        ),
      );
    });
  });

  group('vertical alignment - flex start', () {
    const html =
        '<div style="display: flex; justify-content: flex-start;"></div>';

    testWidgets('renders', (WidgetTester tester) async {
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Flex:direction=horizontal,mainAxisAlignment=start,crossAxisAlignment=start,children=[widget0]]',
        ),
      );
    });
  });

  group('vertical alignment - center', () {
    const html = '<div style="display: flex; justify-content: center;"></div>';

    testWidgets('renders', (WidgetTester tester) async {
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Flex:direction=horizontal,mainAxisAlignment=center,crossAxisAlignment=start,children=[widget0]]',
        ),
      );
    });
  });

  group('vertical alignment - flex end', () {
    const html =
        '<div style="display: flex; justify-content: flex-end;"></div>';

    testWidgets('renders', (WidgetTester tester) async {
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Flex:direction=horizontal,mainAxisAlignment=end,crossAxisAlignment=start,children=[widget0]]',
        ),
      );
    });
  });

  group('vertical alignment - space between', () {
    const html =
        '<div style="display: flex; justify-content: space-between;"></div>';

    testWidgets('renders', (WidgetTester tester) async {
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Flex:direction=horizontal,mainAxisAlignment=spaceBetween,crossAxisAlignment=start,children=[widget0]]',
        ),
      );
    });
  });

  group('vertical alignment - space around', () {
    const html =
        '<div style="display: flex; justify-content: space-around;"></div>';

    testWidgets('renders', (WidgetTester tester) async {
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Flex:direction=horizontal,mainAxisAlignment=spaceAround,crossAxisAlignment=start,children=[widget0]]',
        ),
      );
    });
  });

  group('vertical alignment - space evenly', () {
    const html =
        '<div style="display: flex; justify-content: space-evenly;"></div>';

    testWidgets('renders', (WidgetTester tester) async {
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Flex:direction=horizontal,mainAxisAlignment=spaceEvenly,crossAxisAlignment=start,children=[widget0]]',
        ),
      );
    });
  });

  group('flex direction - row', () {
    const html = '<div style="display: flex; flex-direction: row;"></div>';

    testWidgets('renders', (WidgetTester tester) async {
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Flex:direction=horizontal,mainAxisAlignment=start,crossAxisAlignment=start,children=[widget0]]',
        ),
      );
    });
  });
}
