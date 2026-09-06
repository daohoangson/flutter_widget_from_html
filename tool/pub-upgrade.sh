#!/bin/bash

set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

# Refresh resolutions within the declared dependency and SDK constraints.

(cd packages/core && flutter pub upgrade)
(cd packages/fwfh_cached_network_image && flutter pub upgrade)
(cd packages/fwfh_chewie && flutter pub upgrade)
(cd packages/fwfh_just_audio && flutter pub upgrade)
(cd packages/fwfh_svg && flutter pub upgrade)
(cd packages/fwfh_url_launcher && flutter pub upgrade)
(cd packages/fwfh_webview && flutter pub upgrade)
(cd packages/enhanced && flutter pub upgrade)
(cd demo_app && flutter pub upgrade)
