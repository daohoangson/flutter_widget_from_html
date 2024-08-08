import 'package:csslib/parser.dart' as css;
import 'package:csslib/visitor.dart' as css;
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:flutter_widget_from_html_core/src/internal/core_build_tree.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

void main() {
  group('CoreBuildTree', () {
    group('styles', () {
      test('is unlocked initially', () {
        final tree = _newTree();
        expect(tree.styles.isLocked, isFalse);
      });

      test('is unlocked in onVisitChild', () {
        final list = <bool>[];
        final tree = _newTree(
          wf: _WidgetFactory(
            onParse: (tree) => tree.register(
              BuildOp(
                onVisitChild: (_, subTree) => list.add(subTree.styles.isLocked),
              ),
            ),
          ),
        );
        tree.addBitsFromNodes(_parseHtml('<div><span>Foo</span></div>'));
        expect(list, equals([false]));
      });

      test('is locked in parseStyle', () {
        final list = <bool>[];
        final tree = _newTree(
          wf: _WidgetFactory(
            onParseStyle: (tree) => list.add(tree.styles.isLocked),
          ),
        );
        tree.addBitsFromNodes(_parseHtml('<div>Foo</div>'));
        expect(list, equals([true]));
      });

      group('modifications', () {
        final red = _parseCss('color: red').first;
        final green = _parseCss('color: green').first;

        test('add value', () {
          final tree = _newTree();
          tree.styles.add(red);
          expect(tree.styles.toList(), [red]);
        });

        test('add value one by one', () {
          final tree = _newTree();
          tree.styles.add(red);
          tree.styles.add(green);
          expect(tree.styles.toList(), [red, green]);
        });

        test('add all values', () {
          final tree = _newTree();
          tree.styles.addAll([red, green]);
          expect(tree.styles.toList(), [red, green]);
        });

        test('throw error while being locked', () {
          Object? addError;
          final tree = _newTree(
            wf: _WidgetFactory(
              onParseStyle: (tree) {
                try {
                  tree.styles.add(red);
                } catch (e) {
                  addError = e;
                }
              },
            ),
          );
          tree.addBitsFromNodes(_parseHtml('<div>Foo</div>'));
          expect(addError, isAssertionError);
        });
      });
    });
  });
}

CoreBuildTree _newTree({
  WidgetFactory? wf,
}) =>
    CoreBuildTree.root(
      inheritanceResolvers: InheritanceResolvers(),
      wf: wf ?? _WidgetFactory(),
    );

List<css.Declaration> _parseCss(String input) =>
    css.parse('*{$input}').collectDeclarations();

dom.NodeList _parseHtml(String html) =>
    parser.HtmlParser(html, parseMeta: false).parseFragment().nodes;

class _WidgetFactory extends WidgetFactory {
  final void Function(BuildTree value)? onParse;
  final void Function(BuildTree value)? onParseStyle;

  _WidgetFactory({
    this.onParse,
    this.onParseStyle,
  });

  @override
  void parse(BuildTree tree) {
    onParse?.call(tree);
    super.parse(tree);
  }

  @override
  void parseStyle(BuildTree tree, css.Declaration style) {
    onParseStyle?.call(tree);
    super.parseStyle(tree, style);
  }
}
