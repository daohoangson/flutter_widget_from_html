#!/bin/sh

set -e

find . -name 'pubspec.lock' -delete

(cd packages/core && rm -f pubspec.lock && flutter pub get)
(cd packages/fwfh_cached_network_image && rm -f pubspec.lock && flutter pub get)
(cd packages/fwfh_chewie && rm -f pubspec.lock && flutter pub get)
(cd packages/fwfh_just_audio && rm -f pubspec.lock && flutter pub get)
(cd packages/fwfh_selectable_text && rm -f pubspec.lock && flutter pub get)
(cd packages/fwfh_svg && rm -f pubspec.lock && flutter pub get)
(cd packages/fwfh_text_style && rm -f pubspec.lock && flutter pub get)
(cd packages/fwfh_url_launcher && rm -f pubspec.lock && flutter pub get)
(cd packages/fwfh_webview && rm -f pubspec.lock && flutter pub get)
(cd packages/enhanced && rm -f pubspec.lock && flutter pub get)
(cd demo_app && flutter pub get)
