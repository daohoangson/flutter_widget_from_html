#!/bin/bash

set -e

cd "$(dirname $(dirname ${BASH_SOURCE[0]}))"

function publish {
  echo
  echo Publishing $(basename $(pwd))...

  if [ ! -z "$(git status --porcelain .)" ]; then
    echo 'The current directory has git changes.' >&2
    return
  fi

  _name=$(yq e .name pubspec.yaml)
  _version=$(yq e .version pubspec.yaml)
  if curl -sfo/dev/null "https://pub.dev/packages/$_name/versions/$_version"; then
    echo "$_name@$_version already exists on pub.dev." >&2
    return
  fi

  # delete the overrides, pub doesn't like that
  yq e 'del(.dependency_overrides)' -i pubspec.yaml

  # `pub get` should work...
  flutter clean && flutter pub get
  # tests should work...
  if [ -d test ]; then
    flutter test
  fi

  cat .gitignore >.pubignore
  echo '/test/' >>.pubignore
  yq e 'del(.flutter)' -i pubspec.yaml

  flutter pub publish

  # revert the changes
  git checkout .
  rm .pubignore
}

(cd packages/core && publish)
(cd packages/fwfh_cached_network_image && publish)
(cd packages/fwfh_chewie && publish)
(cd packages/fwfh_just_audio && publish)
(cd packages/fwfh_selectable_text && publish)
(cd packages/fwfh_svg && publish)
(cd packages/fwfh_text_style && publish)
(cd packages/fwfh_url_launcher && publish)
(cd packages/fwfh_webview && publish)
(cd packages/enhanced && publish)
