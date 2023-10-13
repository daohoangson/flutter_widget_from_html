// ignore_for_file: deprecated_member_use_from_same_package

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:flutter_widget_from_html_core/src/internal/core_parser.dart';
import 'package:logging/logging.dart';

import '../_.dart';

void main() {
  group('BuildMetadata', () {
    testWidgets('SmilieScreen works', (tester) async {
      const html = '<p>Hello <img class="smilie smilie-1" alt=":)" '
          'src="http://domain.com/sprites.png" />!</p>';
      final explained = await explain(
        tester,
        null,
        hw: HtmlWidget(
          html,
          factoryBuilder: () => _BuildMetadataSmilies(),
          key: hwKey,
        ),
      );
      expect(explained, contains('Hello 🙂!'));
    });

    testWidgets('style operators work', (tester) async {
      const html = '<span class="setter">Foo</span> '
          '<span class="getter" style="-fwfh-font-size: 42px">bar</span>';
      final explained = await explain(
        tester,
        null,
        hw: HtmlWidget(
          html,
          factoryBuilder: () => _BuildMetadataStyleOperators(),
          key: hwKey,
        ),
      );
      expect(explained, equals('[RichText:(:(@42.0:Foo)(: )(@42.0:bar))]'));
    });

    testWidgets('tsb enqueues', (tester) async {
      const html = '<span class="tsb-enqueue">Foo</span>';
      final explained = await explain(
        tester,
        null,
        hw: HtmlWidget(
          html,
          factoryBuilder: () => _BuildMetadataTsbEnqueue(),
          key: hwKey,
        ),
      );
      expect(explained, contains('#12345678'));
    });
  });

  group('BuildOp.new', () {
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
            '_RootWidget\n'
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
            '_RootWidget\n'
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
        expect(explained, contains('_RootWidget'));
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
            '_RootWidget\n'
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
        expect(explained, contains('_RootWidget'));
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
            '_RootWidget\n'
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
            '_RootWidget\n'
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
            '_RootWidget\n'
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

  group('TextStyleHtml', () {
    group('getDependency', () {
      final dep1 = _LegacyTextStyleHtmlDep1();
      final style = InheritedProperties.root(
        [
          const TextScaleFactor(1.0),
          TextDirection.ltr,
          const TextStyle(inherit: false),
          dep1,
        ],
        null,
      );

      test('returns value', () {
        final dep = style.getDependency<_LegacyTextStyleHtmlDep1>();
        expect(dep, equals(dep1));
      });

      test('throws value', () {
        expect(
          () => style.getDependency<_LegacyTextStyleHtmlDep2>(),
          throwsStateError,
        );
      });
    });
  });

  group('WidgetFactory', () {
    group('gestureTapCallback', () {
      test('calls onTapUrl', () {
        final wf = _WidgetFactoryGestureTapCallback();
        const url = 'https://domain.com';

        final onTap = wf.gestureTapCallback(url);

        onTap?.call();
        expect(wf.urls, equals([url]));
      });
    });
  });
}

class _BuildMetadataSmilies extends WidgetFactory {
  /// Exact code from the demo app for v0.10
  /// https://github.com/daohoangson/flutter_widget_from_html/blob/v0.10.0/demo_app/lib/screens/smilie.dart
  static const kSmilies = {':)': '🙂'};

  final smilieOp = BuildOp(
    onTree: (meta, tree) {
      final alt = meta.element.attributes['alt'];
      tree.addText(kSmilies[alt] ?? alt ?? '');
    },
  );

  @override
  void parse(BuildMetadata meta) {
    final e = meta.element;
    if (e.localName == 'img' &&
        e.classes.contains('smilie') &&
        e.attributes.containsKey('alt')) {
      meta.register(smilieOp);
      return;
    }

    return super.parse(meta);
  }
}

class _BuildMetadataStyleOperators extends WidgetFactory {
  @override
  void parse(BuildMetadata meta) {
    if (meta.element.classes.contains('setter')) {
      meta['font-size'] = '42px';
    }

    if (meta.element.classes.contains('getter')) {
      meta.register(
        BuildOp(
          onTree: (meta, tree) {
            final value = meta['-fwfh-font-size']?.value;
            meta.tsb.enqueue(
              (p, _) {
                final length = value != null ? tryParseCssLength(value) : null;
                final fontSize = length?.getValue(p);
                return p.copyWith(style: p.style.copyWith(fontSize: fontSize));
              },
              null,
            );
          },
        ),
      );
    }

    return super.parse(meta);
  }
}

class _BuildMetadataTsbEnqueue extends WidgetFactory {
  @override
  void parse(BuildMetadata meta) {
    if (meta.element.classes.contains('tsb-enqueue')) {
      meta.register(
        BuildOp(
          onTreeFlattening: (meta, tree) {
            /// Similar code in background color styling for v0.10
            /// https://github.com/daohoangson/flutter_widget_from_html/blob/v0.10.0/packages/core/lib/src/internal/ops/style_bg_color.dart
            meta.tsb.enqueue(_backgroundColor, const Color(0x12345678));
          },
        ),
      );
      return;
    }

    return super.parse(meta);
  }

  static TextStyleHtml _backgroundColor(TextStyleHtml p, Color c) =>
      p.copyWith(style: p.style.copyWith(background: Paint()..color = c));
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

class _LegacyTextStyleHtmlDep1 {}

class _LegacyTextStyleHtmlDep2 {}

class _LoggerApp extends StatefulWidget {
  final Widget child;
  final List<LogRecord> records;

  const _LoggerApp({
    required this.child,
    required this.records,
  });

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

class _WidgetFactoryGestureTapCallback extends WidgetFactory {
  final urls = <String>[];

  @override
  Future<bool> onTapUrl(String url) async {
    urls.add(url);
    return true;
  }
}
