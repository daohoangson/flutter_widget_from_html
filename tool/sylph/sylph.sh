#!/bin/bash

set -e
cd $(dirname $(dirname $(dirname ${BASH_SOURCE[0]})))
_pwd=$(pwd)

flutter --version

_sylphPath=/tmp/sylph-src
mkdir $_sylphPath && cd $_sylphPath
git init && git remote add origin https://github.com/daohoangson/sylph.git
git fetch --depth 1 origin $(flutter --version | head -n 1 | sed 's/^Flutter //' | sed 's/[^a-z0-9.-].*$//')
git checkout FETCH_HEAD
pub global activate --source path $_sylphPath

cd "$_pwd/demo_app"

_ref=$(git log -n 1 --pretty=format:%H)
_updateDep() {
  __yaml='pubspec.yaml'
  __package=$1
  __path=${2:-"packages/$__package"}
  yq e ".dependency_overrides.$__package.git.url = \"git://github.com/daohoangson/flutter_widget_from_html.git\"" -i $__yaml
  yq e ".dependency_overrides.$__package.git.ref = \"$_ref\"" -i $__yaml
  yq e ".dependency_overrides.$__package.git.path = \"$__path\"" -i $__yaml
  yq e "del(.dependency_overrides.$__package.path)" -i $__yaml
}
_updateDep 'flutter_widget_from_html_core' 'packages/core'
_updateDep 'fwfh_cached_network_image'
_updateDep 'fwfh_chewie'
_updateDep 'fwfh_just_audio'
_updateDep 'fwfh_selectable_text'
_updateDep 'fwfh_svg'
_updateDep 'fwfh_text_style'
_updateDep 'fwfh_url_launcher'
_updateDep 'fwfh_webview'
_updateDep 'flutter_widget_from_html' 'packages/enhanced'

flutter pub get

exec sylph
