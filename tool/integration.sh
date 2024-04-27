#!/bin/bash

set -euo pipefail

cd "$(dirname $(dirname ${BASH_SOURCE[0]}))"/demo_app

if ! which patrol; then
  dart pub global activate patrol_cli
fi

flutter --no-version-check --suppress-analytics --version --machine

exec patrol test --no-uninstall --target integration_test/auto_resize_test.dart
