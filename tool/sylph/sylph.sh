#!/bin/bash

set -e
cd $( dirname $( dirname $( dirname ${BASH_SOURCE[0]})))
_pwd=$( pwd )

_sylphPath=/tmp/sylph-src
mkdir $_sylphPath && cd $_sylphPath
git init && git remote add origin https://github.com/daohoangson/sylph.git
git fetch --depth 1 origin $( flutter --version | head -n 1 | sed 's/^Flutter //' | sed 's/[^a-z0-9.-].*$//' )
git checkout FETCH_HEAD
pub global activate --source path $_sylphPath

cd "$_pwd/demo_app"

_ref=$( git log -n 1 --pretty=format:%H )
{ \
  cat pubspec.yaml | grep -v 'dep_override'; \
  echo; \
  echo 'dependency_overrides:'; \
  echo '  flutter_widget_from_html:'; \
  echo '    git:'; \
  echo '      url: git://github.com/daohoangson/flutter_widget_from_html.git'; \
  echo "      ref: $_ref"; \
  echo '      path: packages/enhanced'; \
  echo '  flutter_widget_from_html_core:'; \
  echo '    git:'; \
  echo '      url: git://github.com/daohoangson/flutter_widget_from_html.git'; \
  echo "      ref: $_ref"; \
  echo '      path: packages/core'; \
} | tee pubspec.yaml.bak \
  && mv -f pubspec.yaml.bak pubspec.yaml

flutter pub get

exec $HOME/.pub-cache/bin/sylph
