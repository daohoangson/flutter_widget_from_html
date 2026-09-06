# Rendering benchmark

Standalone app against the local **core** package. Production code and the demo
are untouched. Synthetic fixtures in `lib/fixtures.dart` cover 180 article
sections, a 300 × 8 table, 100 nested list groups, and 240 bundled PNG images.
The image fixture repeats one original generated 256 × 128 RGB gradient
(`fixtures/tile.png`); it measures repeated local-image layout/painting, not a
large set of distinct image decodes. Fixtures contain no network resources.
Dependency/SDK installation may require network; measured runs do not.

## Reproduce

Install Flutter (floor 3.32), native desktop build tools, and dependencies first.
From the repository root:

```sh
./tool/benchmark.sh macos  # or linux
REPETITIONS=5 ./tool/benchmark.sh linux
SMOKE=true REPETITIONS=1 ./tool/benchmark.sh macos
```

The script generates ignored platform scaffolding using your SDK, resolves the
standalone package, and runs `flutter drive --profile`. It never updates existing
package manifests. Keep the app visible, unobscured, and focused. Use the same
SDK, renderer, hardware, power/thermal state, window size, and refresh rate for
comparisons. CI pins Flutter 3.47.0 and uses Xvfb at 1280 × 900; virtualized Linux
results are advisory and are not representative of a physical GPU/device.
There are no regression thresholds. Establish repeatable baselines and variance
before defining any. Each run overwrites `benchmark/results/`; archive it first.

For web, start a compatible ChromeDriver on port 4444, then use
`./tool/benchmark.sh chrome`. Web support is an optional, separately comparable
experiment: Flutter `compute` executes on the **current event loop** on web,
not a background isolate. Engine `FrameTiming` samples may be unavailable;
empty samples produce null percentiles and `frame_status: unavailable`, never
zero-cost claims. Web driver/engine support depends on the installed SDK.

Until dependency-setup PR #1623 merges, the legacy root `tool/pub-get.sh`
deletes all lockfiles, including `benchmark/pubspec.lock`. If you ran it, restore
the committed benchmark lock before benchmarking, from the repository root:
`git restore -- benchmark/pubspec.lock`.

## Protocol and interpretation

All 24 combinations run in deterministic fixture → render mode → sync/async
order, with one discarded warmup per case and three measured trials by default.
HTML caching is explicitly disabled for both sync and async. The Flutter image
cache is cleared between trials; process, shaders, fonts, and OS caches remain
warm. This is a warm-process benchmark, not app startup. Fixed ordering can bias
thermal results; repeat whole runs and compare per-case distributions.

* `first_body_paint_us`: monotonic elapsed time from immediately before `runApp`
  until the HTML body's first paint returns, detected with a benchmark-only
  factory wrapper. Includes mounting, parsing, building, layout, and UI painting.
  Excludes fixture generation. It is a **first-display proxy**, not physical
  screen presentation, raster completion, or all-images-decoded readiness.
  Initial async loading placeholders do not trigger the body probe.
* After 500 ms settling, scroll six times by 80% of the viewport, each with a
  500 ms linear animation. Lazy extents are re-read for each step; this avoids
  comparing an estimated full-document extent with an eager exact extent.
  The table remains a single top-level block, so lazy modes may offer little
  benefit. Distance is recorded so ineffective scrolling is visible.
* Frame callbacks are collected through a one-second delivery drain and filtered
  by the engine's vsync timestamps to the scroll interval. Raw build, raster,
  and total-span microseconds plus nearest-rank p50/p90/p99/max are emitted.
  Total span is engine pipeline latency, not presented-frame interval or FPS.
  Zero samples are explicitly unavailable. No arbitrary jank threshold is used.
* Parsing, widget construction, and memory are explicitly **unmeasured**: there
  is no reliable isolated public instrumentation here. Do not infer them from
  first paint or build duration. No renderer instrumentation is added.
* Smoke mode uses one 100 ms scroll step. Even in profile mode its results are
  harness checks, not baseline performance numbers.

`results/measurements.json` contains versioned JSON, per-trial raw samples,
platform/web/compute execution, viewport, pixel ratio, mode and protocol metadata.
Sibling `pubspec.lock` (resolved dependencies), `flutter.json`, `devices.json`, `selected-device.txt`, and `revision.txt`
record SDK/engine/Dart versions, discovered devices, selected target and source
revision. Archive the whole directory together; device inventory is not the
selected-device identity. Record any local diff alongside the revision when
benchmarking uncommitted changes.

## Validate

```sh
cd benchmark
flutter pub get
flutter analyze
flutter test
```

The focused tests check deterministic resource-free fixtures and percentile
semantics. The integration run exercises all render/async combinations and both
box and sliver paint probes. No golden generation is needed. The manual-only
`.github/workflows/benchmark.yml` uploads results even after failures; a failing
harness still fails the job, while performance values never gate other work.
