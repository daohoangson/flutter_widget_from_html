#!/bin/bash

set -e

cd "$( dirname $( dirname ${BASH_SOURCE[0]}))"/packages/core
flutter test
echo 'flutter_widget_from_html_core OK'

cd ../..
flutter test
echo 'flutter_widget_from_html OK'
