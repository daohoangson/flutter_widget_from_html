#!/bin/bash

set -e

# https://github.com/dart-lang/dartdoc/issues/1431
_exclude=
_exclude=$_exclude,dart:async
_exclude=$_exclude,dart:collection
_exclude=$_exclude,dart:convert
_exclude=$_exclude,dart:core
_exclude=$_exclude,dart:developer
_exclude=$_exclude,dart:ffi
_exclude=$_exclude,dart:html
_exclude=$_exclude,dart:io
_exclude=$_exclude,dart:isolate
_exclude=$_exclude,dart:js
_exclude=$_exclude,dart:js_util
_exclude=$_exclude,dart:math
_exclude=$_exclude,dart:typed_data
_exclude=$_exclude,dart:ui

exec dartdoc --exclude $_exclude
