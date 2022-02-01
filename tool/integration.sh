#!/bin/bash

set -e

cd "$(dirname $(dirname ${BASH_SOURCE[0]}))"/demo_app

exec flutter test --reporter expanded integration_test/auto_resize_test.dart
