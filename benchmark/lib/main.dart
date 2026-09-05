import 'dart:async';
import 'dart:ui' show FramePhase;
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'fixtures.dart';

void main() => runApp(const MaterialApp(
        home: Scaffold(
            body: Text(
      'Run via tool/benchmark.sh; see benchmark/README.md.',
    ))));

Map<String, Object?> distribution(List<int> values) {
  if (values.isEmpty)
    return {'count': 0, 'p50_us': null, 'p90_us': null, 'p99_us': null};
  final sorted = [...values]..sort();
  int percentile(double p) =>
      sorted[((sorted.length * p).ceil() - 1).clamp(0, sorted.length - 1)];
  return {
    'count': sorted.length,
    'p50_us': percentile(.5),
    'p90_us': percentile(.9),
    'p99_us': percentile(.99),
    'max_us': sorted.last
  };
}

/// Records first body paint, including slivers, through a public factory hook.
class PaintFactory extends WidgetFactory {
  PaintFactory(this.onPaint);
  final VoidCallback onPaint;
  @override
  Widget buildBodyWidget(BuildContext context, Widget child) {
    final body = super.buildBodyWidget(context, child);
    return _PaintProbe(
        onPaint: onPaint, sliver: body is SliverList, child: body);
  }
}

class _PaintProbe extends SingleChildRenderObjectWidget {
  const _PaintProbe(
      {required this.onPaint, required this.sliver, required super.child});
  final VoidCallback onPaint;
  final bool sliver;
  @override
  RenderObject createRenderObject(BuildContext context) =>
      sliver ? _SliverProbe(onPaint) : _BoxProbe(onPaint);
}

class _BoxProbe extends RenderProxyBox {
  _BoxProbe(this.callback);
  VoidCallback? callback;
  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);
    callback?.call();
    callback = null;
  }
}

class _SliverProbe extends RenderProxySliver {
  _SliverProbe(this.callback);
  VoidCallback? callback;
  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);
    callback?.call();
    callback = null;
  }
}

Future<Map<String, Object?>> runSuite(
    {int repetitions = 3, bool smoke = false}) async {
  if (!kProfileMode && !smoke)
    throw StateError('Measurements require profile mode');
  final results = <Map<String, Object?>>[];
  final view = WidgetsBinding.instance.platformDispatcher.views.first;
  final data = fixtures();
  // One unreported warm-up per case; fixed order is recorded, not randomized.
  for (final fixture in data.entries) {
    for (final mode in ['column', 'listView', 'sliverList']) {
      for (final async in [false, true]) {
        for (var trial = -1; trial < repetitions; trial++) {
          final controller = ScrollController();
          final painted = Completer<int>();
          final watch = Stopwatch();
          final html = HtmlWidget(
            fixture.value,
            buildAsync: async,
            enableCaching: false,
            factoryBuilder: () => PaintFactory(() {
              if (!painted.isCompleted)
                painted.complete(watch.elapsedMicroseconds);
            }),
            renderMode: mode == 'column'
                ? RenderMode.column
                : mode == 'listView'
                    ? ListViewMode(
                        controller: controller, padding: EdgeInsets.zero)
                    : RenderMode.sliverList,
          );
          final body = mode == 'column'
              ? SingleChildScrollView(controller: controller, child: html)
              : mode == 'sliverList'
                  ? CustomScrollView(controller: controller, slivers: [html])
                  : html;
          PaintingBinding.instance.imageCache.clear();
          PaintingBinding.instance.imageCache.clearLiveImages();
          watch.start();
          runApp(MaterialApp(home: Scaffold(body: body)));
          final firstPaint =
              await painted.future.timeout(const Duration(seconds: 90));
          await Future<void>.delayed(const Duration(milliseconds: 500));
          final frames = <FrameTiming>[];
          void collect(List<FrameTiming> batch) => frames.addAll(batch);
          SchedulerBinding.instance.addTimingsCallback(collect);
          final start = TimelineClock.now();
          var distance = 0.0;
          try {
            // Six viewport-sized steps; re-evaluate lazy scroll extent each time.
            for (var step = 0; step < (smoke ? 1 : 6); step++) {
              final target = (controller.offset +
                      controller.position.viewportDimension * .8)
                  .clamp(0.0, controller.position.maxScrollExtent);
              distance += target - controller.offset;
              await controller.animateTo(target,
                  duration: Duration(milliseconds: smoke ? 100 : 500),
                  curve: Curves.linear);
            }
            final end = TimelineClock.now();
            // Native timing callbacks may be delivered in batches after animation.
            await Future<void>.delayed(const Duration(milliseconds: 1000));
            final selected = frames
                .where((f) =>
                    f.timestampInMicroseconds(FramePhase.vsyncStart) >= start &&
                    f.timestampInMicroseconds(FramePhase.vsyncStart) <= end)
                .toList();
            if (trial >= 0)
              results.add({
                'fixture': fixture.key,
                'html_characters': fixture.value.length,
                'render_mode': mode,
                'build_async': async,
                'trial': trial,
                'first_body_paint_us': firstPaint,
                'scroll_distance_logical_px': distance,
                'scroll_window_us': end - start,
                'build': distribution(selected
                    .map((f) => f.buildDuration.inMicroseconds)
                    .toList()),
                'raster': distribution(selected
                    .map((f) => f.rasterDuration.inMicroseconds)
                    .toList()),
                'total_span': distribution(
                    selected.map((f) => f.totalSpan.inMicroseconds).toList()),
                'frames': selected
                    .map((f) => {
                          'build_us': f.buildDuration.inMicroseconds,
                          'raster_us': f.rasterDuration.inMicroseconds,
                          'total_span_us': f.totalSpan.inMicroseconds
                        })
                    .toList(),
                'frame_status': selected.isEmpty ? 'unavailable' : 'measured',
              });
          } finally {
            SchedulerBinding.instance.removeTimingsCallback(collect);
            runApp(const SizedBox.shrink());
            await Future<void>.delayed(const Duration(milliseconds: 100));
            controller.dispose();
          }
        }
      }
    }
  }
  return {
    'schema_version': 1,
    'metadata': {
      'profile': kProfileMode,
      'smoke_only': smoke,
      'web': kIsWeb,
      'platform': defaultTargetPlatform.name,
      'repetitions': repetitions,
      'compute_execution': kIsWeb ? 'current_event_loop' : 'separate_isolate',
      'physical_width': view.physicalSize.width,
      'physical_height': view.physicalSize.height,
      'device_pixel_ratio': view.devicePixelRatio,
      'warmups_per_case': 1,
      'image_cache': 'cleared_before_each_case; repeated_single_asset',
      'case_order': 'fixture, column/listView/sliverList, sync/async, trial',
    },
    'unmeasured': {
      'parsing': 'No isolated public timing hook',
      'widget_construction': 'No isolated public timing hook',
      'memory': 'No portable reliable per-case allocation instrumentation'
    },
    'results': results
  };
}

// Same monotonic clock used by FrameTiming timestamps.
class TimelineClock {
  static int now() => developer.Timeline.now;
}
