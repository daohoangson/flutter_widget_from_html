#!/bin/bash

set -euo pipefail

cd "$(dirname $(dirname ${BASH_SOURCE[0]}))"/demo_app

if ! which patrol; then
  dart pub global activate patrol_cli
fi

exec patrol test -t integration_test/auto_resize_test.dart
