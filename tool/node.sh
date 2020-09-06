#!/bin/bash

set -e

cd "$( dirname $( dirname ${BASH_SOURCE[0]}))"
_pwd=$( pwd )

exec docker run --rm -it \
  -p 3000:3000 \
  -v "$_pwd:/project" -w /project \
  -v "$_pwd/.node/root/.npm:/root/.npm" \
  node:lts /bin/bash
