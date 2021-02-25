#!/bin/bash

set -e

( \
  cd ./packages/core \
  && flutter pub get \
  && flutter test "$@" \
  && echo 'packages/core OK' \
)

( \
  cd ./packages/enhanced \
  && flutter pub get \
  && flutter test "$@" \
  && echo 'packages/enhanced OK' \
)

( \
  cd ./demo_app \
  && flutter pub get \
  && flutter test "$@" \
  && echo 'demo_app OK' \
)
