// ignore_for_file: deprecated_member_use_from_same_package

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:logging/logging.dart';

import '../_.dart';

void main() {
  group('BuildOp.new (legacy)', () {
    group('defaultStyles', () {
      testWidgets('renders inline style normally', (tester) async {
        const html = '<span style="color: #f00; color: #0f0;">Foo</span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(#FF00FF00:Foo)]'));
      });

      testWidgets('renders defaultStyles in reversed', (tester) async {
        const html = '<span>Foo</span>';
        final explained = await explain(
          tester,
          null,
          hw: HtmlWidget(
            html,
            factoryBuilder: () => _BuildOpDefaultStyles(),
            key: hwKey,
          ),
        );
        expect(explained, equals('[RichText:(#FFFF0000:Foo)]'));
      });
    });

    group('onChild', () {
      testWidgets('renders additional text', (tester) async {
        const html =
            '<span class="parent">Foo <span class="child">bar</span></span>';
        final explained = await explain(
          tester,
          null,
          hw: HtmlWidget(
            html,
            factoryBuilder: () => _BuildOpOnChild(),
            key: hwKey,
          ),
        );
        expect(explained, equals('[RichText:(:Foo bar!)]'));
      });
    });

    group('onTree', () {
      testWidgets('renders additional text', (tester) async {
        const html = '<span class="build-op">Foo</span>';
        final explained = await explain(
          tester,
          null,
          hw: HtmlWidget(
            html,
            factoryBuilder: () => _BuildOpWidgetFactory(
              BuildOp(onTree: (_, tree) => tree.addText(' bar')),
            ),
            key: hwKey,
          ),
        );
        expect(explained, equals('[RichText:(:Foo bar)]'));
      });

      testWidgets('renders block widget', (tester) async {
        const html = '<span class="build-op">Foo</span>';
        final explained = await explain(
          tester,
          null,
          hw: HtmlWidget(
            html,
            factoryBuilder: () => _BuildOpWidgetFactory(
              BuildOp(
                onTree: (_, tree) =>
                    tree.append(WidgetBit.block(tree, const Text('hi'))),
              ),
            ),
            key: hwKey,
          ),
          useExplainer: false,
        );
        expect(
          explained,
          equals(
            'HtmlStyleWidget\n'
            '└ColumnPlaceholder(root--column)\n'
            ' └Column()\n'
            '  ├RichText(text: "Foo")\n'
            '  └Text("hi")\n'
            '   └RichText(text: "hi")\n\n',
          ),
        );
      });

      testWidgets('renders block widget over div', (tester) async {
        const html = '<div class="build-op"><div>Foo</div></div>';
        final explained = await explain(
          tester,
          null,
          hw: HtmlWidget(
            html,
            factoryBuilder: () => _BuildOpWidgetFactory(
              BuildOp(
                onTree: (_, tree) =>
                    tree.append(WidgetBit.block(tree, const Text('hi'))),
              ),
            ),
            key: hwKey,
          ),
          useExplainer: false,
        );
        expect(
          explained,
          equals(
            'HtmlStyleWidget\n'
            '└ColumnPlaceholder(div--column)\n'
            ' └CssBlock()\n'
            '  └Column()\n'
            '   ├CssBlock()\n'
            '   │└RichText(text: "Foo")\n'
            '   └Text("hi")\n'
            '    └RichText(text: "hi")\n\n',
          ),
        );
      });

      testWidgets('renders inline widget', (tester) async {
        const html = '<span class="build-op">bar</span>';
        final explained = await explain(
          tester,
          null,
          hw: HtmlWidget(
            html,
            factoryBuilder: () => _BuildOpWidgetFactory(
              BuildOp(
                onTree: (_, tree) =>
                    tree.append(WidgetBit.inline(tree, const Text('hi'))),
              ),
            ),
            key: hwKey,
          ),
          useExplainer: false,
        );
        expect(explained, contains('HtmlStyleWidget'));
        expect(explained, contains('└WidgetPlaceholder(root--text)'));
        expect(explained, contains('└RichText(text: "bar\u{fffc}")'));
        expect(
          explained,
          contains('└WidgetPlaceholder(span--WidgetBit.inline)'),
        );
        expect(explained, contains('└Text("hi")'));
        expect(explained, contains('└RichText(text: "hi")'));
      });
    });

    group('onTreeFlattening', () {
      testWidgets('renders additional text', (tester) async {
        const html = '<span class="build-op">Foo</span>';
        final explained = await explain(
          tester,
          null,
          hw: HtmlWidget(
            html,
            factoryBuilder: () => _BuildOpWidgetFactory(
              BuildOp(onTreeFlattening: (_, tree) => tree.addText(' bar')),
            ),
            key: hwKey,
          ),
        );
        expect(explained, equals('[RichText:(:Foo bar)]'));
      });

      testWidgets('renders block widget', (tester) async {
        const html = '<span class="build-op">Foo</span>';
        final explained = await explain(
          tester,
          null,
          hw: HtmlWidget(
            html,
            factoryBuilder: () => _BuildOpWidgetFactory(
              BuildOp(
                onTreeFlattening: (_, tree) =>
                    tree.append(WidgetBit.block(tree, const Text('hi'))),
              ),
            ),
            key: hwKey,
          ),
          useExplainer: false,
        );
        expect(
          explained,
          equals(
            'HtmlStyleWidget\n'
            '└ColumnPlaceholder(root--column)\n'
            ' └Column()\n'
            '  ├RichText(text: "Foo")\n'
            '  └Text("hi")\n'
            '   └RichText(text: "hi")\n\n',
          ),
        );
      });

      testWidgets('renders inline widget', (tester) async {
        const html = '<span class="build-op">bar</span>';
        final explained = await explain(
          tester,
          null,
          hw: HtmlWidget(
            html,
            factoryBuilder: () => _BuildOpWidgetFactory(
              BuildOp(
                onTreeFlattening: (_, tree) =>
                    tree.append(WidgetBit.inline(tree, const Text('hi'))),
              ),
            ),
            key: hwKey,
          ),
          useExplainer: false,
        );
        expect(explained, contains('HtmlStyleWidget'));
        expect(explained, contains('└WidgetPlaceholder(root--text)'));
        expect(explained, contains('└RichText(text: "bar\u{fffc}")'));
        expect(
          explained,
          contains('└WidgetPlaceholder(span--WidgetBit.inline)'),
        );
        expect(explained, contains('└Text("hi")'));
        expect(explained, contains('└RichText(text: "hi")'));
      });
    });

    group('onWidgets', () {
      testWidgets('renders widget: null', (tester) async {
        const html = '<span class="build-op">Foo</span>';
        final explained = await explain(
          tester,
          null,
          hw: HtmlWidget(
            html,
            factoryBuilder: () => _BuildOpWidgetFactory(
              BuildOp(onWidgets: (_, __) => listOrNull(null)),
            ),
            key: hwKey,
          ),
          useExplainer: false,
        );
        expect(
          explained,
          equals(
            'HtmlStyleWidget\n'
            '└WidgetPlaceholder(span--text)\n'
            ' └RichText(text: "Foo")\n\n',
          ),
        );
      });

      testWidgets('renders widget: empty', (tester) async {
        const html = '<span class="build-op">Foo</span>';
        final explained = await explain(
          tester,
          null,
          hw: HtmlWidget(
            html,
            factoryBuilder: () => _BuildOpWidgetFactory(
              BuildOp(onWidgets: (_, __) => const []),
            ),
            key: hwKey,
          ),
          useExplainer: false,
        );
        expect(
          explained,
          equals(
            'HtmlStyleWidget\n'
            '└WidgetPlaceholder(span--lazy)\n'
            ' └SizedBox.shrink()\n\n',
          ),
        );
      });

      testWidgets('renders widget: one', (tester) async {
        const html = '<span class="build-op">Foo</span>';
        final explained = await explain(
          tester,
          null,
          hw: HtmlWidget(
            html,
            factoryBuilder: () => _BuildOpWidgetFactory(
              BuildOp(onWidgets: (_, __) => listOrNull(const Text('Hi'))),
            ),
            key: hwKey,
          ),
          useExplainer: false,
        );
        expect(
          explained,
          equals(
            'HtmlStyleWidget\n'
            '└WidgetPlaceholder(span--lazy)\n'
            ' └Text("Hi")\n'
            '  └RichText(text: "Hi")\n\n',
          ),
        );
      });

      testWidgets('throws on widget: multiple', (tester) async {
        const html = '<span class="build-op">Foo</span>';
        final records = <LogRecord>[];
        await explain(
          tester,
          null,
          hw: _LoggerApp(
            records: records,
            child: HtmlWidget(
              html,
              factoryBuilder: () => _BuildOpWidgetFactory(
                BuildOp(onWidgets: (_, __) => const [Text('One'), Text('Two')]),
              ),
              key: hwKey,
            ),
          ),
          useExplainer: false,
        );
        expect(
          records.map((r) => r.error),
          equals([isA<UnsupportedError>()]),
        );
      });
    });

    group('priority', () {
      const html = '<span>Foo</span>';

      testWidgets('renders A first', (tester) async {
        final explained = await explain(
          tester,
          null,
          hw: HtmlWidget(
            html,
            factoryBuilder: () => _BuildOpPriority(a: 1, b: 2),
            key: hwKey,
          ),
        );
        expect(explained, equals('[RichText:(:Foo A B)]'));
      });

      testWidgets('renders B first', (tester) async {
        final explained = await explain(
          tester,
          null,
          hw: HtmlWidget(
            html,
            factoryBuilder: () => _BuildOpPriority(a: 2, b: 1),
            key: hwKey,
          ),
        );
        expect(explained, equals('[RichText:(:Foo B A)]'));
      });
    });
  });
}

