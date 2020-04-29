#!/bin/bash

set -e

if [ -z "$CIRRUS_CI" ]; then
  echo "CIRRUS_CI env var is missing!" >&2
  echo "Jump into a Cirrus shell by executing ./tool/cirrus.sh for development." >&2
  exit 1
fi

cd "$( dirname $( dirname ${BASH_SOURCE[0]}))"/packages/example
exec flutter test --update-goldens
