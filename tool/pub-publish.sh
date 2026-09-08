#!/bin/bash

set -euo pipefail

cd "$(dirname $(dirname ${BASH_SOURCE[0]}))"

# Keep this current: pub.dev uses pana to calculate package scores.
dart pub global activate pana

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

  _backup_dir=$(mktemp -d)
  cp pubspec.yaml "$_backup_dir/pubspec.yaml"

  (
    function cleanup {
      cp "$_backup_dir/pubspec.yaml" pubspec.yaml
      rm -f .pubignore
      rm -rf "$_backup_dir"
    }
    trap cleanup EXIT

    # Delete the overrides, pub doesn't like those.
    yq e 'del(.dependency_overrides)' -i pubspec.yaml

    flutter clean
    flutter pub get
    dart format --output=none --set-exit-if-changed .
    flutter analyze --fatal-infos
    if [ -d test ]; then
      flutter test
    fi

    cat .gitignore >.pubignore
    echo '/test/' >>.pubignore
    yq e 'del(.flutter)' -i pubspec.yaml

    # Analyze a disposable copy because pana modifies its input. Most packages
    # must score 160/160. The enhanced package is not yet Wasm-ready, while the
    # two media add-ons intentionally support four of six platforms, so their
    # honest maximum is currently 150/160.
    _pana_threshold=0
    case "$_name" in
      flutter_widget_from_html | fwfh_chewie | fwfh_just_audio)
        _pana_threshold=10
        ;;
    esac
    _pana_dir="$_backup_dir/pana"
    mkdir "$_pana_dir"
    rsync -a \
      --exclude '.dart_tool/' \
      --exclude 'build/' \
      --exclude 'coverage/' \
      --exclude 'pubspec.lock' \
      --exclude 'test/' \
      ./ \
      "$_pana_dir/"
    dart pub global run pana \
      --exit-code-threshold "$_pana_threshold" \
      "$_pana_dir"

    flutter pub publish
  )
}

(cd packages/core && publish)
(cd packages/fwfh_cached_network_image && publish)
(cd packages/fwfh_chewie && publish)
(cd packages/fwfh_just_audio && publish)
(cd packages/fwfh_svg && publish)
(cd packages/fwfh_url_launcher && publish)
(cd packages/fwfh_webview && publish)
(cd packages/enhanced && publish)
