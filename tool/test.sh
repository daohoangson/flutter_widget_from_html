#!/bin/bash

set -e

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
