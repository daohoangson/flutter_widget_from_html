import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:html/dom.dart' as dom;

void main() {
  for (final async in [true, false]) {
    testWidgets(
      'obsolete parse after newer ${async ? 'async' : 'sync'} render',
      (tester) async {
        await tester.runAsync(() async {
          final oldParse = _ParseGate();
          final newParse = _ParseGate();
          final factory = _Factory();
          final taps = <String>[];
          Widget content(
            String text,
            _ParseGate gate, {
            bool buildAsync = true,
          }) =>
              MaterialApp(
                home: _HtmlWidget(
                  '<a href="https://example.com/$text">$text</a>',
                  gate: gate,
                  buildAsync: buildAsync,
                  factoryBuilder: () => factory,
                  onTapUrl: (url) {
                    taps.add(url);
                    return true;
                  },
                ),
              );
          await tester.pumpWidget(content('old', oldParse));
          await oldParse.ready.future;
          await tester.pumpWidget(
            content('current', newParse, buildAsync: async),
          );
          if (async) {
            await newParse.ready.future;
            newParse.release();
            await tester.pump();
          }
          final current = find.text('current', findRichText: true);
          expect(current, findsOneWidget);
          await tester.tapAt(tester.getTopLeft(current) + const Offset(10, 8));
          expect(taps, ['https://example.com/current']);
          final resets = factory.resets;
          oldParse.release();
          await tester.pump();
          expect(factory.resets, resets);
          expect(current, findsOneWidget);
          expect(find.text('old', findRichText: true), findsNothing);
          await tester.tapAt(tester.getTopLeft(current) + const Offset(10, 8));
          expect(taps, List.filled(2, 'https://example.com/current'));
          expect(tester.takeException(), isNull);
        });
      },
    );

    testWidgets(
        'held link gesture survives obsolete parse after newer '
        '${async ? 'async' : 'sync'} render', (tester) async {
      await tester.runAsync(() async {
        final oldParse = _ParseGate();
        final newParse = _ParseGate();
        final taps = <String>[];
        Widget content(
          String text,
          _ParseGate gate, {
          bool buildAsync = true,
        }) =>
            MaterialApp(
              home: _HtmlWidget(
                '<a href="https://example.com/$text">$text</a>',
                gate: gate,
                buildAsync: buildAsync,
                onTapUrl: (url) {
                  taps.add(url);
                  return true;
                },
              ),
            );
        await tester.pumpWidget(content('old', oldParse));
        await oldParse.ready.future;
        await tester.pumpWidget(
          content('current', newParse, buildAsync: async),
        );
        if (async) {
          await newParse.ready.future;
          newParse.release();
          await tester.pump();
        }
        final current = find.text('current', findRichText: true);
        expect(current, findsOneWidget);
        await tester.tapAt(tester.getTopLeft(current) + const Offset(10, 8));
        expect(taps, ['https://example.com/current']);

        final held = await tester.startGesture(
          tester.getTopLeft(current) + const Offset(10, 8),
        );
        oldParse.release();
        await tester.pump();
        await held.up();

        expect(taps, List.filled(2, 'https://example.com/current'));
        expect(current, findsOneWidget);
        expect(find.text('old', findRichText: true), findsNothing);
        expect(tester.takeException(), isNull);
      });
    });
  }
  testWidgets('disposal during parsing does not reset factory', (tester) async {
    await tester.runAsync(() async {
      final gate = _ParseGate();
      final factory = _Factory();
      await tester.pumpWidget(
        MaterialApp(
          home: _HtmlWidget('old', gate: gate, factoryBuilder: () => factory),
        ),
      );
      await gate.ready.future;
      await tester.pumpWidget(const SizedBox());
      final resets = factory.resets;
      expect(factory.disposals, 1);
      gate.release();
      await tester.pump();
      expect(factory.resets, resets);
      expect(factory.disposals, 1);
      expect(tester.takeException(), isNull);
    });
  });
}

class _Factory extends WidgetFactory {
  int resets = 0;
  int disposals = 0;
  @override
  void reset(State state) {
    resets++;
    super.reset(state);
  }

  @override
  void dispose() {
    disposals++;
    super.dispose();
  }
}

class _HtmlWidget extends HtmlWidget {
  final _ParseGate gate;
  const _HtmlWidget(
    super.html, {
    required this.gate,
    super.buildAsync = true,
    super.factoryBuilder,
    super.onTapUrl,
  });
  @override
  HtmlWidgetState createState() => _State();
}

class _State extends HtmlWidgetState {
  @override
  void initState() => (widget as _HtmlWidget).gate.run(super.initState);
  @override
  void didUpdateWidget(HtmlWidget oldWidget) =>
      (widget as _HtmlWidget).gate.run(() => super.didUpdateWidget(oldWidget));
}

// Hold real compute results before their awaiting continuations build bodies.
// Each parse has its own zone, allowing deterministic completion ordering.
class _ParseGate {
  final ready = Completer<void>();
  late void Function() _resume;
  bool _released = false;
  void run(void Function() action) => runZoned(
        action,
        zoneSpecification: ZoneSpecification(
          registerUnaryCallback: <R, T>(self, parent, zone, callback) {
            return parent.registerUnaryCallback<R, T>(zone, (value) {
              if (!_released && value is dom.NodeList) {
                _resume = () => callback(value);
                ready.complete();
                return null as R;
              }
              return callback(value);
            });
          },
        ),
      );
  void release() {
    _released = true;
    _resume();
  }
}
