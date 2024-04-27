#!/bin/bash

set -euo pipefail

cd "$(dirname $(dirname ${BASH_SOURCE[0]}))"/demo_app

rm -rf android ios macos web
rm -f pubspec.lock

flutter create --platforms android,ios,macos,web --project-name demo_app --org dev.fwfh .
flutter build ios --no-codesign
flutter build macos
