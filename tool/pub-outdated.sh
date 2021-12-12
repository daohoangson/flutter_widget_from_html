#!/bin/sh

set -e

(cd packages/core && pwd && flutter pub outdated || true)
(cd packages/fwfh_cached_network_image && pwd && flutter pub outdated || true)
(cd packages/fwfh_chewie && pwd && flutter pub outdated || true)
(cd packages/fwfh_just_audio && pwd && flutter pub outdated || true)
(cd packages/fwfh_selectable_text && pwd && flutter pub outdated || true)
(cd packages/fwfh_svg && pwd && flutter pub outdated || true)
(cd packages/fwfh_text_style && pwd && flutter pub outdated || true)
(cd packages/fwfh_url_launcher && pwd && flutter pub outdated || true)
(cd packages/fwfh_webview && pwd && flutter pub outdated || true)
(cd packages/enhanced && pwd && flutter pub outdated || true)
(cd demo_app && pwd && flutter pub outdated || true)
