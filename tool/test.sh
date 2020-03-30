#!/bin/bash

set -e

if [ -z "$CIRRUS_CI" ]; then
  echo "CIRRUS_CI env var is missing!" >&2
  echo "Jump into a Cirrus shell by executing ./tool/cirrus.sh for development." >&2
  exit 1
fi

_testArgs=''
if [ ! -z "$COVERAGE" ]; then
  _testArgs="${_testArgs} --coverage"
fi

cd "$( dirname $( dirname ${BASH_SOURCE[0]}))"/packages/core
flutter test $( echo $_testArgs )
echo 'flutter_widget_from_html_core OK'

cd ../..
flutter test $( echo $_testArgs )
echo 'flutter_widget_from_html OK'
