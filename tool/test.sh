#!/bin/bash

set -e

( \
  cd ./packages/core \
  && flutter test "$@" \
  && echo 'flutter_widget_from_html_core OK' \
)

( \
  flutter test "$@" \
  && echo 'flutter_widget_from_html OK' \
)

( \
  cd ./packages/example \
  && flutter test "$@" \
  && echo 'example OK' \
)
