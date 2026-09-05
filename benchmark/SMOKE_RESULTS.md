# Local smoke validation

2026-09-05: Flutter 3.47.0 / Dart 3.13.0, macOS 15.6 (24G84), darwin-arm64, profile mode. Physical viewport 1600 × 1200, pixel ratio 2 (800 × 600 logical).

`SMOKE=true REPETITIONS=1 ./tool/benchmark.sh macos` passed all 24 combinations in 88 seconds, plus one discarded warmup each. Every trial scrolled 480 logical pixels and captured 7–14 engine frame samples. This is a single short smoke trial, **not a baseline or statistically supported comparison**.

| Fixture | Mode | Sync first paint (ms) | Async first paint (ms) |
|---|---|---:|---:|
| article | column | 60.59 | 63.62 |
| article | listView | 45.46 | 45.68 |
| article | sliverList | 47.90 | 54.10 |
| table | column | 276.72 | 268.61 |
| table | listView | 185.75 | 187.58 |
| table | sliverList | 179.06 | 187.46 |
| lists | column | 116.79 | 111.00 |
| lists | listView | 41.00 | 163.76 |
| lists | sliverList | 126.04 | 115.97 |
| images | column | 79.31 | 82.43 |
| images | listView | 43.79 | 41.14 |
| images | sliverList | 33.84 | 32.15 |

Across cases, scrolling build p50 ranged from 0.107–4.523 ms and raster p50 from 0.310–1.458 ms. Raw per-frame samples and SDK/device metadata are in the ignored `results/` directory produced by this run.

Validation: `flutter analyze` clean; eight focused tests passed; `bash -n tool/benchmark.sh` passed. No goldens generated.

Limitations: full three-repetition/six-step protocol, Linux CI, and ChromeDriver/web execution were not run locally. An initial interrupted attempt reported a foregrounding failure; the successful rerun did not. The successful run printed “integration_test plugin was not detected” at teardown, but the Flutter driver returned success and wrote all 24 JSON results. Native XCTest/instrumentation forwarding is not validated. Parsing, widget construction, memory, image-decode completion, and physical presentation remain unmeasured as documented in README.md.
