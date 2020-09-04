#!/bin/bash

set -e

cd "$( dirname $( dirname ${BASH_SOURCE[0]}))"/demo_app
flutter pub get
exec flutter test --update-goldens "$@"
