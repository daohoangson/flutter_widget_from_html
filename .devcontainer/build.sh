#!/bin/sh

set -euo pipefail

curl https://storage.googleapis.com/flutter_infra/releases/releases_linux.json -Lo /tmp/releases.json
_baseUrl=$( cat /tmp/releases.json | jq -r .base_url )
_stableHash=$( cat /tmp/releases.json | jq -r .current_release.stable )
_stableArchive=$( cat /tmp/releases.json | jq -r ".releases[] | select(.hash == \"$_stableHash\") | .archive" )
rm /tmp/releases.json

cd $HOME
curl $_baseUrl/$_stableArchive -vo /tmp/flutter.tar.xz
tar -xf /tmp/flutter.tar.xz
