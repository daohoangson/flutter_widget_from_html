#!/bin/sh

set -e

# Install latest Flutter stable
sudo apt-get install -y jq
curl https://storage.googleapis.com/flutter_infra/releases/releases_linux.json -Lo /tmp/releases.json
_baseUrl=$( cat /tmp/releases.json | jq -r .base_url )
_stableHash=$( cat /tmp/releases.json | jq -r .current_release.stable )
_stableArchive=$( cat /tmp/releases.json | jq -r ".releases[] | select(.hash == \"$_stableHash\") | .archive" )
curl $_baseUrl/$_stableArchive -vo /tmp/flutter.tar.xz
tar -xf /tmp/flutter.tar.xz
mv ./flutter $HOME/flutter
echo 'PATH=$PATH:$HOME/flutter/bin' >> $HOME/.profile

# pub get
flutter pub get
( cd ./packages/core && flutter pub get )
( cd ./packages/example && flutter pub get )
