#!/bin/bash

set -e

( \
  cd ./packages/core \
  && flutter test "$@" \
  && echo 'packages/core OK' \
)

( \
  cd ./packages/enhanced \
  flutter test "$@" \
  && echo 'packages/enhanced OK' \
)

( \
  cd ./packages/example \
  && flutter test "$@" \
  && echo 'packages/example OK' \
)
