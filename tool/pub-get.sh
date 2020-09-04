#!/bin/sh

set -e

( cd packages/core && flutter pub get )
( cd packages/enhanced && flutter pub get )
( cd demo_app && flutter pub get )
