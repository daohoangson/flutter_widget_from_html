#!/bin/sh

set -e

echo HOME=$HOME
echo PATH=$PATH
cat $HOME/.profile

flutter pub get
( cd ./packages/core && flutter pub get )
( cd ./packages/example && flutter pub get )
