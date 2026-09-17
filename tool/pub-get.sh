#!/bin/bash

set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

# Reuse existing resolutions where compatible with the manifests.

(cd packages/core && flutter pub get)
(cd packages/fwfh_cached_network_image && flutter pub get)
(cd packages/fwfh_chewie && flutter pub get)
(cd packages/fwfh_just_audio && flutter pub get)
(cd packages/fwfh_svg && flutter pub get)
(cd packages/fwfh_url_launcher && flutter pub get)
(cd packages/fwfh_webview && flutter pub get)
(cd packages/enhanced && flutter pub get)
(cd demo_app && flutter pub get)
