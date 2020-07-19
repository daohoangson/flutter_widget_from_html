#!/bin/bash

set -e

flutter pub get

# https://github.com/dart-lang/dartdoc/issues/1949
export FLUTTER_ROOT=$( dirname $( dirname $( which flutter ) ) )
$FLUTTER_ROOT/bin/cache/dart-sdk/bin/pub global activate dartdoc

exec $FLUTTER_ROOT/bin/cache/dart-sdk/bin/pub global run dartdoc
