import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart' show WidgetTester, testWidgets;
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:test/test.dart';

import '../../_.dart' as helper;

void main() {
  group('BuildOp', () {
    Future<String> explain(
      WidgetTester tester,
      String html, {
      BuildOp? inlineBuildOp,
    }) =>
        helper.explain(
          tester,
          null,
          hw: HtmlWidget(
            html,
            factoryBuilder: () => _BuildOpWidgetFactory(
              inlineBuildOp: inlineBuildOp,
            ),
            key: helper.hwKey,
          ),
        );

    group('onRenderInlineBlock', () {
      testWidgets('renders span box', (WidgetTester tester) async {
        const html = 'Hello <span class="inlineBuildOp">foo</span>';
        final explained = await explain(
          tester,
          html,
          inlineBuildOp: BuildOp.inline(
            onRenderInlineBlock: (tree, child) {
              return ColoredBox(
                color: Colors.red,
                child: child,
              );
            },
          ),
        );
        expect(
          explained,
          equals('[RichText:(:Hello [ColoredBox:child=[RichText:(:foo)]])]'),
        );
      });

      testWidgets('works with block', (WidgetTester tester) async {
        const html = 'Hello <div class="inlineBuildOp">foo</div>';
        final explained = await explain(
          tester,
          html,
          inlineBuildOp: BuildOp.inline(
            onRenderInlineBlock: (tree, child) {
              return ColoredBox(
                color: Colors.green,
                child: child,
              );
            },
          ),
        );
        expect(
          explained,
          equals(
            '[Column:children='
            '[RichText:(:Hello)],'
            '[ColoredBox:child=[CssBlock:child=[RichText:(:foo)]]]'
            ']',
          ),
        );
      });

      testWidgets('works with multiple blocks', (WidgetTester tester) async {
        const html = 'Hello <div class="inlineBuildOp" '
            '><div>foo</div><div>bar</div></div>';
        final explained = await explain(
          tester,
          html,
          inlineBuildOp: BuildOp.inline(
            onRenderInlineBlock: (tree, child) {
              return ColoredBox(
                color: Colors.green,
                child: child,
              );
            },
          ),
        );
        expect(
          explained,
          equals(
            '[Column:children='
            '[RichText:(:Hello)],'
            '[ColoredBox:child=[CssBlock:child=[Column:children='
            '[CssBlock:child=[RichText:(:foo)]],'
            '[CssBlock:child=[RichText:(:bar)]]'
            ']]]'
            ']',
          ),
        );
      });

      testWidgets('works with inline-block', (WidgetTester tester) async {
        const html = 'Hello <span class="inlineBuildOp" '
            'style="display: inline-block">foo</span>';
        final explained = await explain(
          tester,
          html,
          inlineBuildOp: BuildOp.inline(
            onRenderInlineBlock: (tree, child) {
              return ColoredBox(
                color: Colors.green,
                child: child,
              );
            },
          ),
        );
        expect(
          explained,
          equals('[RichText:(:Hello [ColoredBox:child=[RichText:(:foo)]])]'),
        );
      });
    });
  });
}

class _BuildOpWidgetFactory extends WidgetFactory {
  final BuildOp? inlineBuildOp;

  _BuildOpWidgetFactory({
    this.inlineBuildOp,
  });

  @override
  void parse(BuildTree tree) {
    final classes = tree.element.classes;

    if (classes.contains('inlineBuildOp')) {
      tree.register(inlineBuildOp!);
    }

    super.parse(tree);
  }
}
