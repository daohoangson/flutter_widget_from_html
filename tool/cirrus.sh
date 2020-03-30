#!/bin/bash

set -e

cd "$( dirname $( dirname ${BASH_SOURCE[0]}))"
_pwd=$( pwd )

mkdir -p .cirrus/core
touch .cirrus/packages
touch .cirrus/core/packages

exec docker run --rm -it \
  -e CIRRUS_CI=true \
  -v "$_pwd:/project" -w /project \
  -v "$_pwd/.cirrus/dart_tool:/project/.dart_tool" \
  -v "$_pwd/.cirrus/build:/project/build" \
  -v "$_pwd/.cirrus/packages:/project/.packages" \
  -v "$_pwd/.cirrus/core/dart_tool:/roject/packages/core/.dart_tool" \
  -v "$_pwd/.cirrus/core/build:/roject/packages/core/build" \
  -v "$_pwd/.cirrus/core/packages:/project/packages/core/.packages" \
  -v "$_pwd/.cirrus/pub-cache:/home/cirrus/.pub-cache" \
  cirrusci/flutter:v1.12.13-hotfix.5 /bin/bash
