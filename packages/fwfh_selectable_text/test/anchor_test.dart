import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fwfh_selectable_text/fwfh_selectable_text.dart';

import '../../core/test/_.dart';

final _onTapAnchorResults = <String, bool>{};
final _targetFinder = findText('\u{fffc}--> TARGET <--');

void main() {
  testWidgets('scrolls Column', (WidgetTester tester) async {
    await pumpWidget(tester, const _ColumnTestApp());
    final viewport = tester.getRect(find.byType(MaterialApp));
    final before = tester.getRect(_targetFinder);
    expect(before.top, greaterThan(viewport.bottom));

    expect(await tapText(tester, 'Scroll down'), equals(1));
    await tester.pumpAndSettle();
    expect(_onTapAnchorResults, equals({'target': true}));

    final after = tester.getRect(_targetFinder);
    expect(after.bottom, lessThan(viewport.bottom));
  });

  testWidgets('scrolls ListView', (WidgetTester tester) async {
    await pumpWidget(tester, const _ListViewTestApp());
    expect(_targetFinder, findsNothing);

    expect(await tapText(tester, 'Scroll down'), equals(1));
    await tester.pumpAndSettle();
    expect(_onTapAnchorResults, equals({'target': true}));

    expect(_targetFinder, findsOneWidget);
  });

  testWidgets('scrolls SliverList', (WidgetTester tester) async {
    await pumpWidget(tester, const _SliverListTestApp());
    expect(_targetFinder, findsNothing);

    expect(await tapText(tester, 'Scroll down'), equals(1));
    await tester.pumpAndSettle();
    expect(_onTapAnchorResults, equals({'target': true}));

    expect(_targetFinder, findsOneWidget);
  });
}

const htmlAsc = '''
<p>1</p>
<p>12</p>
<p>123</p>
<p>1234</p>
<p>12345</p>
<p>123456</p>
<p>1234567</p>
<p>12345678</p>
<p>123456789</p>
<p>1234567890</p>''';

const htmlDesc = '''
<p>1234567890</p>
<p>123456789</p>
<p>12345678</p>
<p>1234567</p>
<p>123456</p>
<p>12345</p>
<p>1234</p>
<p>123</p>
<p>12</p>
<p>1</p>''';

final htmlDefault = '''
<a href="#target">Scroll down</a>
${htmlAsc * 3}
<p><a name="target"></a>--&gt; TARGET &lt--</p>
${htmlDesc * 3}
<a href="#target">Scroll up</a>
''';

Future<void> pumpWidget(WidgetTester tester, Widget child) async {
  tester.binding.window.physicalSizeTestValue = const Size(200, 200);
  addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

  tester.binding.window.devicePixelRatioTestValue = 1.0;
  addTearDown(tester.binding.window.clearDevicePixelRatioTestValue);

  tester.binding.window.textScaleFactorTestValue = 1.0;
  addTearDown(tester.binding.window.clearTextScaleFactorTestValue);

  await tester.pumpWidget(MaterialApp(home: child));
  await tester.pump();
}

class _ColumnTestApp extends StatelessWidget {
  const _ColumnTestApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext _) => Scaffold(
        body: SingleChildScrollView(
          child: HtmlWidget(
            htmlDefault,
            factoryBuilder: () => _WidgetFactory(),
          ),
        ),
      );
}

class _ListViewTestApp extends StatelessWidget {
  const _ListViewTestApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext _) => Scaffold(
        body: HtmlWidget(
          htmlDefault,
          factoryBuilder: () => _WidgetFactory(),
          renderMode: RenderMode.listView,
        ),
      );
}

class _SliverListTestApp extends StatelessWidget {
  const _SliverListTestApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext _) => Scaffold(
        body: CustomScrollView(
          cacheExtent: 0,
          slivers: [
            HtmlWidget(
              htmlDefault,
              factoryBuilder: () => _WidgetFactory(),
              renderMode: RenderMode.sliverList,
            ),
          ],
        ),
      );
}

class _WidgetFactory extends WidgetFactory with SelectableTextFactory {
  @override
  Future<bool> onTapAnchor(String id, EnsureVisible scrollTo) async {
    final result = await super.onTapAnchor(id, scrollTo);
    _onTapAnchorResults[id] = result;
    return result;
  }

  @override
  void reset(State<StatefulWidget> state) {
    super.reset(state);
    _onTapAnchorResults.clear();
  }
}
