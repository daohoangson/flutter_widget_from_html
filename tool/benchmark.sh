#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../benchmark"
device="${1:-linux}"
platform="$device"
if [[ "$device" == chrome ]]; then platform=web; fi
case "$platform" in linux|macos|web) ;; *) echo 'Use linux, macos, or chrome (see README for web driver setup).' >&2; exit 2;; esac
if [[ ! -d "$platform" ]]; then
  scaffold=$(mktemp -d)
  trap 'rm -rf "$scaffold"' EXIT
  flutter create --platforms="$platform" --project-name=fwfh_benchmark --no-pub "$scaffold" >/dev/null
  cp -R "$scaffold/$platform" "$platform"
fi
flutter pub get
mkdir -p results
rm -f results/measurements.json
cp pubspec.lock results/pubspec.lock
flutter --version --machine | dart run tool/metadata.dart flutter > results/flutter.json
flutter devices --machine | dart run tool/metadata.dart device "$device" > results/devices.json
git rev-parse HEAD > results/revision.txt
printf '%s\n' "$device" > results/selected-device.txt
flutter drive --profile -d "$device" \
  --driver=test_driver/benchmark.dart \
  --target=integration_test/benchmark_test.dart \
  --dart-define="REPETITIONS=${REPETITIONS:-3}" \
  --dart-define="SMOKE=${SMOKE:-false}"
