#!/bin/bash

set -euo pipefail

(
  cd ./packages/core &&
    flutter analyze &&
    flutter test "$@" &&
    echo 'packages/core OK'
)

(
  cd ./packages/fwfh_just_audio &&
    flutter analyze &&
    flutter test "$@" &&
    echo 'packages/fwfh_just_audio OK'
)

(
  cd ./packages/fwfh_svg &&
    flutter analyze &&
    flutter test "$@" &&
    echo 'packages/fwfh_svg OK'
)

if [ -z ${UPDATE_GOLDENS+x} ]; then
  # UPDATE_GOLDENS is unset, run all packages
  (
    cd ./packages/fwfh_cached_network_image &&
      flutter analyze &&
      flutter test "$@" &&
      echo 'packages/fwfh_cached_network_image OK'
  )

  (
    cd ./packages/fwfh_chewie &&
      flutter analyze &&
      flutter test "$@" &&
      echo 'packages/fwfh_chewie OK'
  )

  (
    cd ./packages/fwfh_url_launcher &&
      flutter analyze &&
      flutter test "$@" &&
      echo 'packages/fwfh_url_launcher OK'
  )

  (
    cd ./packages/fwfh_webview &&
      flutter analyze &&
      flutter test "$@" &&
      echo 'packages/fwfh_webview OK'
  )

  (
    cd ./packages/enhanced &&
      flutter analyze &&
      flutter test "$@" &&
      echo 'packages/enhanced OK'
  )
fi

(
  cd ./demo_app &&
    flutter analyze &&
    flutter test "$@" &&
    echo 'demo_app OK'
)
