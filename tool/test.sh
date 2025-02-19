#!/bin/bash

set -euo pipefail

(
  cd ./packages/core &&
    dart format --set-exit-if-changed --output none . &&
    flutter analyze &&
    flutter test "$@" &&
    echo 'packages/core OK'
)

(
  cd ./packages/fwfh_just_audio &&
    dart format --set-exit-if-changed --output none . &&
    flutter analyze &&
    flutter test "$@" &&
    echo 'packages/fwfh_just_audio OK'
)

(
  cd ./packages/fwfh_svg &&
    dart format --set-exit-if-changed --output none . &&
    flutter analyze &&
    flutter test "$@" &&
    echo 'packages/fwfh_svg OK'
)

if [ -z ${UPDATE_GOLDENS+x} ]; then
  # UPDATE_GOLDENS is unset, run all packages
  (
    cd ./packages/fwfh_cached_network_image &&
      dart format --set-exit-if-changed --output none . &&
      flutter analyze &&
      flutter test "$@" &&
      echo 'packages/fwfh_cached_network_image OK'
  )

  (
    cd ./packages/fwfh_chewie &&
      dart format --set-exit-if-changed --output none . &&
      flutter analyze &&
      flutter test "$@" &&
      echo 'packages/fwfh_chewie OK'
  )

  (
    cd ./packages/fwfh_url_launcher &&
      dart format --set-exit-if-changed --output none . &&
      flutter analyze &&
      flutter test "$@" &&
      echo 'packages/fwfh_url_launcher OK'
  )

  (
    cd ./packages/fwfh_webview &&
      dart format --set-exit-if-changed --output none . &&
      flutter analyze &&
      flutter test "$@" &&
      echo 'packages/fwfh_webview OK'
  )

  if [ ! -z ${CHROMEDRIVER_PORT_4444+x} ]; then
    (
      cd ./packages/fwfh_webview &&
        flutter drive \
          -d web-server \
          --driver=test_driver/integration_test.dart \
          --target=integration_test/js_interop_test.dart &&
        echo 'packages/fwfh_webview JavaScript interop OK'
    )
  fi

  (
    cd ./packages/enhanced &&
      dart format --set-exit-if-changed --output none . &&
      flutter analyze &&
      flutter test "$@" &&
      echo 'packages/enhanced OK'
  )
fi

(
  cd ./demo_app &&
    dart format --set-exit-if-changed --output none . &&
    flutter analyze &&
    flutter test "$@" &&
    echo 'demo_app OK'
)
