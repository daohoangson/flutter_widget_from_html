#!/bin/bash

set -e

if [ -z "$CIRRUS_CI" ]; then
  if [ ! -z "$CODESPACES" -a "x$TERM_PROGRAM" == "xvscode" ]; then
    echo "Detected VS Codespaces..." >&2
  else
    echo "CIRRUS_CI env var is missing!" >&2
    echo "Jump into a Cirrus shell by executing ./tool/cirrus.sh for development." >&2
    exit 1
  fi
fi
 
cd "$( dirname $( dirname ${BASH_SOURCE[0]}))"/demo_app
flutter pub get
exec flutter test --update-goldens "$@"
