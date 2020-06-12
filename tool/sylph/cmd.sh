#!/bin/bash

set -e
cd $( dirname $( dirname $( dirname ${BASH_SOURCE[0]})))
_pwd=$( pwd )

sudo apt-get update
sudo apt-get install -y python zip

# Install AWS Command Line Interface (AWS CLI)
if [ ! -f awscli-bundle.zip ]; then
  curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
fi
if [ ! -f ./awscli-bundle/install ]; then
  unzip awscli-bundle.zip
fi
if [ ! -f /usr/local/bin/aws ]; then
  sudo ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws
fi

_sylphPath=/tmp/sylph-src
mkdir $_sylphPath && cd $_sylphPath
git init && git remote add origin https://github.com/daohoangson/sylph.git
git fetch --depth 1 origin $FLUTTER_VERSION
git checkout FETCH_HEAD
export "PATH=$PATH:$HOME/.pub-cache/bin"
pub global activate --source path $_sylphPath

cd "$_pwd/packages/example"

_ref=$( git log -n 1 --pretty=format:%H )
{ \
  cat pubspec.yaml | grep -v 'dep_override'; \
  echo; \
  echo 'dependency_overrides:'; \
  echo '  flutter_widget_from_html:'; \
  echo '    git:'; \
  echo '      url: git://github.com/daohoangson/flutter_widget_from_html.git'; \
  echo "      ref: $_ref"; \
  echo '  flutter_widget_from_html_core:'; \
  echo '    git:'; \
  echo '      url: git://github.com/daohoangson/flutter_widget_from_html.git'; \
  echo "      ref: $_ref"; \
  echo '      path: packages/core'; \
} | tee pubspec.yaml.bak \
  && mv -f pubspec.yaml.bak pubspec.yaml

flutter pub get
sylph
