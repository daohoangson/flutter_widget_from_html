#!/bin/bash

set -euo pipefail

cd "$(dirname $(dirname ${BASH_SOURCE[0]}))"/demo_app

if [ ! -z "$JAVA_HOME_17_X64" ]; then
  # switch to Java 17 in GitHub Actions
  export JAVA_HOME=$JAVA_HOME_17_X64
  echo "JAVA_HOME=$JAVA_HOME"
fi

exec flutter test --reporter expanded integration_test/auto_resize_test.dart
