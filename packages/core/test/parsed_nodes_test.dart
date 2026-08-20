import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:html/dom.dart' as dom;

import '_.dart';

void main() {
  testWidgets('renders from parsedNodes', (tester) async {
    const html = 'Hello <b>World</b>';
    final nodes = parseHtmlToNodes(html);

    final explained = await explain(
      tester,
      null,
      hw: HtmlWidget(
        '',
        key: hwKey,
        parsedNodes: nodes,
      ),
    );

    expect(explained, equals('[RichText:(:Hello (+b:World))]'));
  });

  testWidgets('reacts to parsedNodes changes (new object)', (tester) async {
    final nodes1 = parseHtmlToNodes('Foo');
    final nodes2 = parseHtmlToNodes('Bar');

    final e1 = await explain(
      tester,
      null,
      hw: HtmlWidget(
        '',
        key: hwKey,
        parsedNodes: nodes1,
      ),
    );
    expect(e1, equals('[RichText:(:Foo)]'));

    final e2 = await explain(
      tester,
      null,
      hw: HtmlWidget(
        '',
        key: hwKey,
        parsedNodes: nodes2,
      ),
    );
    expect(e2, equals('[RichText:(:Bar)]'));
  });

  testWidgets('does NOT react to in-place parsedNodes changes', (tester) async {
    final nodes = parseHtmlToNodes('Foo');

    final e1 = await explain(
      tester,
      null,
      hw: HtmlWidget(
        '',
        key: hwKey,
        parsedNodes: nodes,
      ),
    );
    expect(e1, equals('[RichText:(:Foo)]'));

    // Modify nodes in place
    nodes.first.text = 'Bar';

    // We need to trigger a rebuild of the TestApp/HtmlWidget with the SAME nodes object
    await tester.pumpWidget(
      StatefulBuilder(
        builder: (context, setState) => GestureDetector(
          onTap: () => setState(() {}),
          child: HtmlWidget(
            '',
            key: hwKey,
            parsedNodes: nodes,
          ),
        ),
      ),
    );

    // Initial state
    expect(await explainWithoutPumping(), equals('[RichText:(:Foo)]'));

    // Trigger rebuild
    await tester.tap(find.byType(GestureDetector));
    await tester.pump();

    // It should STILL be Foo because rebuildTriggers didn't change (same NodeList object)
    expect(await explainWithoutPumping(), equals('[RichText:(:Foo)]'));
  });
}
