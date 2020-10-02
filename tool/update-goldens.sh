#!/bin/bash

set -e

( \
  cd packages/core; \
  flutter pub get; \
  flutter test --plain-name=Golden --update-goldens "$@"; \
)

( \
  cd packages/enhanced; \
  flutter pub get; \
  flutter test --plain-name=Golden --update-goldens "$@"; \
)

( \
  cd demo_app; \
  flutter pub get; \
  flutter test --update-goldens "$@"; \
)
