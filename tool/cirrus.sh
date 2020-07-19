#!/bin/bash

set -e

cd "$( dirname $( dirname ${BASH_SOURCE[0]}))"
_pwd=$( pwd )

mkdir -p .cirrus/packages/core
touch .cirrus/packages/core/.packages

mkdir -p .cirrus/packages/core/example
touch .cirrus/packages/core/example/.packages

mkdir -p .cirrus/packages/enhanced
touch .cirrus/packages/enhanced/.packages

mkdir -p .cirrus/packages/enhanced/example
touch .cirrus/packages/enhanced/example/.packages

mkdir -p .cirrus/demo_app
touch .cirrus/demo_app/.packages

_dockerImage=cirrusci/flutter:stable
docker pull "$_dockerImage"

exec docker run --rm -it \
  -e CIRRUS_CI=true \
  -v "$_pwd:/project" -w /project \
  -v "$_pwd/.cirrus/packages/core/.dart_tool:/project/packages/core/.dart_tool" \
  -v "$_pwd/.cirrus/packages/core/build:/project/packages/core/build" \
  -v "$_pwd/.cirrus/packages/core/.packages:/project/packages/core/.packages" \
  -v "$_pwd/.cirrus/packages/core/example/.dart_tool:/project/packages/core/example/.dart_tool" \
  -v "$_pwd/.cirrus/packages/core/example/build:/project/packages/core/example/build" \
  -v "$_pwd/.cirrus/packages/core/example/.packages:/project/packages/core/example/.packages" \
  -v "$_pwd/.cirrus/packages/enhanced/.dart_tool:/project/packages/enhanced/.dart_tool" \
  -v "$_pwd/.cirrus/packages/enhanced/build:/project/packages/enhanced/build" \
  -v "$_pwd/.cirrus/packages/enhanced/.packages:/project/packages/enhanced/.packages" \
  -v "$_pwd/.cirrus/packages/enhanced/example/.dart_tool:/project/packages/enhanced/example/.dart_tool" \
  -v "$_pwd/.cirrus/packages/enhanced/example/build:/project/packages/enhanced/example/build" \
  -v "$_pwd/.cirrus/packages/enhanced/example/.packages:/project/packages/enhanced/example/.packages" \
  -v "$_pwd/.cirrus/demo_app/.dart_tool:/project/demo_app/.dart_tool" \
  -v "$_pwd/.cirrus/demo_app/build:/project/demo_app/build" \
  -v "$_pwd/.cirrus/demo_app/.packages:/project/demo_app/.packages" \
  -v "$_pwd/.cirrus/pub-cache:/home/cirrus/.pub-cache" \
  "$_dockerImage" /bin/bash
