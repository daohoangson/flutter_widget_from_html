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

# https://github.com/mmcc007/sylph
_sylphPath=/tmp/sylph-src
mkdir $_sylphPath && cd $_sylphPath
git init && git remote add origin https://github.com/daohoangson/sylph.git
git fetch --depth 1 origin $FLUTTER_VERSION
git checkout FETCH_HEAD
export "PATH=$PATH:$HOME/.pub-cache/bin"
pub global activate --source path $_sylphPath

cd "$_pwd/packages/example"
flutter pub get
sylph
