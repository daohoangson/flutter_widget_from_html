#!/bin/bash

set -e

( \
  cd ./packages/core \
  && flutter pub get \
  && flutter test "$@" \
  && echo 'packages/core OK' \
)

if [ -z "$UPDATE_GOLDENS" ]; then
  ( \
    cd ./packages/fwfh_chewie \
    && flutter pub get \
    && flutter test "$@" \
    && echo 'packages/fwfh_chewie OK' \
  )

  ( \
    cd ./packages/fwfh_svg \
    && flutter pub get \
    && flutter test "$@" \
    && echo 'packages/fwfh_svg OK' \
  )

  ( \
    cd ./packages/fwfh_webview \
    && flutter pub get \
    && flutter test "$@" \
    && echo 'packages/fwfh_webview OK' \
  )

  ( \
    cd ./packages/enhanced \
    && flutter pub get \
    && flutter test "$@" \
    && echo 'packages/enhanced OK' \
  )
fi

( \
  cd ./demo_app \
  && flutter pub get \
  && flutter test "$@" \
  && echo 'demo_app OK' \
)
