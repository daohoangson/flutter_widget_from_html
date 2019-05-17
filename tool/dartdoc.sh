#!/bin/bash

set -e

cd "$( dirname $( dirname ${BASH_SOURCE[0]}))"

# https://github.com/dart-lang/dartdoc/issues/1431
_exclude=dart:ui,dart:async,dart:collection,dart:convert,dart:core,dart:developer,dart:math,dart:typed_data,dart:io,dart:isolate

exec dartdoc --exclude $_exclude
