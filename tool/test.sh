#!/bin/bash

set -e

(
  cd ./packages/core &&
    flutter analyze &&
    flutter test "$@" &&
    echo 'packages/core OK'
)

(
  cd ./packages/fwfh_text_style &&
    flutter analyze &&
    flutter test "$@" &&
    echo 'packages/fwfh_text_style OK'
)

(
  cd ./packages/fwfh_svg &&
    flutter analyze &&
    flutter test "$@" &&
    echo 'packages/fwfh_svg OK'
)

if [ -z "$UPDATE_GOLDENS" ]; then
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
    cd ./packages/fwfh_just_audio &&
      flutter analyze &&
      flutter test "$@" &&
      echo 'packages/fwfh_just_audio OK'
  )

  (
    cd ./packages/fwfh_selectable_text &&
      flutter analyze &&
      flutter test "$@" &&
      echo 'packages/fwfh_selectable_text OK'
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
