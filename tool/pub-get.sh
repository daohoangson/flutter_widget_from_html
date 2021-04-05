#!/bin/sh

set -e

find . -name 'pubspec.lock' -delete

( cd packages/core && flutter pub get )
( cd packages/fwfh_cached_network_image && flutter pub get )
( cd packages/fwfh_chewie && flutter pub get )
( cd packages/fwfh_svg && flutter pub get )
( cd packages/fwfh_url_launcher && flutter pub get )
( cd packages/fwfh_webview && flutter pub get )
( cd packages/enhanced && flutter pub get )
( cd demo_app && flutter pub get )
