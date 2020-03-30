#!/bin/bash

set -e

cd "$( dirname $( dirname ${BASH_SOURCE[0]}))"/packages/core
exec flutter test --update-goldens test/golden/golden_test.dart
