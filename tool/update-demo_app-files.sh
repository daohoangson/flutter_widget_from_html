#!/bin/bash

set -euo pipefail

cd "$(dirname $(dirname ${BASH_SOURCE[0]}))"/demo_app

flutter create --platforms android,ios,macos,web --project-name demo_app --org dev.fwfh .
flutter build ios --no-codesign
flutter build macos
