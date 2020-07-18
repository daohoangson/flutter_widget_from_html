#!/bin/sh

set -e

source $HOME/.profile

flutter pub get
( cd ./packages/core && flutter pub get )
( cd ./packages/example && flutter pub get )
