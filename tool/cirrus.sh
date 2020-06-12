#!/bin/bash

set -e

cd "$( dirname $( dirname ${BASH_SOURCE[0]}))"
_pwd=$( pwd )

mkdir -p .cirrus/example
touch .cirrus/.packages
touch .cirrus/example/.packages

mkdir -p .cirrus/packages/core
touch .cirrus/packages/core/.packages

mkdir -p .cirrus/packages/core/example
touch .cirrus/packages/core/example/.packages

mkdir -p .cirrus/packages/example
touch .cirrus/packages/example/.packages

exec docker run --rm -it \
  -e CIRRUS_CI=true \
  -v "$_pwd:/project" -w /project \
  -v "$_pwd/.cirrus/.dart_tool:/project/.dart_tool" \
  -v "$_pwd/.cirrus/build:/project/build" \
  -v "$_pwd/.cirrus/.packages:/project/.packages" \
  -v "$_pwd/.cirrus/example/.dart_tool:/project/example/.dart_tool" \
  -v "$_pwd/.cirrus/example/build:/project/example/build" \
  -v "$_pwd/.cirrus/example/.packages:/project/example/.packages" \
  -v "$_pwd/.cirrus/packages/core/.dart_tool:/project/packages/core/.dart_tool" \
  -v "$_pwd/.cirrus/packages/core/build:/project/packages/core/build" \
  -v "$_pwd/.cirrus/packages/core/.packages:/project/packages/core/.packages" \
  -v "$_pwd/.cirrus/packages/core/example/.dart_tool:/project/packages/core/example/.dart_tool" \
  -v "$_pwd/.cirrus/packages/core/example/build:/project/packages/core/example/build" \
  -v "$_pwd/.cirrus/packages/core/example/.packages:/project/packages/core/example/.packages" \
  -v "$_pwd/.cirrus/packages/example/.dart_tool:/project/packages/example/.dart_tool" \
  -v "$_pwd/.cirrus/packages/example/build:/project/packages/example/build" \
  -v "$_pwd/.cirrus/packages/example/.packages:/project/packages/example/.packages" \
  -v "$_pwd/.cirrus/pub-cache:/home/cirrus/.pub-cache" \
  cirrusci/flutter:1.17.3 /bin/bash