class _BuildOpDefaultStyles extends WidgetFactory {
  @override
  void parse(BuildTree tree) {
    tree
      ..register(
        BuildOp(
          defaultStyles: (_) => {'color': '#f00'},
          priority: 1,
        ),
      )
      ..register(
        BuildOp(
          defaultStyles: (_) => {'color': '#0f0'},
          priority: 2,
        ),
      );

    return super.parse(tree);
  }
}

class _BuildOpOnChild extends WidgetFactory {
  @override
  void parse(BuildTree tree) {
    if (tree.element.classes.contains('parent')) {
      tree.register(
        BuildOp(
          onChild: (subTree) {
            if (subTree.element.classes.contains('child')) {
              subTree.register(
                BuildOp(
                  onTreeFlattening: (_, subTree) => subTree.addText('!'),
                ),
              );
            }
          },
        ),
      );
    }

    return super.parse(tree);
  }
}

class _BuildOpPriority extends WidgetFactory {
  final int a;
  final int b;

  _BuildOpPriority({required this.a, required this.b});

  @override
  void parse(BuildTree tree) {
    tree
      ..register(
        BuildOp(
          onTree: (_, tree) => tree.addText(' A'),
          priority: a,
        ),
      )
      ..register(
        BuildOp(
          onTree: (_, tree) => tree.addText(' B'),
          priority: b,
        ),
      );

    return super.parse(tree);
  }
}

class _BuildOpWidgetFactory extends WidgetFactory {
  final BuildOp buildOp;

  _BuildOpWidgetFactory(this.buildOp);

  @override
  void parse(BuildTree tree) {
    if (tree.element.classes.contains('build-op')) {
      tree.register(buildOp);
    }

    return super.parse(tree);
  }
}

class _LoggerApp extends StatefulWidget {
  final Widget child;
  final List<LogRecord> records;

  const _LoggerApp({
    required this.child,
    Key? key,
    required this.records,
  }) : super(key: key);

  @override
  State<_LoggerApp> createState() => _LoggerAppState();
}

class _LoggerAppState extends State<_LoggerApp> {
  late final StreamSubscription<LogRecord> _subscription;
  @override
  void initState() {
    super.initState();
    _subscription = Logger.root.onRecord.listen(_onLogRecord);
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void _onLogRecord(LogRecord record) => widget.records.add(record);
}
