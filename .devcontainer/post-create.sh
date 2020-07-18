#!/bin/sh

set -e

flutter pub get
( cd ./packages/core && flutter pub get )
( cd ./packages/example && flutter pub get )
