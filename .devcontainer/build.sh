#!/bin/bash

set -euo pipefail

brew tap leoafarias/fvm
brew install fvm

fvm install stable
fvm global stable

flutter precache
flutter doctor -v
